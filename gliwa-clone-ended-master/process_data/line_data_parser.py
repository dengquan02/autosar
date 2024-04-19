from process_data.FSM import TaskThreadFSM, IsrThreadFSM
from helpers import write_json_to


def calc_init_state(is_same_schedule: bool, event_id: int):
    # 判断 thread is task or isr?  what is its initial state?
    if is_same_schedule:
        prestate = 'READY' if event_id == 16 else 'SUSPENDED'
        init_state = 'RUNNING'
    elif event_id == 0:
        prestate = 'SUSPENDED'
        init_state = 'READY'
    elif event_id == 16:
        prestate = 'RUNNING'
        init_state = 'WAITING'
    else:
        prestate = 'RUNNING'
        init_state = 'SUSPENDED'
    return prestate, init_state


class DataLinesParser:
    # | event_id | thread | same-schedule-trigger | diff-schedule-trigger |
    # | 0        | task   | activate              | activate              |
    # | 1        | task   | terminate             | activate              |
    # | 2        | isr    | terminate             | start                 |
    # | 16       | thread | preempt               | resume                |

    DIFF_SCHEDULE_TRIGGERS = {0: 'activate', 1: 'terminate', 2: 'terminate', 16: 'preempt'}
    SAME_SCHEDULE_TRIGGERS = {0: 'activate', 1: 'start', 2: 'start', 16: 'resume'}

    STATE_DICT = {'UNKNOWN': -1, 'WAITING': 0, 'READY': 1, 'RUNNING': 2, 'SUSPENDED': 3}
    STATISTIC_KEYS = ("RT", "CET", "IPT")

    def __init__(self, core_idle_no: int):
        self.idle_no = core_idle_no
        # 各线程上次状态变化的时间
        # {thread_id : tick_now}
        self.time_dict = dict()
        # 全局当前时钟
        self.time_now = 0
        # {thread_id: {
        #   run_times: 0,
        #   CET: [], RT: [], IPT: [],
        # }}
        self.statistics_dict = dict()
        self.fsm_dict = dict()
        self.thread_gatt_dict = dict()
        # values
        self.pre_line = None
        self.inited = False

    '''
    private
    '''

    def __update_statistics(self, thread_id, prestate, event_id: int, tick: int):
        duration = tick - self.time_dict[thread_id]
        if prestate != 'SUSPENDED':
            self.statistics_dict[thread_id]["RT"][-1] += duration
        if prestate == 'RUNNING':
            self.statistics_dict[thread_id]["CET"][-1] += duration
        elif prestate == 'READY' and event_id == 1:
            self.statistics_dict[thread_id]["IPT"][-1] += duration
        # 当 thread 结束运行
        if self.fsm_dict[thread_id].state == 'SUSPENDED':
            for _key in self.STATISTIC_KEYS:
                self.statistics_dict[thread_id][_key].append(0)
            self.statistics_dict[thread_id]["run_times"] += 1

    def __update_gatt(self, thread_id, state, end_time: int):
        for _id, fsm in self.fsm_dict.items():
            self.thread_gatt_dict[_id] = self.thread_gatt_dict.get(_id, [])
            # 追加状态 bar
            self.thread_gatt_dict[_id].append([
                state if thread_id == fsm.uuid else fsm.state,
                self.time_now, end_time,
            ])

    '''
    protected
    '''

    def _one_line(self, line):
        _is_same_schedule = line[0] == self.pre_line[0]
        # (CET_current, RT_current, IPT_current)
        _statistics = dict()
        # 当前行的数据信息
        (tick, event_id, thread_id) = (int(x) for x in line)
        # 更新统计信息
        if thread_id not in self.fsm_dict:
            prestate, init_state = calc_init_state(_is_same_schedule, event_id)
            # 初始化状态机，统计信息
            self.fsm_dict[thread_id] = (IsrThreadFSM if event_id == 2 else TaskThreadFSM)(thread_id, init_state)
            self.statistics_dict[thread_id] = {"run_times": 0, "CET": [0], "RT": [0], "IPT": [0]}
        else:
            prestate = self.fsm_dict[thread_id].state
            # 相同 schedule: start/resume
            # 不同 schedule: activate/terminate/preempted
            self.fsm_dict[thread_id].change(
                (self.SAME_SCHEDULE_TRIGGERS if _is_same_schedule else self.DIFF_SCHEDULE_TRIGGERS)[event_id]
            )
            self.__update_statistics(thread_id, prestate, event_id, tick)
        # 更新 gatt 图数据
        self.__update_gatt(thread_id, prestate, tick)
        # 更新时间
        self.time_now = tick
        self.time_dict[thread_id] = tick

    '''
    public
    '''

    def process_line(self, line):
        # 寻找第一次 schedule
        if not self.pre_line or (not self.inited and self.pre_line[0] != line[0]):
            self.pre_line = line
            return None
        self.inited = True
        self._one_line(line)
        self.pre_line = line

    def export_statistics(self, path=None):
        result = dict()
        # 平均值, 最差值
        for thread_id, info in self.statistics_dict.items():
            result[thread_id] = dict()
            for _key in self.STATISTIC_KEYS:
                result[thread_id][f"WC{_key}"] = max(info[_key])
                result[thread_id][f"{_key}_avg"] = sum(info[_key]) / max(1.0, len(info[_key]))
        if path:
            write_json_to(result, path)
        return result

    def reset_gatt(self):
        self.thread_gatt_dict = dict()

    def export_gatt(self, path=None):
        result = dict()
        for thread_id, info in self.thread_gatt_dict.items():
            result[thread_id] = []
            for _status, _start, _end in info:
                if _status == "SUSPENDED" or _end <= _start:
                    continue
                # 同一状态，替换结束时间
                if result[thread_id] and result[thread_id][-1][0] == _status and result[thread_id][-1][-1] == _start:
                    result[thread_id][-1][-1] = _end
                # 不同状态，新增一条记录
                else:
                    result[thread_id].append([_status, _start, _end])
        if path:
            write_json_to(result, path)
        return result


if __name__ == '__main__':
    PATH = r"C:\Users\qwelzqwelz\Desktop\autosar\pythongantt\temp2.txt"
    P = DataLinesParser(core_idle_no=5)

    with open(PATH, "rt", encoding="utf8") as f:
        for line in f.readlines():
            P.process_line([x.strip() for x in line.split("\t") if x.strip()])
    # print(P.export_statistics())
    gatt_data = P.export_gatt()
    write_json_to(gatt_data, r"D:\study\autosar\gliwa-clone-fronted-master\gatt.js")
    for thread_id, bar_list in gatt_data.items():
        print(thread_id, len(bar_list), "\t", bar_list[:5])

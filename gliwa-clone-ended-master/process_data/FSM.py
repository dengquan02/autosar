from transitions import Machine


class TaskThreadFSM:
    WHITE_STATES = ['WAITING', 'READY', 'RUNNING', 'SUSPENDED']
    TRANSITIONS = [
        {'trigger': 'activate', 'source': 'SUSPENDED', 'dest': 'READY'},
        {'trigger': 'start', 'source': 'READY', 'dest': 'RUNNING'},
        {'trigger': 'resume', 'source': 'READY', 'dest': 'RUNNING'},
        {'trigger': 'wait', 'source': 'RUNNING', 'dest': 'WAITING'},
        {'trigger': 'release', 'source': 'WAITING', 'dest': 'READY'},
        {'trigger': 'preempt', 'source': 'RUNNING', 'dest': 'READY'},
        {'trigger': 'terminate', 'source': 'RUNNING', 'dest': 'SUSPENDED'},
    ]

    def __init__(self, uuid, init_state: str):
        assert init_state in self.WHITE_STATES
        self.uuid = uuid
        self._state = init_state

    @property
    def state(self):
        return self._state

    def change(self, operation: str):
        trigger_rule = None
        for _line in self.TRANSITIONS:
            if _line["trigger"] == operation:
                trigger_rule = _line
                break
        assert trigger_rule
        # assert trigger_rule["source"] == self._state
        self._state = trigger_rule["dest"]
        return self._state


class IsrThreadFSM(TaskThreadFSM):
    WHITE_STATES = ['RUNNING', 'READY', 'SUSPENDED']

    TRANSITIONS = [
        {'trigger': 'start', 'source': 'SUSPENDED', 'dest': 'RUNNING'},
        {'trigger': 'terminate', 'source': 'RUNNING', 'dest': 'SUSPENDED'},
        # {'trigger': 'preempt', 'source': 'RUNNING', 'dest': 'READY'},  # 嵌套中断关闭
        # {'trigger': 'resume', 'source': 'READY', 'dest': 'RUNNING'}
    ]

from receive_data import udp_receiver
from process_data.line_data_parser import DataLinesParser
from env import *
from time import time

from typing import List
import subprocess
import os

WORK_DIR = r"D:\study\autosar\process-data"
MAX_DOWNLOAD_SEC = 5 * 1e8


class UdpReceiveProcessManager:
    def __init__(self):
        self.task_label = None
        self.process = None

    def _one_data_file(self, path: str):
        time_range = [None, None]
        result = []
        with open(path, "rt", encoding="utf8") as f:
            for line in f.readlines():
                line = [x.strip() for x in line.split(",") if x.strip()]
                result.append(line)
                _time = int(line[0])
                time_range[0] = _time if time_range[0] is None else min(_time, time_range[0])
                time_range[1] = _time if time_range[1] is None else max(_time, time_range[1])
        return time_range, result

    def _build_gatt_dict(self, lines: List[List[str]]):
        p_dict = {x: DataLinesParser(y) for x, y in CORE_IDLE_DICT.items()}
        for line in lines:
            core_id = THREAD_DICT[int(line[-1])]["core_id"]
            p_dict[core_id].process_line(line)
        result = {x: p.export_gatt() for x, p in p_dict.items()}
        return result

    def start(self):
        if self.process:
            return None
        self.task_label = time()
        command = [
            r"D:\CONDA\envs\autosar\python.exe",
            f"-u {udp_receiver.__file__}",
            f"--task_label {self.task_label}",
        ]
        self.process = subprocess.Popen(
            " ".join(command), shell=True,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, bufsize=-1,
        )

    def stop(self):
        if not self.process:
            return None
        subprocess.call(['taskkill', '/F', '/T', '/PID', str(self.process.pid)])
        self.process = None

    def download(self):
        path_list = []
        for _name in os.listdir(WORK_DIR):
            _path = os.path.join(WORK_DIR, _name)
            if os.path.isfile(_path) and _name.startswith(str(self.task_label)):
                path_list.append((_name, _path))
        # path_list.sort(key=lambda x: x[0], reverse=True)
        path_list.sort(key=lambda x: x[0], reverse=False)
        # 合并多个文件的数据
        line_groups = []
        min_start_sec, max_end_sec = None, None
        for _name, _path in path_list:
            # 读取文件
            [start_sec, end_sec], lines = self._one_data_file(_path)
            line_groups.insert(0, lines)
            # 更新时间上下限
            if max_end_sec is None:
                min_start_sec, max_end_sec = start_sec, end_sec
            min_start_sec = min(min_start_sec, start_sec)
            max_end_sec = max(max_end_sec, end_sec)
            # 判断是否达到数据量要求
            if max_end_sec - min_start_sec >= MAX_DOWNLOAD_SEC:
                break
        # 从后向前截断 (组间逆序，组内顺序)
        result = []
        min_start_sec = max_end_sec
        for group in line_groups:
            for line in group:
                _line_sec = int(line[0])
                if max_end_sec - _line_sec > MAX_DOWNLOAD_SEC:
                    continue
                result.append(line)
                min_start_sec = min(_line_sec, min_start_sec)
        # 与 min_start_sec 对齐
        if not result:
            return dict()
        if min_start_sec > 0:
            for line in result:
                line[0] = str(int(line[0]) - min_start_sec)
        return self._build_gatt_dict(result)

    def clear(self):
        self.stop()
        self.task_label = None

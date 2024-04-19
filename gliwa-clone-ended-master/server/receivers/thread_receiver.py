from receive_data.udp_receiver import UdpReceiver
from process_data.line_data_parser import DataLinesParser
from env import *

from flask_socketio import SocketIO
from typing import List
from time import time


class UdpReceiveThreadManager:
    DATA_DIR = r"C:\Users\qwelzqwelz\Desktop\autosar\thread-data"

    def __init__(self, socketio: SocketIO, min_sec_step: float):
        # params
        self.socketio = socketio
        self.min_sec_step = min_sec_step
        # values
        self.task_label = time()
        self.last_send_time = 0.0
        # services
        self.receiver = None
        self.parser_dict = {x: DataLinesParser(y) for x, y in CORE_IDLE_DICT.items()}

    def _new_receiver(self):
        return UdpReceiver(
            task_label=str(self.task_label), work_dir=self.DATA_DIR,
            thread_dict=THREAD_DICT, idle_dict=CORE_IDLE_DICT, address=DEFAULT_ADDR,
        )

    def _send_gatt_data(self, current_time: float = None):
        result = dict()
        line_count = 0
        for core_id, parser in self.parser_dict.items():
            result[core_id] = parser.export_gatt()
            parser.reset_gatt()
            line_count += sum([len(x) for x in result[core_id].values()])
        # 无数据
        if line_count <= 0:
            return None
        self.last_send_time = current_time or time()
        self.socketio.emit("gatt-data-response", result)

    def _bind_func(self, data_lines: List[List]):
        # 逐行解析
        for line in data_lines:
            core_id = THREAD_DICT[int(line[-1])]["core_id"]
            self.parser_dict[core_id].process_line(line)
        # 距离上次发送的时间过短
        current_time = time()
        if current_time - self.last_send_time < self.min_sec_step:
            return None
        # 发送数据
        self._send_gatt_data()

    def start(self):
        if not self.receiver:
            self.receiver = self._new_receiver()
        self.receiver.start(bind_func=self._bind_func)

    def stop(self):
        if not self.receiver:
            return None
        self.receiver.stop()
        # 最后一次发送剩余数据
        self._send_gatt_data()

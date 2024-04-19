import os.path
import sys

sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from helpers import create_dir_if_not_exists

from typing import List, Callable
from struct import unpack
from time import time
import socket




class UdpReceiver:
    MAX_TRACING_SECONDS = 30
    BUFF_SIZE = 4000

    def __init__(self, task_label: str, thread_dict: dict, idle_dict: dict, address: tuple, work_dir: str):
        self.task_label = task_label
        self.thread_dict = thread_dict
        self.idle_dict = idle_dict
        self.work_dir = create_dir_if_not_exists(work_dir)
        # 全局 values
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # 将socket绑定到指定的IP地址和端口上，以便可以通过该地址和端口接收UDP数据包
        self.socket.bind(address)
        # values
        self._start_time = None
        self._overflow_dict = {x: 0 for x in self.idle_dict}
        self._tick_dict = {x: 0 for x in self.idle_dict}
        self._finished = False

    def _parse_udp_buffer_to_lines(self, data):
        result = []
        for line in data:
            core_id = self.thread_dict[line >> 23]["core_id"]
            # 0x0003ffff对应二进制数为1111 1111 1111 1111，用来获取二进制数的低16位，相当于一个掩码；
            # 0x00040000对应二进制数为1 0000 0000 0000 0000，用来将一个溢出周期加入到实际时间戳中，相当于一个单位；
            # 在这段代码中，用于将一个线程的时间戳与它的溢出周期相加，得到真实的时间戳。
            real_tick = (line & 0x0003ffff) + self._overflow_dict[core_id] * 0x00040000
            if real_tick < self._tick_dict[core_id]:
                self._overflow_dict[core_id] += 1
                real_tick += 0x00040000
            self._tick_dict[core_id] = real_tick
            line = [
                # 时间戳（0-17：18）, event_id（18-22：5）, thread_id（23-31：9）
                real_tick, (line & 0x007c0000) >> 18, line >> 23,
            ]
            line = [str(x) for x in line]
            result.append(line)
        return result

    def _write_buffer(self, data_lines: List[List]):
        data_path = os.path.join(self.work_dir, f"{self.task_label}_{self._start_time}.txt")
        with open(data_path, mode='a') as f:
            for line in data_lines:
                f.write(",".join(line) + "\n")

    '''
    public
    '''

    def start(self, bind_func: Callable = None):
        if self._start_time is not None:
            return None
        self._start_time = time()
        # 持续接收数据
        while not self._finished:
            if time() - self._start_time > self.MAX_TRACING_SECONDS:
                self._start_time = time()
            data, client_addr = self.socket.recvfrom(self.BUFF_SIZE)
            # bytes 转 int 小端模式 解包后的结果是一个整数列表
            data = unpack('<' + 'I' * int(len(data) / 4), data)
            # 解析
            data_lines = self._parse_udp_buffer_to_lines(data)
            # 写数据
            if bind_func:
                bind_func(data_lines)
            self._write_buffer(data_lines)

    def stop(self):
        self.socket.close()
        self._finished = True


if __name__ == '__main__':
    from env import *
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--task_label", type=str, default="test")

    R = UdpReceiver(
        task_label=parser.parse_args().task_label,
        thread_dict=THREAD_DICT, idle_dict=CORE_IDLE_DICT, address=DEFAULT_ADDR,
        work_dir=r"D:\study\autosar\process-data",
    )
    R.start()

import socket
from time import time, sleep

BUFFER_SIZE = 4000
BIT_SEC_RATIO = 5 / 6 / 107249


def keep_sendding(data_path: str, address: tuple):
    client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    with open(data_path, 'rb') as f:
        data = f.read()
    start, end = 0, BUFFER_SIZE
    start_time = time()
    sum_bit_count = 0
    while True:
        if end < len(data):
            client.sendto(data[start:end], address)
        else:
            client.sendto(data[start:] + data[:end % BUFFER_SIZE], address)
        sum_bit_count += BUFFER_SIZE
        print(f"send-data: ({start}, {end})")
        left_time = sum_bit_count * BIT_SEC_RATIO - (time() - start_time)
        if left_time:
            sleep(max(0.0, left_time))
        start = (start + BUFFER_SIZE) % len(data)
        end = start + BUFFER_SIZE


if __name__ == '__main__':
    from env import SAMPLE_UDP_DATA_PATH, DEFAULT_ADDR

    # buffer_size = 4000 且 无间断发送时，5s 可以发送 277/6 s 的数据，共计 1484 次
    # => 5s 实际应发送数据量为: (5/(277/6)) * (1484*4000) = 107249 bit
    # 故限制为，每次发送 buffer_size 大小的数据，应耗时 buffer_size * (5 / 6 / 107249)
    keep_sendding(SAMPLE_UDP_DATA_PATH, DEFAULT_ADDR)

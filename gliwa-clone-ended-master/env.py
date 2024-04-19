SAMPLE_UDP_DATA_PATH = r"D:\study\autosar\pythongantt\tmp.txt"
# SAMPLE_UDP_DATA_PATH = r"C:\Users\qwelzqwelz\Desktop\autosar\gliwa-clone-ended\receive_data\data-01.txt"

DEFAULT_ADDR = ("127.0.0.1", 18217)
# DEFAULT_ADDR = ("192.168.1.8", 18216)

CORE_IDLE_DICT = {
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5
}

THREAD_DICT = {
    12: {
        "thread_name": "OsTask_Rte_100ms_Core0",
        "core_id": 0
    },
    18: {
        "thread_name": "OsTask_Rte_10ms_Core0",
        "core_id": 0
    },
    21: {
        "thread_name": "OsTask_Rte_200ms_Core0",
        "core_id": 0
    },
    23: {
        "thread_name": "OsTask_Rte_20ms_Core0",
        "core_id": 0
    },
    26: {
        "thread_name": "OsTask_Rte_2ms_Core0",
        "core_id": 0
    },
    30: {
        "thread_name": "OsTask_Rte_500ms_Core0",
        "core_id": 0
    },
    32: {
        "thread_name": "OsTask_Rte_50ms_Core0",
        "core_id": 0
    },
    34: {
        "thread_name": "OsTask_Sch_10ms_Core0",
        "core_id": 0
    },
    40: {
        "thread_name": "OsTask_Sch_20ms_Core0",
        "core_id": 0
    },
    41: {
        "thread_name": "OsTask_Sch_5ms_Core0",
        "core_id": 0
    },
    42: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core0",
        "core_id": 0
    },
    48: {
        "thread_name": "Os_TraceId_EthIsr_EthCtrlConfig_TriBoard_EthInterruptServiceRoutine_S2",
        "core_id": 0
    },
    52: {
        "thread_name": "Os_TraceId_EthIsr_EthCtrlConfig_TriBoard_EthInterruptServiceRoutine_S6",
        "core_id": 0
    },
    13: {
        "thread_name": "OsTask_Rte_100ms_Core1",
        "core_id": 1
    },
    24: {
        "thread_name": "OsTask_Rte_20ms_Core1",
        "core_id": 1
    },
    27: {
        "thread_name": "OsTask_Rte_2ms_Core1",
        "core_id": 1
    },
    35: {
        "thread_name": "OsTask_Sch_10ms_Core1",
        "core_id": 1
    },
    43: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core1",
        "core_id": 1
    },
    14: {
        "thread_name": "OsTask_Rte_100ms_Core2",
        "core_id": 2
    },
    25: {
        "thread_name": "OsTask_Rte_20ms_Core2",
        "core_id": 2
    },
    36: {
        "thread_name": "OsTask_Sch_10ms_Core2",
        "core_id": 2
    },
    44: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core2",
        "core_id": 2
    },
    15: {
        "thread_name": "OsTask_Rte_100ms_Core3",
        "core_id": 3
    },
    19: {
        "thread_name": "OsTask_Rte_10ms_Core3",
        "core_id": 3
    },
    22: {
        "thread_name": "OsTask_Rte_200ms_Core3",
        "core_id": 3
    },
    28: {
        "thread_name": "OsTask_Rte_2ms_Core3",
        "core_id": 3
    },
    31: {
        "thread_name": "OsTask_Rte_500ms_Core3",
        "core_id": 3
    },
    33: {
        "thread_name": "OsTask_Rte_50ms_Core3",
        "core_id": 3
    },
    37: {
        "thread_name": "OsTask_Sch_10ms_Core3",
        "core_id": 3
    },
    45: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core3",
        "core_id": 3
    },
    16: {
        "thread_name": "OsTask_Rte_100ms_Core4",
        "core_id": 4
    },
    20: {
        "thread_name": "OsTask_Rte_1ms_Core4",
        "core_id": 4
    },
    38: {
        "thread_name": "OsTask_Sch_10ms_Core4",
        "core_id": 4
    },
    46: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core4",
        "core_id": 4
    },
    17: {
        "thread_name": "OsTask_Rte_100ms_Core5",
        "core_id": 5
    },
    29: {
        "thread_name": "OsTask_Rte_2ms_Core5",
        "core_id": 5
    },
    39: {
        "thread_name": "OsTask_Sch_10ms_Core5",
        "core_id": 5
    },
    47: {
        "thread_name": "Os_TraceId_CounterIsr_OsCounter_Core5",
        "core_id": 5
    },
    0: {
        "thread_name": "IdleTask_OsCore0",
        "core_id": 0
    },
    1: {
        "thread_name": "IdleTask_OsCore1",
        "core_id": 1
    },
    2: {
        "thread_name": "IdleTask_OsCore2",
        "core_id": 2
    },
    3: {
        "thread_name": "IdleTask_OsCore3",
        "core_id": 3
    },
    4: {
        "thread_name": "IdleTask_OsCore4",
        "core_id": 4
    },
    5: {
        "thread_name": "IdleTask_OsCore5",
        "core_id": 5
    }
}

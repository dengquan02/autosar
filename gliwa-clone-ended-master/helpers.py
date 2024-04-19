import json
import os

'''
路径相关
'''


def create_dir_if_not_exists(folder_path: str):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    return folder_path


'''
读写相关
'''


def write_json_to(data, path: str):
    dest_dir = os.path.dirname(path)
    if not os.path.exists(dest_dir):
        os.makedirs(dest_dir)
    with open(path, "wt", encoding="utf8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    return path

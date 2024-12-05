import re
import logging
from pathlib import Path
import sys
import os
sys.path.append(os.path.expanduser('~/.workbench/lib/python3.11/site-packages'))
import psutil

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

# Set up logging
log_file = Path.home() / "Desktop" / "kitty_pass_keys.log"
logging.basicConfig(filename=str(log_file), level=logging.DEBUG, 
                    format='%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')


def is_window_vim(window, vim_id):
    window_pid = window.child.pid

    def check_process_tree(pid):
        try:
            process = psutil.Process(pid)
            if re.search(vim_id, process.name() or ' '.join(process.cmdline()), re.I):
                return True

            for child in process.children(recursive=True):
                if re.search(vim_id, child.name() or ' '.join(child.cmdline()), re.I):
                    return True
            
            return False
        except psutil.NoSuchProcess:
            return False
        except Exception as e:
            return False

    return check_process_tree(window_pid)


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main():
    pass


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    direction = args[1]
    key_mapping = args[2]
    vim_id = args[3] if len(args) > 3 else "n?vim"

    window = boss.window_id_map.get(target_window_id)

    if window is None:
        return
    if is_window_vim(window, vim_id):
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        boss.active_tab.neighboring_window(direction)

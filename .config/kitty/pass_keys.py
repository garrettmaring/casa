import re
import os
import json
import datetime

from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

LOG_FILE = os.path.expanduser("~/Desktop/kitty_pass_keys.log")

def log_to_file(message, data=None):
    """Write log messages to the log file with timestamp"""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")
    with open(LOG_FILE, "a") as f:
        if data:
            try:
                data_str = json.dumps(data, default=str, indent=2)
            except:
                data_str = str(data)
            f.write(f"[{timestamp}] {message}\n{data_str}\n\n")
        else:
            f.write(f"[{timestamp}] {message}\n")

def is_window_vim(window, vim_id):
    fp = window.child.foreground_processes
    log_to_file(f"Checking for vim_id: {vim_id}", {
        "window_id": window.id,
        "window_title": window.title,
        "foreground_processes": fp
    })
    
    # Get all process IDs from foreground processes
    process_ids = [p['pid'] for p in fp if 'pid' in p]
    
    # Import subprocess to run ps commands
    import subprocess
    
    # Function to check if a process or any of its ancestors/descendants is vim
    def check_process_tree(pid, depth=2):
        try:
            # Check process itself
            cmd = f"ps -p {pid} -o command="
            process = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if process.returncode == 0 and re.search(vim_id, process.stdout, re.I):
                log_to_file(f"Found vim in process {pid}: {process.stdout.strip()}")
                return True
                
            if depth <= 0:
                return False
                
            # Check parent process (up the tree)
            cmd = f"ps -p {pid} -o ppid="
            parent = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if parent.returncode == 0 and parent.stdout.strip():
                parent_pid = parent.stdout.strip()
                if parent_pid != "1":  # Don't check init process
                    if check_process_tree(parent_pid, depth-1):
                        return True
            
            # Check child processes (down the tree)
            cmd = f"pgrep -P {pid}"
            children = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if children.returncode == 0 and children.stdout.strip():
                child_pids = children.stdout.strip().split('\n')
                for child_pid in child_pids:
                    if child_pid and check_process_tree(child_pid, depth-1):
                        return True
                        
            return False
        except Exception as e:
            log_to_file(f"Error checking process tree for PID {pid}: {str(e)}")
            return False
    
    # Check each process in the window
    for pid in process_ids:
        log_to_file(f"Checking process tree for PID: {pid}")
        if check_process_tree(pid):
            log_to_file(f"Vim found in process tree of PID {pid}")
            return True
    
    log_to_file("Vim not found in any process trees")
    return False

def encode_key_mapping(window, key_mapping):
    log_to_file(f"Encoding key mapping: {key_mapping}")
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

    encoded = window.encoded_key(event)
    log_to_file(f"Encoded key: {key_mapping} → {encoded.hex()}")
    return encoded

def main():
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    log_to_file("=== pass_keys.py called ===", {
        "args": args,
        "target_window_id": target_window_id
    })
    
    direction = args[1]
    key_mapping = args[2]
    vim_id = args[3] if len(args) > 3 else "n?vim"

    log_to_file(f"Direction: {direction}, Key mapping: {key_mapping}, Vim ID: {vim_id}")
    
    window = boss.window_id_map.get(target_window_id)

    if window is None:
        log_to_file("Window not found!")
        return
        
    if is_window_vim(window, vim_id):
        log_to_file("Vim detected, passing keys to vim")
        for keymap in key_mapping.split(">"):
            log_to_file(f"Processing keymap: {keymap}")
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)
    else:
        log_to_file(f"Vim not detected, switching to neighboring window: {direction}")
        boss.active_tab.neighboring_window(direction)

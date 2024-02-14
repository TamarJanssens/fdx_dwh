from pathlib import Path
import os

def get_root(current_script_path):
    current_script_path = Path(current_script_path).resolve()
    base_dir = current_script_path.parent

    while not (base_dir / 'project_root.txt').exists():
        base_dir = base_dir.parent
        print(base_dir)
    return base_dir

def ensure_path_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)

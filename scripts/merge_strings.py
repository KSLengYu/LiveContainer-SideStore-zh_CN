# -*- coding: utf-8 -*-
"""Merge SideStore Simplified Chinese translations into a target .strings binary plist."""
import os
import plistlib
import sys


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: merge_strings.py <target_strings_path> [sidestore_scripts_dir]")
        sys.exit(1)

    target_file = sys.argv[1]
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    candidates = []
    if len(sys.argv) > 2:
        candidates.append(sys.argv[2])
    if os.environ.get("SIDESTORE_SCRIPTS_DIR"):
        candidates.append(os.environ["SIDESTORE_SCRIPTS_DIR"])
    candidates.extend([
        os.path.join(repo_root, "SideStore-src", "scripts"),
        os.path.join(os.path.dirname(repo_root), "SideStore", "scripts"),
    ])

    scripts_dir = next((p for p in candidates if os.path.isfile(os.path.join(p, "generate_full_strings.py"))), None)
    if not scripts_dir:
        raise FileNotFoundError(f"Could not find generate_full_strings.py in: {candidates}")

    sys.path.insert(0, scripts_dir)
    from generate_full_strings import translations as zh_map

    if os.path.exists(target_file):
        try:
            with open(target_file, "rb") as f:
                data = plistlib.load(f)
        except Exception as exc:
            print(f"Warning: could not parse existing {target_file}: {exc}")
            data = {}
    else:
        data = {}

    initial_len = len(data)
    for key, value in zh_map.items():
        data[key] = value

    os.makedirs(os.path.dirname(os.path.abspath(target_file)), exist_ok=True)
    with open(target_file, "wb") as f:
        plistlib.dump(data, f, fmt=plistlib.FMT_BINARY)

    print(f"Merged SideStore strings into {target_file}: {initial_len} -> {len(data)} strings")


if __name__ == "__main__":
    main()

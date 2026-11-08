#!/usr/bin/env bash
set -euo pipefail

git config --local user.email "asrofilnadibs28@gmail.com"
git config --local user.name "asrofilnadib"

mkdir -p .auto-commit

python3 <<'PY'
import json
import random
import subprocess
import time
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

POOL = [
    "🐓", "😹", "😜", "😭", "🐢", "👅", "💪",
    "🪽", "🦋", "🙏", "🙈", "🐐", "🐈‍⬛", "👻", 
    "💣", "💬", "🤣", "🏋️‍♂️", "🙊", "🙉", "💩", 
    "👋",
]

COMMITS_MIN = 10
COMMITS_MAX = 22
STATE_PATH = Path(".auto-commit/daily-emojis.json")
today = datetime.now(ZoneInfo("Asia/Jakarta")).date().isoformat()

state = {"date": today, "used": []}
commits_target = None
if STATE_PATH.exists():
    try:
        loaded = json.loads(STATE_PATH.read_text(encoding="utf-8"))
        if loaded.get("date") == today and isinstance(loaded.get("used"), list):
            state = loaded
            ct = loaded.get("commits_target")
            if isinstance(ct, int) and COMMITS_MIN <= ct <= COMMITS_MAX:
                commits_target = ct
    except json.JSONDecodeError:
        pass

if commits_target is None:
    commits_target = random.randint(COMMITS_MIN, COMMITS_MAX)

state["commits_target"] = commits_target
used = set(state["used"])
remaining = max(0, commits_target - len(used))
print(f"Target commit hari ini: {commits_target} (sisa: {remaining})")

if remaining == 0:
    STATE_PATH.write_text(
        json.dumps(state, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    raise SystemExit(0)

COMMITS_PER_RUN = remaining
available = [e for e in POOL if e not in used]

if len(available) < COMMITS_PER_RUN:
    used = set()
    available = POOL[:]

chosen = random.sample(available, COMMITS_PER_RUN)
state["used"] = list(used | set(chosen))
state["date"] = today
STATE_PATH.write_text(json.dumps(state, ensure_ascii=False, indent=2), encoding="utf-8")

for emoji in chosen:
    ts = datetime.now(ZoneInfo("UTC")).strftime("%Y-%m-%dT%H:%M:%SZ")
    Path("LAST_UPDATED").write_text(ts + "\n", encoding="utf-8")
    subprocess.run(["git", "add", "LAST_UPDATED", str(STATE_PATH)], check=True)
    msg = f"chore(bot): {emoji} auto commit"
    diff = subprocess.run(["git", "diff", "--staged", "--quiet"])
    if diff.returncode != 0:
        subprocess.run(["git", "commit", "-m", msg], check=True)
    time.sleep(1)
PY

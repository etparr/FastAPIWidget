# Langflow "Embed In Site"

---

## Table of Contents
1. [Quick Start (Non-Technical)](#quick-start)
2. [Developer Setup (Technical)](#developer-setup)
3. [Configuration](#configuration)
4. [Project Structure](#project-structure)



## 3 • Quick Start (Non-Technical)

1. **Install Git** (only if you don’t already have it) → <https://git-scm.com/downloads>
2. **Download the project**
   ```bash
   git clone https://github.com/etparr/FastAPIWidget.git
   cd FastAPIWidget
   ```
3. **Run the installer**  
   > Windows users: run in *Git Bash* or *WSL*
   > Mac Users: run in terminal
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. When the script finishes it will automatically start the server at <http://localhost:8000>. 

**Next time** you want to use the app, just run:
```bash
source .venv/bin/activate && uvicorn main:app --reload
```

---
<a name="developer-setup"></a>

## 4 • Developer Setup (Technical)
```bash
# 1. Clone && enter project
git clone https://github.com/etparr/FastAPIWidget.git
cd FastAPIWidget

# 2. Install Depdendencies
pip install -r requirement.txt

# 2. Export the appropriate configuration variables (listed below under configuration)
export variable="value"

# 3. Activate Env and Start:
source .venv/bin/activate
uvicorn main:app --reload  # hot-reloads on code changes
```

---
<a name="configuration"></a>

## 6 • Configuration
| Variable | Where Set | Description |
|----------|-----------|-------------|
| `PROJECT_ID` | `.env`  | Your Langflow project GUID |
| `FLOW_ID`    | `.env`| The specific flow you want to run |
| `WINDOW_TITLE` | `.env` | Title shown in the chat header |
| `ASTRA_API_TOKEN` | `.env` | Token for authenticated requests |

Update them manually **or** rerun `./setup.sh` anytime.


---
<a name="project-structure"></a>

## 8 • Project Structure
```text
FastAPIWidget/
├── main.py                # FastAPI entry-point
├── static/
│   └── index.html         # Embeds Langflow chat
├── setup.sh               # Installer
├── requirements.txt       # Exact pinned deps
├── .venv/                 # Auto-created virtual env
└── README.md              # You are here
```

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
   git clone https://github.com/your-org/langflow-demo.git
   cd langflow-demo
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
git clone https://github.com/your-org/langflow-demo.git
cd langflow-demo

# 2. Export the appropriate configuration variables (listed below)

# 3. Hack away!  Typical dev loop:
source .venv/bin/activate
uvicorn main:app --reload  # hot-reloads on code changes
```

---
<a name="configuration"></a>

## 6 • Configuration
| Variable | Where Set | Description |
|----------|-----------|-------------|
| `PROJECT_ID` | `main.py`  | Your Langflow project GUID |
| `FLOW_ID`    | `static/index.html`| The specific flow you want to run |
| `WINDOW_TITLE` | `static/index.html` | Title shown in the chat header |
| `ASTRA_API_TOKEN` | `.env` | Token for authenticated requests |

Update them manually **or** rerun `./setup.sh` anytime.


---
<a name="project-structure"></a>

## 8 • Project Structure
```text
langflow-demo/
├── main.py                # FastAPI entry-point
├── static/
│   └── index.html         # Embeds Langflow chat
├── setup.sh               # Installer
├── requirements.txt       # Exact pinned deps
├── .venv/                 # Auto-created virtual env
└── README.md              # You are here
```
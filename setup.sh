#!/usr/bin/env bash
# setup.sh — one-step setup for non-technical users
# Fully automated: installs Python 3.13, creates a virtual environment,
# installs dependencies, injects project settings, and starts the server.

set -e

echo "\n=== Langflow Embed in Site Automated Setup ===\n"

# 1) Ensure Python 3.13 is installed
if ! command -v python3.13 >/dev/null; then
  echo "Python 3.13 not found. Attempting to install..."
  if command -v apt-get >/dev/null; then
    sudo apt-get update && sudo apt-get install -y python3.13 python3.13-venv python3.13-distutils
  elif command -v brew >/dev/null; then
    brew install python@3.13
  else
    echo "Could not auto-install Python 3.13. Please download and install it from https://www.python.org/downloads/"
    exit 1
  fi
fi
PYTHON=python3.13

echo "Using $PYTHON\n"

# 2) Create and activate virtual environment
if [ ! -d .venv ]; then
  echo "Creating Python virtual environment..."
  $PYTHON -m venv .venv
fi
# shellcheck disable=SC1091
source .venv/bin/activate

echo "Virtual environment activated.\n"

# 3) Ensure envsubst (gettext) is installed
if ! command -v envsubst >/dev/null; then
  echo "'envsubst' not found. Installing..."
  if command -v apt-get >/dev/null; then
    sudo apt-get install -y gettext-base
  elif command -v brew >/dev/null; then
    brew install gettext && brew link --force gettext
  else
    echo "Please install 'gettext' manually to provide 'envsubst'."
    exit 1
  fi
fi

echo "envsubst is available.\n"

# 4) Install or update Python dependencies
if [ -f requirements.txt ]; then
  echo "Installing Python dependencies..."
  pip install --upgrade pip
  pip install -r requirements.txt
  echo "Pinning exact versions to requirements.txt..."
  pip freeze > requirements.txt
else
  echo "requirements.txt not found; skipping dependency install."
fi

echo
# 5) Prompt for run URL or IDs
read -p "Paste full run URL (or leave blank to enter IDs manually): " FULL_URL
if [[ -n "$FULL_URL" ]]; then
  PROJECT_ID=$(echo "$FULL_URL" | sed -n 's#.*/lf/\([^/]*\)/api.*#\1#p')
  FLOW_ID=$(echo "$FULL_URL" | sed -n 's#.*/run/\([^/]*\).*#\1#p')
  echo "Extracted Project ID: $PROJECT_ID"
  echo "Extracted Flow ID:    $FLOW_ID"
else
  read -p "Enter Project ID: " PROJECT_ID
  read -p "Enter Flow ID:    " FLOW_ID
fi

echo
# 6) Prompt for window title and API token
read -p "Enter Window Title (e.g. 'Basic Prompting'): " WINDOW_TITLE
read -p "Enter ASTRA API Token: " ASTRA_API_TOKEN

echo "\nInjecting settings..."

# 7) Inject into code
sed -i.bak -E "s#^PROJECT_ID = .*#PROJECT_ID = \"$PROJECT_ID\"#" main.py
sed -i.bak -E "s#window_title=\"[^\"]*\"#window_title=\"$WINDOW_TITLE\"#" static/index.html
sed -i.bak -E "s#flow_id=\"[^\"]*\"#flow_id=\"$FLOW_ID\"#"    static/index.html

echo "Writing .env with ASTRA_API_TOKEN..."
echo "ASTRA_API_TOKEN=$ASTRA_API_TOKEN" > .env

# 8) Launch server
echo "\nStarting FastAPIWidget server..."
uvicorn main:app --reload &

# 9) Completion message
echo "\nSetup complete!"
echo "In future, start server by activating venv and running:"
echo "  source .venv/bin/activate && uvicorn main:app --reload"
echo "Visit http://localhost:8000 in your browser.\n"

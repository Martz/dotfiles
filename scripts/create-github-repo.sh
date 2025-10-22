#!/usr/bin/env bash

# Script to create a new directory, initialize git, and create a GitHub repository
# Usage: create-github-repo.sh <repo-name> [description]

set -e  # Exit on error

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if repo name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <repo-name> [description]"
    echo "Example: $0 my-new-project 'A cool new project'"
    exit 1
fi

REPO_NAME="$1"
REPO_DESC="${2:-}"

# Check if directory already exists
if [ -d "$REPO_NAME" ]; then
    echo "Error: Directory '$REPO_NAME' already exists"
    exit 1
fi

echo "Creating new repository: $REPO_NAME"

# Create directory and cd into it
mkdir "$REPO_NAME"
cd "$REPO_NAME"

# Initialize git repository
git init -b main
echo "# $REPO_NAME" > README.md

# Create initial commit
git add README.md
git commit -m "Initial commit"

# Create GitHub repository (public)
echo "Creating public GitHub repository..."
if [ -n "$REPO_DESC" ]; then
    gh repo create "$REPO_NAME" --public --source=. --remote=origin --description "$REPO_DESC"
else
    gh repo create "$REPO_NAME" --public --source=. --remote=origin
fi

# Set up main branch tracking
git branch --set-upstream-to=origin/main main

# Push to GitHub
git push -u origin main

echo ""
echo "✓ Repository created successfully!"
echo "  Local path: $(pwd)"
echo "  Remote URL: $(git remote get-url origin)"
echo ""

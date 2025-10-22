#!/usr/bin/env bash

# Shell function to create a new directory, initialize git, and create a GitHub repository
# This function keeps you in the newly created directory after completion
#
# To use this function, add to your .zshrc or .bashrc:
#   source ~/dotfiles/scripts/create-github-repo-function.sh
#
# Usage: create-github-repo <repo-name> [description]

create-github-repo() {
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "Error: GitHub CLI (gh) is not installed"
        echo "Install it from: https://cli.github.com/"
        return 1
    fi

    # Check if repo name is provided
    if [ -z "$1" ]; then
        echo "Usage: create-github-repo <repo-name> [description]"
        echo "Example: create-github-repo my-new-project 'A cool new project'"
        return 1
    fi

    local REPO_NAME="$1"
    local REPO_DESC="${2:-}"

    # Check if directory already exists
    if [ -d "$REPO_NAME" ]; then
        echo "Error: Directory '$REPO_NAME' already exists"
        return 1
    fi

    echo "Creating new repository: $REPO_NAME"

    # Create directory and cd into it
    mkdir "$REPO_NAME" || return 1
    cd "$REPO_NAME" || return 1

    # Initialize git repository
    git init -b main || { cd ..; rm -rf "$REPO_NAME"; return 1; }
    echo "# $REPO_NAME" > README.md

    # Create initial commit
    git add README.md
    git commit -m "Initial commit" || { cd ..; rm -rf "$REPO_NAME"; return 1; }

    # Create GitHub repository (public)
    echo "Creating public GitHub repository..."
    if [ -n "$REPO_DESC" ]; then
        gh repo create "$REPO_NAME" --public --source=. --remote=origin --description "$REPO_DESC" || { cd ..; rm -rf "$REPO_NAME"; return 1; }
    else
        gh repo create "$REPO_NAME" --public --source=. --remote=origin || { cd ..; rm -rf "$REPO_NAME"; return 1; }
    fi

    # Push to GitHub (this also sets up tracking)
    git push -u origin main || { cd ..; rm -rf "$REPO_NAME"; return 1; }

    echo ""
    echo "✓ Repository created successfully!"
    echo "  Local path: $(pwd)"
    echo "  Remote URL: $(git remote get-url origin)"
    echo ""
}

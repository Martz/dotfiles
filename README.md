# dotfiles

Personal configuration files for a clean development environment.

## Contents

- **git** - Git configuration and aliases
- **zsh** - Zsh shell configuration
- **vim** - Vim editor settings
- **tmux** - Terminal multiplexer configuration  
- **p10k** - Powerlevel10k prompt theme

## Setup

Clone and install using GNU Stow:

```bash
git clone https://github.com/Martz/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Install configurations using `stow`:

```bash
stow git
stow zsh
stow vim
stow tmux
stow p10k
```

To remove a configuration:

```bash
stow -D <package>
```
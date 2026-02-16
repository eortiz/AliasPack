# aliaspak

A modular Bash aliases and utility functions package for developers and sysadmins. 170+ aliases and 54+ functions organized by domain (Docker, Git, Linux, macOS). Pure Bash - no build system, no dependencies.

## Installation

```bash
# Clone to ~/aliaspak/
git clone https://github.com/eortiz/AliasPack.git ~/aliaspak

# Install
chmod +x ~/aliaspak/install.sh
~/aliaspak/install.sh
```

The install script auto-detects your shell and adds a single source line to the best config file:

| Shell | Target file | Why |
|-------|-------------|-----|
| Zsh + oh-my-zsh | `$ZSH_CUSTOM/aliaspak.zsh` | Auto-sourced by oh-my-zsh, no `.zshrc` editing needed |
| Zsh | `~/.zshrc` | Standard interactive zsh config |
| Bash | `~/.bash_aliases` (if exists) | Purpose-built for aliases, sourced by `.bashrc` |
| Bash (fallback) | `~/.bashrc` | Universal interactive bash config |

Re-running the installer is safe - it won't duplicate the source line.

## How It Works

### Sourcing Chain

```
~/.zshrc (or .bashrc, etc.)
  └── source ~/aliaspak/alias_pack       ← bootstrap
        ├── alias_general                 ← cross-platform (always loaded)
        ├── alias_mac / alias_linux       ← OS-specific (auto-detected)
        ├── alias_docker                  ← Docker/Compose (macOS only)
        └── alias_git                     ← Git (always loaded)
```

`alias_pack` detects the OS via `uname -s` and conditionally sources the right modules:

- **macOS (Darwin):** `alias_general` → `alias_mac` → `alias_docker` → `alias_git`
- **Linux:** `alias_general` → `alias_linux` → `alias_git`

### Help System

Run `hlp` to display all available aliases and functions:

```bash
hlp            # show everything
hlp docker     # Docker aliases and functions only
hlp git        # Git aliases only
hlp mac        # macOS-specific
hlp linux      # Linux-specific
```

The help system is self-documenting - it parses `#-` comments and `alias` lines from the source files.

## Environment Variables & Custom Aliases

AliasPak supports a `.env` file for loading environment variables and custom alias overrides.

### Setup

1. **Create your `.env` file:**
   ```bash
   cp ~/aliaspak/.env.example ~/aliaspak/.env
   ```

2. **Add environment variables:**
   ```bash
   # Example .env content
   export OPENAI_API_KEY="sk-your-api-key-here"
   export GITHUB_TOKEN="ghp_your-token-here"
   export EDITOR="vim"
   ```

3. **Override aliases with custom files:**
   ```bash
   # In your .env file, specify additional alias files to load
   ADDITIONAL_ALIASES="alias_custom alias_work"
   ```

### Custom Alias Files

Additional alias files are sourced **after** the default modules, allowing you to:
- Override any default alias with your own implementation
- Add organization-specific or personal aliases
- Keep custom configurations separate from the base installation

**Example workflow:**

```bash
# Create a custom alias file
cat > ~/aliaspak/alias_custom <<'EOF'
# Override default 'll' alias with your preferred format
alias ll='ls -alFh --color=auto'

# Add custom aliases
alias myserver='ssh user@example.com'
alias deploy='./scripts/deploy.sh'
EOF

# Enable in .env
echo 'ADDITIONAL_ALIASES="alias_custom"' >> ~/aliaspak/.env

# Reload shell
source ~/.bashrc  # or ~/.zshrc
```

### Sourcing Order (with .env)

```
~/.zshrc (or .bashrc)
  └── source ~/aliaspak/alias_pack       ← bootstrap
        ├── alias_general                 ← cross-platform
        ├── alias_mac / alias_linux       ← OS-specific
        ├── alias_docker                  ← Docker/Compose
        ├── alias_git                     ← Git
        └── .env (if exists)              ← environment variables + custom overrides
              └── ADDITIONAL_ALIASES      ← your custom alias files (override mode)
```

**Note:** The `.env` file is gitignored to protect sensitive data like API keys.

## Modules

### alias_general - Cross-Platform (16 aliases, 6 functions)

Navigation, listing, and common utilities.

| Command | Description |
|---------|-------------|
| `l` / `ll` | List files (detailed, paged) |
| `..` / `...` / `....` | Navigate up directories |
| `mkcd` | Create directory and cd into it |
| `c` | Clear screen |
| `myip` | Show external IP address |
| `hg` | Search command history |
| `fixssh` | Remove stale SSH host key and reconnect |
| `act` | Activate Python virtual environment |
| `scopy` | SCP usage reference |
| `trunc` | Truncate file to zero bytes |

### alias_git - Git Workflow (97 aliases, 2 functions)

Comprehensive Git shortcuts covering the full workflow.

**Status & Staging:**

| Command | Description |
|---------|-------------|
| `gs` / `gst` | Git status |
| `ga` / `gall` | Add files / stage all |
| `gus` | Unstage files |
| `grs` | Restore file |

**Commits:**

| Command | Description |
|---------|-------------|
| `gc` / `gcm` | Commit / commit with message |
| `gcam` | Add all and commit with message |
| `gcaa` / `gcae` | Amend last commit |

**Branches:**

| Command | Description |
|---------|-------------|
| `gb` / `gba` | List branches (local / all) |
| `gcb` | Create and switch to new branch |
| `gbdel` | Delete branch |
| `gsw` | Switch branch |
| `gcom` | Checkout main |

**Fetch, Pull & Push:**

| Command | Description |
|---------|-------------|
| `gf` / `gfo` | Fetch / fetch origin |
| `gpl` / `gup` | Pull / pull with rebase |
| `gp` / `gpo` | Push / push origin |
| `gpf` | Force push (safe, `--force-with-lease`) |
| `gpp` | Pull then push |

**Diff & Log:**

| Command | Description |
|---------|-------------|
| `gd` / `gdc` | Diff / diff cached |
| `glog` / `gll` | Commit graph visualization |
| `gsh` / `gbl` | Show commit / blame |

**Stash & Tags:**

| Command | Description |
|---------|-------------|
| `gsta` / `gstap` | Stash / stash with patch |
| `gt` / `gta` | List tags / create annotated tag |
| `gtam` | Create annotated tag with message |

**Advanced Workflows:**

| Command | Description |
|---------|-------------|
| `gsav` / `gitsave()` | Save work-in-progress: creates a new branch and commits all changes |
| `grel` / `gitrelease()` | Reset main to a released tag, perfectly clean |

### alias_docker - Docker & Compose (16 aliases, 25 functions)

Full Docker and Docker Compose lifecycle management.

**Compose:**

| Command | Description |
|---------|-------------|
| `dup` / `dupb` / `dupd` | Compose up / with build / detached |
| `ddn` / `ddnv` | Compose down / with volumes |
| `drec` | Recreate containers (force) |
| `dcps` / `dcl` | Compose ps / follow logs |
| `dcex` | Exec into running service |

**Containers:**

| Command | Description |
|---------|-------------|
| `dps` / `dpsa` | List running / all containers |
| `dlog` | Follow container logs |
| `dex` / `dexsh` | Exec bash / sh into container |
| `dsto` | Stop all running containers |
| `dins` / `dtop` | Inspect / top for container |
| `dstat` | Container resource stats |

**Images, Networks & Volumes:**

| Command | Description |
|---------|-------------|
| `dils` | List images (with optional filter) |
| `dnet` / `dv` | Network / volume list or inspect |
| `dprune` / `dprunea` | System prune (unused resources) |
| `ddf` | Docker disk usage |

### alias_mac - macOS Specific (15 aliases, 2 functions)

| Command | Description |
|---------|-------------|
| `copy` / `paste` | Clipboard (pbcopy / pbpaste) |
| `flushdns` | Flush DNS cache |
| `nosleep` | Prevent sleep (caffeinate) |
| `showfiles` / `hidefiles` | Toggle hidden files in Finder |
| `netstatp` | Show listening ports |
| `mip` | Machine network info (hostname, IP, MAC, gateway) |
| `flr` / `flb` / `flt` | Flutter run / build / test |

### alias_linux - Linux Specific (26 aliases, 19 functions)

| Command | Description |
|---------|-------------|
| `start` / `stop` / `enable` / `reload` | systemctl shortcuts |
| `journal` | Follow service journal |
| `usage` | Memory, disk, CPU summary |
| `extract` | Multi-format decompression (tar, zip, rar, 7z, xz, zst, etc.) |
| `netstatp` | Show listening ports (ss) |
| `mip` | Machine network info |
| `sdel` / `sddel` | Secure delete file / directory |
| `update` | Update, upgrade, autoremove packages |
| `lx` | List files with octal permissions |

## Conventions

- All aliases echo the command before executing for transparency
- Functions backing aliases use the `-fn` suffix (e.g., `dnames-fn` aliased to `dnames`)
- Help comments use `#-` prefix (parsed by `hlp()`)
- Docker Compose commands use v2 syntax (`docker compose`, not `docker-compose`)

## Summary

| Module | Aliases | Functions | Total |
|--------|---------|-----------|-------|
| alias_general | 16 | 6 | 22 |
| alias_docker | 16 | 25 | 41 |
| alias_git | 97 | 2 | 99 |
| alias_mac | 15 | 2 | 17 |
| alias_linux | 26 | 19 | 45 |
| **Total** | **170** | **54** | **224** |

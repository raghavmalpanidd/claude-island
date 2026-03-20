<div align="center">
  <img src="ClaudeIsland/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" alt="Logo" width="100" height="100">
  <h3 align="center">Claude Island</h3>
  <p align="center">
    A macOS menu bar app that brings Dynamic Island-style notifications to Claude Code CLI sessions.
    <br />
    <br />
    <a href="https://github.com/farouqaldori/claude-island/releases/latest" target="_blank" rel="noopener noreferrer">
      <img src="https://img.shields.io/github/v/release/farouqaldori/claude-island?style=rounded&color=white&labelColor=000000&label=release" alt="Release Version" />
    </a>
    <a href="#" target="_blank" rel="noopener noreferrer">
      <img alt="GitHub Downloads" src="https://img.shields.io/github/downloads/farouqaldori/claude-island/total?style=rounded&color=white&labelColor=000000">
    </a>
  </p>
</div>

## Features

- **Notch UI** — Animated overlay that expands from the MacBook notch
- **Live Session Monitoring** — Track multiple Claude Code sessions in real-time
- **Permission Approvals** — Approve or deny tool executions directly from the notch, with an eye button to preview the session before deciding
- **Window Focus** — Click a session to focus its terminal window. Supports iTerm2, Terminal.app, and IntelliJ IDEA via tmux + yabai
- **Multi-Monitor** — Configure which screen displays the notch overlay
- **Chat History** — View full conversation history with markdown rendering
- **Auto-Setup** — Hooks install automatically on first launch

## Requirements

- macOS 15.6+
- Claude Code CLI

### Optional (for window focus)

- [yabai](https://github.com/koekeishiya/yabai) — window querying and focusing
- [tmux](https://github.com/tmux/tmux) — terminal multiplexer for stable pane identity

## Install

Download the latest release or build from source:

```bash
xcodebuild -scheme ClaudeIsland -configuration Release build
```

## How It Works

Claude Island installs hooks into `~/.claude/hooks/` that communicate session state via a Unix socket. The app listens for events and displays them in the notch overlay.

When Claude needs permission to run a tool, the notch expands with approve/deny buttons—no need to switch to the terminal.

### IntelliJ Window Focus

All IntelliJ windows share a single PID, so Claude Island matches windows by project name. Add this to your `~/.zshrc` to wrap `claude` in a tmux session when running inside IntelliJ:

```bash
claude() {
    if [ -z "$TMUX" ] && [ "$TERMINAL_EMULATOR" = "JetBrains-JediTerm" ]; then
        local project=$(yabai -m query --windows --window | python3 -c "
import json,sys
title = json.load(sys.stdin)['title']
print(title.split(' – ')[0].strip())
")
        tmux new-session -s "${project}_$$" "claude $*"
    else
        command claude "$@"
    fi
}
```

Normal IntelliJ terminals stay unchanged — tmux only starts when you run `claude`. The function queries yabai for the focused IntelliJ window title to get the project name (so it works even if you've cd'd elsewhere). When Claude exits, the tmux session closes automatically. Claude Island extracts the project name from the tmux session (e.g. `claude-island_87883` → `claude-island`) and focuses the matching IntelliJ window.

## Analytics

Claude Island uses Mixpanel to collect anonymous usage data:

- **App Launched** — App version, build number, macOS version
- **Session Started** — When a new Claude Code session is detected

No personal data or conversation content is collected.

## License

Apache 2.0

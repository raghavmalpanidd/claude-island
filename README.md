<div align="center">
  <img src="ClaudeIsland/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" alt="Logo" width="100" height="100">
  <h3 align="center">Claude Island (IntelliJ Fork)</h3>
  <p align="center">
    A fork of <a href="https://github.com/farouqaldori/claude-island">Claude Island</a> with IntelliJ IDEA integration.
    <br />
    Dynamic Island-style notifications for Claude Code + one-click focus to your IntelliJ project window.
  </p>
</div>

## What's different in this fork

- **IntelliJ Window Focus** — Eye button on each session opens the matching IntelliJ project window via the JetBrains CLI (`idea <path>`). No Yabai or tmux required.
- **Project-prefixed titles** — Session titles show `projectName — description` for quick identification across multiple sessions.
- Falls back to the original Yabai/tmux window focus for terminal users.

## Features (from upstream)

- **Notch UI** — Animated overlay that expands from the MacBook notch
- **Live Session Monitoring** — Track multiple Claude Code sessions in real-time
- **Permission Approvals** — Approve or deny tool executions directly from the notch
- **Chat History** — View full conversation history with markdown rendering
- **Auto-Setup** — Hooks install automatically on first launch

## Requirements

- macOS 15.6+
- Claude Code CLI
- IntelliJ IDEA (CE or Ultimate) for the IDE focus feature

## Install

Build from source:

```bash
xcodebuild -scheme ClaudeIsland -configuration Release build \
  CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
```

The built app will be at `~/Library/Developer/Xcode/DerivedData/ClaudeIsland-*/Build/Products/Release/Claude Island.app`. Copy it to `/Applications/`.

## How It Works

Claude Island installs hooks into `~/.claude/hooks/` that communicate session state via a Unix socket. The app listens for events and displays them in the notch overlay.

When Claude needs permission to run a tool, the notch expands with approve/deny buttons—no need to switch to the terminal.

The IntelliJ integration detects the `idea` CLI at startup (checks `/usr/local/bin/idea` and the bundled binary in the app). When you click the eye button on a session, it runs `idea <session-cwd>` which activates the matching IntelliJ project window.

## Analytics

Claude Island uses Mixpanel to collect anonymous usage data:

- **App Launched** — App version, build number, macOS version
- **Session Started** — When a new Claude Code session is detected

No personal data or conversation content is collected.

## License

Apache 2.0

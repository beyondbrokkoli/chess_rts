## Quick Reference Commands

Whether you are on Linux (`./launch.sh`) or Windows (`launch.bat`), the syntax is identical.

| Command | Syntax | Description |
| --- | --- | --- |
| **Host** | `host [size]` | Creates a new graphical host node. (Default size: 8) |
| **Client** | `client <lobby_id> [size]` | Joins an existing lobby as a graphical client. |
| **Attach** | `attach <bot_count> <lobby_id> [size]` | Injects headless chaos bots into an active lobby. |
| **Lab** | `lab` | Boots a full 8-player local test (4 graphical, 4 headless). |
| **Swarm** | `swarm [gui_count] [bot_count]` | Custom local cluster testing. |
| **Clean** | `clean` | Force-kills all running engine processes and frees sockets. |

---

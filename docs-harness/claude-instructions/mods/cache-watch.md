# cache-watch

A band above the prompt for the main thread's prompt cache: active or expired, the time
left (TTL 5m or 1h, read from the API usage), the cached tokens, and the estimated cost of
the next request while warm (`keep`) and after expiry (`if expired`). Five minutes before
expiry it shows a toast and a native notification, so the User can send a request to keep
the cache warm. `/cache-watch` shows or hides the band.

- Plugin: `cache-watch@claude-mods`, user scope.
- Source: private GitHub repository `lxbachit03/claude-mods`, folder `cache-watch/`.
- Costs are client-side estimates from first-party API list prices of 2026-11; the band
  labels them so. A subscription plan does not bill these figures.

Every step below needs the User's yes for this mod in this session (see
[README.md](README.md)).

## Install

1. The repository is private: the machine needs a git credential for github.com that
   can read it (an SSH key, or `gh auth login` then `gh auth setup-git`). Check with
   `git ls-remote https://github.com/lxbachit03/claude-mods.git`; "Repository not
   found" means no access. Then stop and tell the User; the User signs in, never you.
2. `claude plugin marketplace add lxbachit03/claude-mods` (skip when
   `claude plugin marketplace list` already shows `claude-mods`).
3. `claude plugin install cache-watch@claude-mods --scope user`.
4. Done when `claude plugin list` shows `cache-watch@claude-mods` enabled. The mod loads
   in sessions started after the install; tell the User to open a new session to see the
   band after the first request.

## Update

`claude plugin marketplace update claude-mods`, then
`claude plugin update cache-watch@claude-mods`. A new version reaches a machine only
after its `version` in `cache-watch/.claude-plugin/plugin.json` was raised and pushed.

## Remove

`claude plugin uninstall cache-watch@claude-mods`. Remove the marketplace with
`claude plugin marketplace remove claude-mods` only when the User asks, since other mods
may come from it.

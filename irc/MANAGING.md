# Managing soju

## What it is / how it works

soju is an **IRC bouncer**: a long-running process on the always-on box that stays
connected to Libera 24/7 as your nick, so you never miss `#lilbee` traffic. Your weechat
connects to *soju* (not Libera directly); soju relays both ways and replays backlog.

**It is NOT dockerized.** It's a native package running under **systemd** (`soju.service`).
Only the website (https-portal + tracker) runs in Docker.

Layout on the box:

```
process : systemd unit  soju.service        (/usr/lib/systemd/system/soju.service)
binary  : /usr/bin/soju  (+ sojuctl, sojudb)
config  : /etc/soju/config
state   : /var/lib/soju/main.db             (sqlite: users, networks, channels)
          /var/lib/soju/logs/               (message history / backlog)
listens : ircs:// on :6697  (your clients connect here, over TLS)
```

Data model:  **user** (login to soju) → **networks** (e.g. `libera`) → **channels**.

**Access:** SSH in as your own user, not root. Set `LILBEE_HOST=user@host` in a private
(un-versioned) file and `ssh "$LILBEE_HOST"`. That user has scoped passwordless sudo for
`systemctl` and `sojuctl` only, and is in the `adm`/`systemd-journal` groups (read `journalctl`)
and the `limnoria` group (read the bot's logs). So: prefix `systemctl restart` / `sojuctl` with
**`sudo`**; plain `systemctl status`, `journalctl`, and log tails need no sudo.

## Three ways to manage it

### 1. systemd — the service itself
```sh
systemctl status soju          # running? since when?
systemctl restart soju         # restart the bouncer
systemctl stop soju            # take it offline
journalctl -u soju -f          # live service logs (connections, errors)
```

### 2. sojuctl — admin CLI on the box (talks to soju's admin socket)
```sh
# accounts
sojuctl user status                         # list soju accounts
sojuctl user create -username X -password Y -admin
sojuctl user update <user> -password Z      # change/tweak an account
sojuctl user delete <user>

# per-user network / channel management (run admin cmds "as" a user)
sojuctl user run <user> network status                 # networks + connected state + channels
sojuctl user run <user> network update libera -enabled false   # disconnect from Libera
sojuctl user run <user> network update libera -enabled true    # reconnect
sojuctl user run <user> network create -addr ircs://... -name foo -nick <NICK>
sojuctl user run <user> network delete -network foo
sojuctl user run <user> certfp fingerprint -network libera     # show the cert fp
sojuctl user run <user> sasl status -network libera            # how it authenticates
```
Note the CLI quirk: `certfp`/`sasl` take `-network <name>`; `network create/update/delete`
take the name **positionally**.

`sojudb change-password <user>` also works and edits the DB directly (soju can be running).

### 3. BouncerServ — chat commands from weechat
Once weechat is connected to soju, message the built-in `BouncerServ` service — same
commands, run as chat:
```irc
/msg BouncerServ network status
/msg BouncerServ network update libera -enabled false
/msg BouncerServ help
```
Channels are managed just by using IRC normally: `/join #foo` / `/part #foo` — soju
remembers what you're in and rejoins on reconnect.

## Common tasks

| Task | How |
|------|-----|
| Is it up / connected? | `systemctl status soju` + `sojuctl user run <user> network status` |
| Restart after config change | edit `/etc/soju/config` → `systemctl restart soju` |
| See why it disconnected | `journalctl -u soju --since "1 hour ago"` |
| Reconnect a dropped network | `sojuctl user run <user> network update libera -enabled true` |
| Read missed messages on disk | `/var/lib/soju/logs/<user>/libera/#lilbee/*` |
| Change your soju password | `sojudb change-password <user>` (then update weechat sec.data.soju_pass) |
| Add another IRC network | `sojuctl user run <user> network create -addr ircs://... -name <n> -nick <nick>` |
| Rotate the Libera CertFP | `certfp generate` again → `/msg NickServ CERT ADD <new-fp>` → `CERT DEL <old-fp>` |

## Backup (what to save)

Everything soju needs is `/var/lib/soju/` (db + logs) and `/etc/soju/config`. Back those up
and the bouncer is fully recreatable. Secrets (soju password) live in weechat's `sec.conf`,
not here.

## Upgrades

`apt upgrade` handles the soju package. It's a native service, so no container rebuild —
`systemctl restart soju` picks up a new binary automatically after the package upgrade.

---

# Managing the Limnoria bot (lilbee-bot)

Runs as systemd service `lilbee-bot` on the box (CertFP auth, no password in config).

Quick controls (from the helpers in `lilbee.zsh` / `Makefile`):
```
make restart-bot          # or: lilbee-bot-restart   (zsh)
make bot-status
make bot-log
```
Identify to command it (private message, NOT in-channel):
```
/msg lilbee-bot identify <soju-user> <owner-password>
```

## Limnoria gotchas we hit (so future-you doesn't)
- **Config is rewritten on shutdown.** Editing `lilbee-bot.conf` while the bot runs and then
  restarting LOSES your edit (the dying process writes its old in-memory config back). Always
  **stop -> edit -> start**, or change settings via the bot's own `config` command over IRC.
- **Plugins need explicit enables.** Listing them in `supybot.plugins:` isn't enough; each needs
  `supybot.plugins.<Name>: True` or it won't load (symptom: bot joins but ignores every command,
  DEBUG log shows `findCallbacksForArgs: []`). setup-limnoria.sh includes these.

# lilbee-bot configuration (version-controlled "settings as code")

The live settings live on the box (config file + `data/#lilbee/Factoids.db`). This file is the
**reproducible** version: run these owner commands on a fresh bot to recreate the setup.

Configure by messaging the bot as owner (private message; drop the `!` in a query):
```
/msg lilbee-bot identify <soju-user> <owner-password>
```

> IMPORTANT: after changing settings over IRC, run **`flush`** to persist them to disk.
> A plain restart does NOT save unflushed registry changes (RSS feeds, herald, etc. get lost).
> Factoids are the exception — they write to a DB immediately.

## Plugins loaded
```
Admin Channel Config Factoids Herald Later MessageParser Misc Owner RSS Seen Services User Utilities Web
```
(Set in the config: `supybot.plugins: ...` plus `supybot.plugins.<Name>: True` for each.)

## Release announcements (RSS)  — auto-posts new lilbee releases to #lilbee
```
rss add lilbee https://github.com/tobocop2/lilbee/releases.atom
rss announce add #lilbee lilbee
config plugins.RSS.waitPeriod 300
flush
```

## Greeting new people (Herald)
```
herald default #lilbee Welcome to #lilbee, a local search engine you can talk to that runs on your own machine. Docs and install: https://lilbee.sh
flush
```

## FAQ (Factoids) — `!install`, `!docs`, etc.
```
learn #lilbee install is pipx install lilbee  (or see https://lilbee.sh)
learn #lilbee docs is https://lilbee.sh
learn #lilbee obsidian is Obsidian plugin -- https://obsidian.lilbee.sh
learn #lilbee source is https://github.com/tobocop2/lilbee
```
Use: `!install`, `!whatis <key>`, `!forget <key>`, `!change <key>` ... `!listkeys` to see all.

## Anti-flood (already sane defaults; tune if needed)
```
config supybot.abuse.flood.command.maximum 12
config supybot.abuse.flood.command.punishment 300
config supybot.abuse.flood.command.invalid.maximum 5
flush
```

## Auto-moderation (MessageParser) — add rules as real abuse patterns emerge
Loaded but empty by design (preemptive rules that misfire are worse than none). Add rules when
you see a pattern. Syntax: `messageparser add [#channel] "<regex>" "<action>"`. Examples:
```
# quiet anyone who pastes a known spam domain:
messageparser add #lilbee "badspam\\.example" "quiet $nick"
# list / remove rules:
messageparser list #lilbee
messageparser remove #lilbee <id>
```
(Network-level spam/flood bots are already auto-killed by Libera's Sigyn; you rarely need this.)

## Utilities available out of the box
```
!seen <nick>        # when someone was last around
!later tell <nick> <msg>   # deliver a message when they return  (Later plugin)
!title <url>        # fetch a page title  (Web plugin)
```

## Restart / manage
`lbbot` (zsh) or `make -C ~/projects/dotfiles/irc restart-bot`. See MODERATION.md for kick/ban/mute.

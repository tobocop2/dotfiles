# Moderating #lilbee — a practical field guide

Three things do moderation, from most to least persistent:

- **ChanServ** — Libera's services robot. Holds the access list + AKICK (permanent bans).
  Survives everything (reboots, you being offline). Use it for anything you want to *stick*.
- **You** (`NuclearEndorphin`) — founder, auto-opped (`@`). Full control, live and immediate.
- **lilbee-bot** (your Limnoria bot) — opped; command-driven moderation + automation.

Also: **Sigyn**, Libera's network-wide anti-spam bot, auto-kills spam/flood bots for you. You
don't manage it. Your channel baseline is already `+ntCc` (no external msgs, topic locked to
ops, no CTCP, colors stripped).

---

## The escalation ladder (what to reach for, in order)

1. **Talk to them.** Most things resolve here.
2. **Quiet (mute)** — they stay but can't send. Low-drama, reversible. Best first lever.
3. **Kick** — boot them; they *can* rejoin. A warning shot.
4. **Ban** — boot + block rejoin (until you lift it).
5. **AKICK (ChanServ)** — permanent, auto-enforced ban that works even when you're away.
6. **Escalate to Libera staff** for serious network abuse (see `#libera`).

Tip: prefer **account-based** actions (`$a:account`) over nick masks — a registered user can't
dodge them by changing nick.

---

## Doing it yourself (you're opped as @NuclearEndorphin)

These are weechat commands; run them from the `#lilbee` buffer (or add `#lilbee` as the first arg).

### Find out who someone is
```
/whois <nick>              # their account name, host, cloak
/mode #lilbee b            # list current bans
/mode #lilbee q            # list current quiets/mutes
```

### Quiet / mute (the everyday tool)
```
/mode #lilbee +q $a:<account>     # mute their registered account (evasion-proof)
/mode #lilbee +q <nick>!*@*       # mute by nick if unregistered
/mode #lilbee -q <mask>           # unmute (use the exact mask from `/mode #lilbee q`)
```

### Kick / ban
```
/kick <nick> <reason>             # remove; they can rejoin
/ban <nick>                       # add a ban (they can't rejoin)
/kickban <nick> <reason>          # kick AND ban in one
/unban <mask>                     # lift a ban
/mode #lilbee +b $a:<account>     # account-based ban (evasion-proof)
```

### Ops / voice
```
/op <nick>      /deop <nick>
/voice <nick>   /devoice <nick>
```

### Lock the channel down during a raid
```
/mode #lilbee +m     # moderated: only ops/voiced can talk
/mode #lilbee +r     # registered-users-only can join
/mode #lilbee -mr    # lift both when it's over
```

---

## Making it stick: ChanServ AKICK (permanent, auto-enforced)

AKICK bans + removes the target automatically whenever they try to join — even if you're offline.
```
/msg ChanServ AKICK #lilbee ADD $a:<account> !P <reason>   # !P = permanent
/msg ChanServ AKICK #lilbee ADD <nick>!*@* <reason>
/msg ChanServ AKICK #lilbee LIST
/msg ChanServ AKICK #lilbee DEL <mask-or-account>
```

## Giving trusted people moderator access
So others can help without being founder:
```
/msg ChanServ FLAGS #lilbee <their-account> +Oo    # auto-op + can op (what the bot has)
/msg ChanServ FLAGS #lilbee <their-account> +Vv    # auto-voice
/msg ChanServ FLAGS #lilbee <their-account> -*     # revoke everything
/msg ChanServ FLAGS #lilbee                        # show the access list
```

---

## Moderating via lilbee-bot

First identify to the bot (private message, once per session):
```
/msg lilbee-bot identify <soju-user> <owner-password>
```
Then, in-channel prefix commands with `!` (in a /msg to the bot, drop the `!`):
```
!kick <nick> <reason>
!ban <nick>            !unban <nick>
!kban <nick> <reason>          # kick + ban
!op / !deop / !voice / !devoice <nick>
!mode +m                       # set channel modes
!lobotomize / !unlobotomize    # make the bot ignore / attend a channel
```

---

## What else lilbee-bot can do (beyond moderation)

Already loaded — try these:
```
!seen <nick>       # when someone was last active in the channel
!tell <nick> <msg> # delivers your message the next time they're around
!help <command>    # help on anything
!list              # which plugins are loaded
!version           # bot version
```

Worth adding later (as owner: `!load <Plugin>`):
- **RSS** — auto-announce lilbee releases in the channel
  (point it at `https://github.com/tobocop2/lilbee/releases.atom`). Best bang for buck.
- **Factoids** — build a FAQ: `!learn install as: pipx install lilbee` → anyone types `!install`.
- **Web** — fetch page titles / info for links.
- Greeting new joiners and anti-flood auto-kick, when the channel grows.

Restart the bot after config changes: `lbbot` (or `make -C ~/projects/dotfiles/irc restart-bot`).

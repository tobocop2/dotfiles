# #lilbee on Libera.Chat — reproducible setup

Everything needed to recreate the `#lilbee` IRC channel, the **soju** bouncer that
keeps it always-on, and the weechat client that connects to it.

Secrets are **not** stored here — they're placeholders (`<...>`). Real values live in
weechat's encrypted `sec.conf` (`/secure`), not in version control.

```
placeholders used below
  <NICK>        Libera NickServ account / founder nick (e.g. NuclearEndorphin)
  <EMAIL>       email for NickServ registration
  <NS_PASS>     NickServ account password
  <SERVER_IP>   the always-on box running soju
  <SOJU_USER>   soju account username (your login on the box)
  <SOJU_PASS>   soju account password (generated; stored in weechat sec.data.soju_pass)
```

---

## Part 1 — Libera channel (one-time, from any IRC client)

Connect to `irc.libera.chat/6697` over TLS as `<NICK>`, then:

```irc
# register + verify the account (Libera emails a code)
/msg NickServ REGISTER <NS_PASS> <EMAIL>
/msg NickServ VERIFY REGISTER <NICK> <code-from-email>

# register the channel (you become founder)
/join #lilbee
/msg ChanServ REGISTER #lilbee

# harden it
/msg ChanServ OP #lilbee <NICK>
/msg ChanServ SET #lilbee GUARD ON        # ChanServ stays resident, protects modes
/msg ChanServ SET #lilbee SECURE ON       # only services-verified users get access
/msg ChanServ SET #lilbee KEEPTOPIC ON    # topic survives an empty channel
/mode #lilbee +c                          # strip mIRC colours
/mode #lilbee -s                          # discoverable via /LIST + ALIS
/msg ChanServ FLAGS #lilbee <NICK> +O     # auto-op founder on every join
/topic lilbee - a local search engine you can talk to. Runs on your machine, on demand. Site: https://lilbee.sh | Obsidian plugin: https://obsidian.lilbee.sh
```

Libera facts worth knowing: `NICKLEN=16` (max nick length), single-`#` channels are for
projects you own, `##` is for unofficial/about-topic.

---

## Part 2 — soju bouncer (on the always-on box)

Run `setup-soju.sh` on the server (Ubuntu 24.04). It installs soju, creates your account,
and adds the Libera network **disabled** so it doesn't connect yet (avoids a nick clash
with a client that's already on as `<NICK>`).

```sh
sudo ./setup-soju.sh <SOJU_USER> <NICK>
# it prints the generated <SOJU_PASS> and the SHA-512 CertFP fingerprint
```

---

## Part 3 — link soju to Libera via CertFP (no password stored)

`setup-soju.sh` generated a client cert for the `libera` network and printed its
**SHA-512** fingerprint. Libera requires SHA2-512 (not SHA-256).

From a client that's **currently identified** as `<NICK>` on Libera (e.g. your existing
direct weechat connection), authorize that fingerprint:

```irc
/msg NickServ CERT ADD <sha512-fingerprint>
```

Then enable the soju network so it connects via SASL EXTERNAL (CertFP):

```sh
sudo sojuctl user run <SOJU_USER> network update libera -enabled true
sudo sojuctl user run <SOJU_USER> network status      # -> [connected]
```

---

## Part 4 — point weechat at soju

soju becomes the middleman: **weechat → soju → Libera**. The `username/network` form
binds the connection straight to the libera network.

```irc
/server add lilbee <SERVER_IP>/6697 -tls
/set irc.server.lilbee.tls_verify off                 # soju ships a self-signed cert
/set irc.server.lilbee.sasl_mechanism plain
/set irc.server.lilbee.sasl_username "<SOJU_USER>/libera"
/secure set soju_pass <SOJU_PASS>
/set irc.server.lilbee.sasl_password "${sec.data.soju_pass}"
/set irc.server.lilbee.autojoin ""                    # soju remembers joined channels
/connect lilbee
/join #lilbee
```

You should land in `#lilbee` as `<NICK>`, founder-opped, with `CHATHISTORY` backlog replay
(soju replays what you missed while disconnected — the whole point of the bouncer).

---

## Gotchas (learned the hard way)

- Libera CertFP fingerprints must be **SHA-512** (128 hex chars). SHA-256 is rejected.
- soju's `certfp`/`sasl` subcommands take `-network <name>`; `network create/update` take the
  name **positionally**. Inconsistent, but that's the CLI.
- soju's default TLS listener uses the snakeoil self-signed cert, so the client needs
  `tls_verify off` (or install a real cert for an `irc.` subdomain).
- Connecting with just `<SOJU_USER>` lands on soju's multi-network bouncer connection where
  you can't `/join`. Use `<SOJU_USER>/libera` to bind to one network.
- Only one connection can hold nick `<NICK>` at a time — disconnect any direct client before
  enabling soju's network, or create the network `-enabled false` first (as the script does).

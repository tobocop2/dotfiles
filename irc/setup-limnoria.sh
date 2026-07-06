#!/usr/bin/env bash
# Deploy Limnoria (the #lilbee moderation bot) as a systemd service on Ubuntu 24.04.
# Auth to Libera via CertFP (SASL EXTERNAL) -> NO password in the config.
#
# Prereqs (do first, see libera-project-registration.md style flow):
#   1. Register + verify the bot's NickServ account (e.g. lilbee-bot).
#   2. You'll add the cert fingerprint this script prints to that account.
#
# Usage:  sudo ./setup-limnoria.sh <bot_nick>
set -euo pipefail
BOT="${1:?usage: setup-limnoria.sh <bot_nick>}"
DIR=/var/lib/limnoria
export DEBIAN_FRONTEND=noninteractive

apt-get update -q
apt-get install -y limnoria
id limnoria &>/dev/null || useradd -r -m -d "$DIR" -s /usr/sbin/nologin limnoria
mkdir -p "$DIR"/{data,conf,logs,backup,plugins}

# CertFP client cert (no password auth)
cd "$DIR"
openssl req -x509 -newkey rsa:2048 -keyout "$BOT.key" -out "$BOT.crt" -days 3650 -nodes -subj "/CN=$BOT" 2>/dev/null
cat "$BOT.crt" "$BOT.key" > "$BOT.pem"; chmod 600 "$BOT.key" "$BOT.pem"
FP=$(openssl x509 -noout -fingerprint -sha512 -in "$BOT.crt" | sed 's/.*=//; s/://g' | tr 'A-F' 'a-f')

# Bot config (CertFP; realname marks it a bot + its admin, per Libera rules)
cat > "$DIR/$BOT.conf" <<CONF
supybot.nick: $BOT
supybot.ident: ${BOT//-/}
supybot.user: lilbee moderation bot - run by NuclearEndorphin | https://lilbee.sh
supybot.networks: libera
supybot.networks.libera.servers: irc.libera.chat:6697
supybot.networks.libera.ssl: True
supybot.networks.libera.channels: #lilbee
supybot.networks.libera.certfile: $DIR/$BOT.pem
supybot.networks.libera.sasl.username: $BOT
supybot.networks.libera.sasl.mechanisms: external
supybot.directories.data: $DIR/data
supybot.directories.conf: $DIR/conf
supybot.directories.log: $DIR/logs
supybot.directories.backup: $DIR/backup
supybot.directories.plugins: $DIR/plugins
supybot.databases.users.allowUnregistration: True
supybot.plugins: Owner User Config Admin Channel Misc Services Utilities Seen
supybot.plugins.Owner: True
supybot.plugins.User: True
supybot.plugins.Config: True
supybot.plugins.Admin: True
supybot.plugins.Channel: True
supybot.plugins.Misc: True
supybot.plugins.Services: True
supybot.plugins.Utilities: True
supybot.plugins.Seen: True
supybot.plugins.Services.NickServ: NickServ
supybot.plugins.Services.ChanServ: ChanServ
supybot.reply.whenAddressedBy.chars: !
supybot.log.stdout: False
CONF

# systemd unit
cat > /etc/systemd/system/$BOT.service <<UNIT
[Unit]
Description=Limnoria IRC bot ($BOT) for #lilbee
After=network-online.target
Wants=network-online.target
[Service]
Type=simple
User=limnoria
Group=limnoria
WorkingDirectory=$DIR
ExecStart=/usr/bin/limnoria $DIR/$BOT.conf
Restart=on-failure
RestartSec=10
[Install]
WantedBy=multi-user.target
UNIT

chown -R limnoria:limnoria "$DIR"
systemctl daemon-reload

cat <<EOF

======================================================================
 Limnoria configured for $BOT (CertFP, no password in config).
----------------------------------------------------------------------
 BEFORE starting, authorize the cert on the bot's NickServ account:
   (identify as $BOT with its recovery password, then)
   /msg NickServ CERT ADD $FP     <-- Libera requires SHA-512

 Then start it:
   sudo systemctl enable --now $BOT

 Give it channel op (from the channel founder's client):
   /msg ChanServ FLAGS #lilbee $BOT +Oo

 Add a bot owner so you can command it:
   sudo -u limnoria env HOME=$DIR supybot-adduser -u <you> -p <pw> -c owner $DIR/conf/users.conf
   then in IRC:  /msg $BOT identify <you> <pw>
======================================================================
EOF

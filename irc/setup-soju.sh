#!/usr/bin/env bash
# Install + configure soju as a systemd service (NOT docker) on Ubuntu 24.04.
# soju is a single Go binary; it runs under systemd, stores state in
# /var/lib/soju/ (sqlite db + message logs) and reads /etc/soju/config.
#
# Usage:  sudo ./setup-soju.sh <soju_user> <libera_nick>
set -euo pipefail

SOJU_USER="${1:?usage: setup-soju.sh <soju_user> <libera_nick>}"
NICK="${2:?usage: setup-soju.sh <soju_user> <libera_nick>}"

export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get install -y soju
systemctl enable --now soju

# soju account (what your IRC client logs into). Password is generated, not stored here.
SOJU_PASS="$(openssl rand -base64 15 | tr -d '/+=' | cut -c1-18)"
sojuctl user create -username "$SOJU_USER" -password "$SOJU_PASS" -admin

# Add the Libera network DISABLED, so it doesn't connect yet (avoids a nick clash with a
# client already on Libera as $NICK). We enable it after CertFP is authorized.
sojuctl user run "$SOJU_USER" network create \
  -addr ircs://irc.libera.chat:6697 -name libera \
  -nick "$NICK" -realname "$NICK" -enabled false

# Generate the CertFP client cert for the libera network + read its SHA-512 fingerprint.
sojuctl user run "$SOJU_USER" certfp generate -network libera >/dev/null
FP="$(sojuctl user run "$SOJU_USER" certfp fingerprint -network libera | awk '/SHA-512/{print $NF}')"

cat <<EOF

======================================================================
 soju installed + configured  (systemd service 'soju', NOT docker)
----------------------------------------------------------------------
 soju login : $SOJU_USER
 soju pass  : $SOJU_PASS      <-- SAVE THIS (goes in weechat sec.data.soju_pass)
 Libera nick: $NICK  (network 'libera' created, currently DISABLED)

 NEXT STEPS:
 1. From an IRC client identified as $NICK on Libera, authorize the cert:
      /msg NickServ CERT ADD $FP
 2. Enable the network so soju connects via CertFP:
      sudo sojuctl user run $SOJU_USER network update libera -enabled true
 3. Point your IRC client at this box: <SERVER_IP>/6697, tls, tls_verify off,
    SASL PLAIN user "$SOJU_USER/libera", pass = the soju pass above.
======================================================================
EOF

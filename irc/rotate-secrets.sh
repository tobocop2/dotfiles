#!/usr/bin/env bash
# Regenerate (rotate) all generated lilbee IRC secrets. Run on the server as root.
# New values are written ONLY to a root-only file; nothing is printed.
#
#   soju account password        -> update weechat sec.data.soju_pass afterwards
#   lilbee-bot owner password    -> save in your password manager
#   lilbee-bot NickServ recovery -> save in your password manager (bot connects via CertFP)
#
# Usage:  sudo ./rotate-secrets.sh [soju_user] [bot_nick]
set -uo pipefail
SOJU_USER="${1:?usage: rotate-secrets.sh <soju_user> [bot_nick]}"
BOT="${2:-lilbee-bot}"
DIR=/var/lib/limnoria
OUT=/root/lilbee-new-secrets.txt
umask 077; : > "$OUT"
gen(){ openssl rand -base64 24 | tr -d '/+=' | cut -c1-24; }

# 1) soju account password
NEW_SOJU=$(gen)
sojuctl user update "$SOJU_USER" -password "$NEW_SOJU" >/dev/null 2>&1 && S1=ok || S1=FAILED
{ echo "[soju] '$SOJU_USER' NEW password: $NEW_SOJU"
  echo "  weechat:  /secure set soju_pass $NEW_SOJU  ;  /reconnect lilbee   (status:$S1)"; echo; } >> "$OUT"

systemctl stop "$BOT"; sleep 2

# 2) bot owner password (fresh users db)
NEW_OWNER=$(gen)
rm -f "$DIR/conf/users.conf"
(cd "$DIR" && sudo -u limnoria env HOME="$DIR" supybot-adduser -u "$SOJU_USER" -p "$NEW_OWNER" -c owner "$DIR/conf/users.conf") >/dev/null 2>&1 && S2=ok || S2=FAILED
chown -R limnoria:limnoria "$DIR/conf"
{ echo "[$BOT owner] '$SOJU_USER' NEW password: $NEW_OWNER"
  echo "  identify: /msg $BOT identify $SOJU_USER $NEW_OWNER   (status:$S2)"; echo; } >> "$OUT"

# 3) bot NickServ recovery password (via SASL EXTERNAL / CertFP -- Libera requires SASL from VPS IPs)
NEW_BOTNS=$(gen)
cat > /tmp/rot.py <<'PY'
import socket,ssl,os,time
NEW=os.environ["NEW_BOTNS"]; PEM=os.environ["PEM"]; NICK=os.environ["NICK"]
ctx=ssl.create_default_context(); ctx.load_cert_chain(PEM)
s=ctx.wrap_socket(socket.create_connection(("irc.libera.chat",6697),timeout=20),server_hostname="irc.libera.chat"); s.settimeout(4)
snd=lambda l: s.sendall((l+"\r\n").encode())
snd("CAP LS 302"); snd(f"NICK {NICK}"); snd(f"USER {NICK} 0 * :bot")
buf="";ok=False;ident=False;dl=time.time()+25
while time.time()<dl:
    try:d=s.recv(4096).decode("utf-8","replace")
    except:d=""
    buf+=d
    while "\r\n" in buf:
        line,buf=buf.split("\r\n",1); low=line.lower(); p=line.split(" ")
        if line.startswith("PING"): snd("PONG "+line.split(" ",1)[1]); continue
        if " cap " in low and " ls " in low: snd("CAP REQ :sasl")
        elif " cap " in low and " ack " in low and "sasl" in low: snd("AUTHENTICATE EXTERNAL")
        elif line.rstrip().endswith("AUTHENTICATE +"): snd("AUTHENTICATE +")
        elif len(p)>1 and p[1]=="903": snd("CAP END")
        elif len(p)>1 and p[1]=="001" and not ident:
            ident=True; time.sleep(1); snd("PRIVMSG NickServ :SET PASSWORD "+NEW)
        if "nickserv" in low and "password" in low and ("changed" in low or "successfully" in low): ok=True
snd("QUIT"); time.sleep(0.3); s.close(); print("ok" if ok else "UNCONFIRMED")
PY
S3=$(NEW_BOTNS="$NEW_BOTNS" PEM="$DIR/$BOT.pem" NICK="$BOT" python3 /tmp/rot.py 2>&1 | tail -1); rm -f /tmp/rot.py
{ echo "[$BOT NickServ] recovery password: $NEW_BOTNS   (status:$S3)"; echo; } >> "$OUT"

systemctl start "$BOT"; systemctl restart soju
{ echo "== read this, apply the weechat change, save the rest, then: rm $OUT =="; } >> "$OUT"
chmod 600 "$OUT"
echo "ROTATION DONE (no secrets printed). New values -> $OUT  [soju:$S1 owner:$S2 botns:$S3]"

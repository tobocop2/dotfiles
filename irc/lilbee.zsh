# lilbee IRC service helpers -- restart/inspect soju + the moderation bot on the box.
# Safe to source unconditionally; set LILBEE_HOST when you want to use them.
#
#   source ~/projects/dotfiles/irc/lilbee.zsh          # in ~/.zshrc
#   export LILBEE_HOST=user@host                        # in a PRIVATE, un-versioned file
#
_lilbee_host() {
  [[ -n "$LILBEE_HOST" ]] && return 0
  echo "lilbee: set LILBEE_HOST=user@host (e.g. in ~/.zshenv.local) first" >&2
  return 1
}

lilbee-bot-restart()  { _lilbee_host || return; ssh "$LILBEE_HOST" sudo systemctl restart lilbee-bot && echo "lilbee-bot restarted"; }
lilbee-bot-status()   { _lilbee_host || return; ssh "$LILBEE_HOST" systemctl --no-pager status lilbee-bot; }
lilbee-bot-log()      { _lilbee_host || return; ssh "$LILBEE_HOST" tail -n 50 -f /var/lib/limnoria/logs/messages.log; }

lilbee-soju-restart() { _lilbee_host || return; ssh "$LILBEE_HOST" sudo systemctl restart soju && echo "soju restarted"; }
lilbee-soju-status()  { _lilbee_host || return; local u="${LILBEE_HOST%%@*}"; ssh "$LILBEE_HOST" "echo soju=\$(systemctl is-active soju); sudo sojuctl user run $u network status"; }
lilbee-soju-log()     { _lilbee_host || return; ssh "$LILBEE_HOST" journalctl -u soju -f; }

# short aliases
alias lbbot='lilbee-bot-restart'
alias lbsoju='lilbee-soju-restart'

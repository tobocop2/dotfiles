# lilbee IRC service management.  make restart-bot | restart-soju | bot-log | ...
#
# Set your host privately (NOT committed):  export LILBEE_HOST=user@host
# or per-invocation:                         make restart-bot HOST=user@host
HOST ?= $(LILBEE_HOST)

ifeq ($(strip $(HOST)),)
$(error Set LILBEE_HOST=user@host in your environment, or pass HOST=user@host)
endif

USER := $(firstword $(subst @, ,$(HOST)))

.PHONY: restart-bot restart-soju bot-status soju-status bot-log soju-log

restart-bot:  ; ssh $(HOST) sudo systemctl restart lilbee-bot && echo "lilbee-bot restarted"
restart-soju: ; ssh $(HOST) sudo systemctl restart soju && echo "soju restarted"
bot-status:   ; ssh $(HOST) systemctl --no-pager status lilbee-bot
soju-status:  ; ssh $(HOST) 'echo soju=$$(systemctl is-active soju); sudo sojuctl user run $(USER) network status'
bot-log:      ; ssh $(HOST) tail -n 50 -f /var/lib/limnoria/logs/messages.log
soju-log:     ; ssh $(HOST) journalctl -u soju -f

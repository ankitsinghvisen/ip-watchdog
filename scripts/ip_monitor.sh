#!/bin/bash

# ================= CONFIG =================
IP_FILE="/var/tmp/last_public_ip"
LOG_DIR="/usr/local/bin/logs"
# ==========================================

# Source external configuration
source /usr/local/bin/config.sh

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_DIR/ip_monitor.log"
}

get_public_ip() {
    local ip
    for source in "${IP_SOURCES[@]}"; do
        ip=$(curl -s --max-time 5 "$source" | tr -d '[:space:]')
        if [[ -n "$ip" ]]; then
            echo "$ip"
            return
        fi
    done
    echo ""
}

send_mail() {
    local OLD_IP="$1"
    local NEW_IP="$2"
    local LOCAL_IP
    local HOSTNAME

    LOCAL_IP=$(hostname -I | awk '{print $1}')
    HOSTNAME=$(hostname)

    /usr/sbin/sendmail -t <<EOF
To: $EMAIL_TO
Subject: [Alert] Public IP Changed on $HOSTNAME - $LOCAL_IP

Hello SysAdmin Team,

==================================================
PUBLIC IP MONITOR ALERT
==================================================

Host           : $HOSTNAME
Local IP       : $LOCAL_IP
Old Public IP  : $OLD_IP  --->  New Public IP : $NEW_IP
Time           : $(date)

This is an automated alert from your Public IP Monitor Service.
Please do not reply to this email.
==================================================
EOF

    log "Notification sent to $EMAIL_TO"
}

log "Public IP monitor started..."

while true; do
    CURRENT_IP=$(get_public_ip)

    if [[ -z "$CURRENT_IP" ]]; then
        log "Failed to fetch public IP from all sources"
        sleep "$CHECK_INTERVAL"
        continue
    fi

    if [[ ! -f "$IP_FILE" ]]; then
        echo "$CURRENT_IP" > "$IP_FILE"
        log "Initial IP saved: $CURRENT_IP"
        sleep "$CHECK_INTERVAL"
        continue
    fi

    LAST_IP=$(cat "$IP_FILE")

    if [[ "$CURRENT_IP" != "$LAST_IP" ]]; then
        log "IP changed: $LAST_IP -> $CURRENT_IP"
        echo "$CURRENT_IP" > "$IP_FILE"
        send_mail "$LAST_IP" "$CURRENT_IP"
    fi

    sleep "$CHECK_INTERVAL"
done

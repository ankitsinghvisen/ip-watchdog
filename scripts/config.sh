#!/bin/bash
# ================= CONFIGURATION =================

# Recipient email address
EMAIL_TO="" #Modify the Email Address whom the email Alert has to be trigerred

# Interval in seconds for checking public IP
CHECK_INTERVAL=60

# Optional: Add/remove public IP sources (URLs)
IP_SOURCES=(
    "https://checkip.amazonaws.com"
    "https://icanhazip.com"
    "https://ip.me"
)

# ==================================================

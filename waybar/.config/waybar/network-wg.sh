#!/usr/bin/env bash
# Single JSON output for Waybar: VPN lock + network info
# Requires: nmcli, (optional) iwgetid

WG_NAME="${WG_NAME:-unraid-wg}"

vpn_on="0"
if nmcli -t -f NAME,TYPE connection show --active | grep -q "^${WG_NAME}:wireguard$"; then
  vpn_on="1"
fi

# Default values
net_class="net-down"
net_text="   no net"

# detect active device(s)
# Example lines: "DEVICE  TYPE      STATE      CONNECTION"
#                "wlan0   wifi      connected  MySSID"
#                "enp3s0  ethernet  connected  Wired connection 1"
while IFS= read -r line; do
  # Skip header (if any)
  if [[ "$line" == DEVICE* ]]; then continue; fi
  dev=$(echo "$line" | awk '{print $1}')
  typ=$(echo "$line" | awk '{print $2}')
  st=$(echo "$line" | awk '{print $3}')
  conn=$(echo "$line" | cut -d' ' -f4-)

  if [[ "$st" == "connected" ]]; then
    if [[ "$typ" == "wifi" ]]; then
      ssid=$(iwgetid -r 2>/dev/null)
      [[ -z "$ssid" ]] && ssid="$conn"
      net_class="net-wifi"
      net_text="   ${ssid}"
      break
    elif [[ "$typ" == "ethernet" ]]; then
      net_class="net-ethernet"
      net_text="   ${dev}"
      break
    fi
  fi
done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev status | sed 's/:/ /g')

# VPN icon
if [[ "$vpn_on" == "1" ]]; then
  lock=""
  vpn_class="vpn-on"
  tip="WireGuard: connected"
else
  lock=""
  vpn_class="vpn-off"
  tip="WireGuard: disconnected"
fi

# Emit JSON (one module = one bubble)
echo "{\"text\":\"${lock} ${net_text}\",\"tooltip\":\"${tip}\",\"class\":\"${vpn_class} ${net_class}\"}"

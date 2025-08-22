#!/usr/bin/env bash
set -euo pipefail

### ---------- CONFIG ----------
WG_NAME="${WG_NAME:-unraid-wg}"

# Server reachability (used to wait before mounting)
SERVER_HOST="${SERVER_HOST:-192.168.0.254}"
SERVER_PORT="${SERVER_PORT:-445}"   # SMB

# If true, require a polkit GUI auth (pkexec) before connecting + mounting.
# Set to "false" to skip pkexec entirely.
REQUIRE_PKEXEC="${REQUIRE_PKEXEC:-true}"

# Credentials sanity check (optional but helpful when using user-mounts)
CREDS_FILE="${CREDS_FILE:-$HOME/.smbcredentials}"  # or /etc/samba/creds
CHECK_CREDS="${CHECK_CREDS:-true}"

# Define shares:
#  - If an item contains a colon, it's "SRC:DEST", e.g. //192.168.0.254/public:/mnt/public
#  - If it doesn't, it's treated as a DEST only and must exist in /etc/fstab
SHARES=(
  "/mnt/public"
  "/mnt/media"
  "/mnt/downloads"
)
### -------- END CONFIG --------

LOG="${XDG_STATE_HOME:-$HOME/.local/state}/wg-toggle.log"
mkdir -p "$(dirname "$LOG")"

log(){ printf '%s  %s\n' "$(date '+%F %T')" "$*" | tee -a "$LOG" >&2; }
notify(){ command -v notify-send >/dev/null && notify-send "WireGuard" "$1"; }

is_vpn_up(){
  nmcli -t -f NAME,TYPE connection show --active | grep -q "^${WG_NAME}:wireguard$"
}

tcp_ready(){
  # Uses bash's /dev/tcp if available; otherwise falls back to nc/ping.
  if timeout 1 bash -lc "</dev/tcp/${SERVER_HOST}/${SERVER_PORT}" 2>/dev/null; then
    return 0
  elif command -v nc >/dev/null 2>&1; then
    nc -z -w1 "$SERVER_HOST" "$SERVER_PORT" >/dev/null 2>&1
  else
    ping -c1 -W1 "$SERVER_HOST" >/dev/null 2>&1
  fi
}

wait_for_server(){
  local tries="${1:-20}" delay="${2:-0.5}"
  for ((i=1;i<=tries;i++)); do
    if tcp_ready; then return 0; fi
    sleep "$delay"
  done
  return 1
}

# Parse a share item.
# Input:  either "//host/share:/mnt/path"  or  "/mnt/path"
# Output: echo "SRC DEST"  where SRC may be empty if using fstab entry
parse_share(){
  local item="$1"
  if [[ "$item" == *:* ]]; then
    # Explicit "SRC:DEST"
    printf '%s %s\n' "${item%%:*}" "${item#*:}"
  else
    # DEST only (expects fstab line for this mountpoint)
    printf '%s %s\n' "" "$item"
  fi
}

mount_one(){
  local spec dest src opts out rc
  spec="$(parse_share "$1")"
  src="${spec%% *}"
  dest="${spec##* }"

  mkdir -p "$dest"

  if mountpoint -q "$dest"; then
    return 0
  fi

  if [[ -n "$src" ]]; then
    # Direct CIFS mount (bypasses fstab) — uses common options.
    # Useful if you prefer defining shares as SRC:DEST above.
    # You can still keep fstab entries for convenience; this path ignores them.
    opts="rw,uid=$(id -u),gid=$(id -g),vers=3.0,sec=ntlmssp,noserverino,iocharset=utf8,soft"
    if [[ -r "${CREDS_FILE}" ]]; then
      opts="credentials=${CREDS_FILE},${opts}"
    fi
    out="$(mount -t cifs "$src" "$dest" -o "$opts" 2>&1)" || rc=$?
  else
    # Use fstab entry (must include 'user,noauto')
    out="$(mount -v "$dest" 2>&1)" || rc=$?
  fi

  if [[ "${rc:-0}" -ne 0 ]]; then
    log "MOUNT FAIL: $dest  -- $out"
    return 1
  fi
  log "MOUNT OK:   $dest"
  return 0
}

umount_one(){
  local spec dest out rc
  spec="$(parse_share "$1")"
  dest="${spec##* }"

  if ! mountpoint -q "$dest"; then
    return 0
  fi

  # Clean unmount; if busy, nudge processes; lazy as last resort
  if out="$(umount "$dest" 2>&1)"; then
    log "UNMOUNT OK: $dest"
    return 0
  fi
  fuser -km "$dest" 2>/dev/null || true
  sleep 0.3
  if out="$(umount "$dest" 2>&1)"; then
    log "UNMOUNT OK: $dest"
    return 0
  fi
  out="$(umount -l "$dest" 2>&1)" || rc=$?
  if [[ "${rc:-0}" -ne 0 ]]; then
    log "UNMOUNT FAIL: $dest  -- $out"
    return 1
  fi
  log "UNMOUNT LAZY: $dest"
  return 0
}

mount_shares(){
  local fail=0
  for s in "${SHARES[@]}"; do
    mount_one "$s" || fail=1
  done
  return $fail
}

umount_shares(){
  local fail=0
  # Unmount reverse order to reduce dependency/busy issues
  for ((i=${#SHARES[@]}-1; i>=0; i--)); do
    umount_one "${SHARES[$i]}" || fail=1
  done
  return $fail
}

creds_ok(){
  [[ "$CHECK_CREDS" != "true" ]] && return 0
  [[ -z "$CREDS_FILE" ]] && return 0
  if [[ ! -r "$CREDS_FILE" ]]; then
    log "WARN: creds file not readable by $(id -un): $CREDS_FILE"
    return 1
  fi
  return 0
}

need_pkexec(){
  [[ "$REQUIRE_PKEXEC" == "true" ]] || return 1
  return 0
}

# ------------- main -------------
if is_vpn_up; then
  # Already connected → unmount and disconnect; no prompts.
  log "VPN is up — unmounting and disconnecting"
  umount_shares || true
  nmcli connection down "$WG_NAME" || true
  notify "Disconnected ${WG_NAME} (shares unmounted)"
  exit 0
fi

# VPN is down → optionally require a polkit GUI auth before proceeding.
if need_pkexec; then
  log "Requesting admin auth via pkexec gate"
  if ! pkexec /bin/true; then
    notify "Cancelled admin auth — no changes made"
    log "pkexec cancelled/failed"
    exit 1
  fi
fi

log "Bringing VPN up: $WG_NAME"
nmcli -w 20 connection up "$WG_NAME" || { notify "Failed to connect ${WG_NAME}"; log "VPN up failed"; exit 1; }

log "Waiting for ${SERVER_HOST}:${SERVER_PORT}"
if ! wait_for_server 30 0.5; then
  log "WARN: server not reachable yet; attempting mounts anyway"
fi

if ! creds_ok; then
  log "Hint: for user-mounts, the creds file must be owned by you and chmod 600"
fi

if mount_shares; then
  notify "Connected ${WG_NAME} + shares mounted"
  log "All mounts succeeded"
else
  notify "Connected ${WG_NAME}, but some mounts failed (see $LOG)"
  log "One or more mounts failed"
fi

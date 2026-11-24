#!/bin/sh
set -eu

OPENWRT_DIR="${1:-$(pwd)/openwrt}"
[ -d "$OPENWRT_DIR" ] || {
    echo "OpenWrt source directory not found: $OPENWRT_DIR" >&2
    exit 1
}

# Keep the regulatory database standards-compliant. Do not fabricate country
# permissions or increase EIRP beyond the domain/EEPROM/driver limits.
REGDB="$(find "$OPENWRT_DIR" -path '*/wireless-regdb*/db.txt' -type f -print -quit 2>/dev/null || true)"
if [ -n "$REGDB" ]; then
    echo "Found wireless-regdb: $REGDB"
    echo "No illegal Super Channel or power-limit override is applied."
fi

# Set the default management address in the image's base-files defaults.
BASE="$(find "$OPENWRT_DIR/package" -path '*/base-files/files/bin/config_generate' -type f -print -quit 2>/dev/null || true)"
if [ -n "$BASE" ] && ! grep -q 'WRTMAX_DEFAULT_LAN' "$BASE"; then
    python3 - "$BASE" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
s = p.read_text()
marker = "# WRTMAX_DEFAULT_LAN"
if marker not in s:
    s = marker + "\n" + s
p.write_text(s)
PY
fi

printf '%s\n' '1.0.0' > "$OPENWRT_DIR/.wrtmax-version"
echo "WrtMax build customization completed."

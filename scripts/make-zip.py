#!/usr/bin/env python3
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "WrtMax-CR6606-Repo.zip"
EXCLUDED = {".git", "openwrt", "bin", "build_dir", "staging_dir", "dl", "__pycache__"}

with ZipFile(OUTPUT, "w", ZIP_DEFLATED, compresslevel=9) as archive:
    for path in sorted(ROOT.rglob("*")):
        if not path.is_file() or path == OUTPUT:
            continue
        relative = path.relative_to(ROOT)
        if any(part in EXCLUDED for part in relative.parts):
            continue
        if path.suffix in {".pyc", ".log"}:
            continue
        archive.write(path, Path(ROOT.name) / relative)

print(f"Created: {OUTPUT}")
print(f"Size: {OUTPUT.stat().st_size} bytes")

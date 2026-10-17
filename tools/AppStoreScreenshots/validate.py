#!/usr/bin/env python3
"""Validate proposed screenshot bytes with the standard library and macOS sips."""
import hashlib
import json
from pathlib import Path
import struct
import subprocess

root = Path('docs/app-store/screenshot-redesign-2026-10-17')
manifest = json.loads((root / 'manifest.json').read_text())
assert len(manifest) == 8
records = []
for item in manifest:
    path = root / item['file']
    data = path.read_bytes()
    assert data[:8] == b'\x89PNG\r\n\x1a\n', path
    width, height, depth, color = struct.unpack('>IIBB', data[16:26])
    assert (width, height) == (item['width'], item['height']), path
    assert depth == 8 and color == 2, f'{path}: expected 8-bit opaque RGB'
    profile = subprocess.check_output(['sips', '-g', 'profile', '-g', 'hasAlpha', str(path)], text=True)
    assert 'hasAlpha: no' in profile and 'srgb' in profile.lower(), profile
    source = root / item['raw']
    records.append({
        'file': item['file'], 'sha256': hashlib.sha256(data).hexdigest(),
        'width': width, 'height': height, 'bitsPerChannel': depth,
        'pngColorType': color, 'alpha': False, 'profile': 'sRGB',
        'raw': item['raw'], 'rawSha256': hashlib.sha256(source.read_bytes()).hexdigest(),
        'caption': item['caption'], 'detail': item['detail'], 'sourceCrop': item['sourceCrop']
    })
approval_path = root / 'approval.json'
status = 'proposed; approval pending'
if approval_path.exists():
    approval = json.loads(approval_path.read_text())
    approved = {item['file']: item['sha256'] for item in approval['approvedExports']}
    assert approved == {item['file']: item['sha256'] for item in records}, 'Approved exports changed'
    status = 'approved exports verified; see release record for live publication status'
result = {'status': status, 'validated': True,
          'count': len(records), 'platforms': ['iPhone', 'iPad'],
          'specificationChecked': '2026-10-17',
          'specificationURL': 'https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications',
          'files': records}
(root / 'validation.json').write_text(json.dumps(result, indent=2) + '\n')
print('PASS: eight correctly sized opaque 8-bit sRGB RGB PNGs; export and source hashes recorded.')

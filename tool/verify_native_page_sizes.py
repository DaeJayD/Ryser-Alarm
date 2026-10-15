"""Inspect packaged 64-bit ELF LOAD segments for Android 16 KB compatibility."""
import struct
import sys
import zipfile
from pathlib import Path


def verify(path: Path) -> None:
    failures = []
    checked = 0
    with zipfile.ZipFile(path) as archive:
        for name in archive.namelist():
            if not name.endswith('.so') or not any(abi in name for abi in ('arm64-v8a/', 'x86_64/')):
                continue
            data = archive.read(name)
            if data[:4] != b'\x7fELF' or data[4:6] != b'\x02\x01':
                failures.append(f'{name}: not a little-endian ELF64 library')
                continue
            offset = struct.unpack_from('<Q', data, 32)[0]
            entry_size, count = struct.unpack_from('<HH', data, 54)
            checked += 1
            for index in range(count):
                header = offset + index * entry_size
                segment_type = struct.unpack_from('<I', data, header)[0]
                if segment_type != 1:
                    continue
                file_offset, address = struct.unpack_from('<QQ', data, header + 8)
                alignment = struct.unpack_from('<Q', data, header + 48)[0]
                if alignment < 16384 or file_offset % 16384 != address % 16384:
                    failures.append(f'{name}: LOAD segment {index} alignment {alignment}')
            print(f'Checked {name}')
    if not checked:
        failures.append('No packaged 64-bit native libraries were found')
    if failures:
        raise SystemExit('\n'.join(failures))
    print(f'PASS: {checked} ELF64 libraries support 16 KB LOAD alignment.')


if __name__ == '__main__':
    verify(Path(sys.argv[1]))

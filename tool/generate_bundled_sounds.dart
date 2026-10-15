import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

// Deterministic, offline PCM fixtures for Ryser's small validated sound
// families. Run with: dart run tool/generate_bundled_sounds.dart
void main() {
  const sampleRate = 22050;
  const seconds = 2.4;
  final frames = (sampleRate * seconds).round();
  final target = Directory('android/app/src/main/res/raw')
    ..createSync(recursive: true);
  for (final family in ['pulse_a', 'melodic_a', 'urgent_a']) {
    final bytes = ByteData(44 + frames * 2);
    _header(bytes, sampleRate, frames);
    for (var frame = 0; frame < frames; frame++) {
      final time = frame / sampleRate;
      final note = _note(family, time);
      var value = 0.0;
      if (note != null) {
        final phase = 2 * math.pi * note.frequency * time;
        final edge = math.min(
          1.0,
          math.min(
            note.localTime / 0.014,
            (note.duration - note.localTime) / 0.024,
          ),
        );
        final envelope = edge.clamp(0.0, 1.0);
        value =
            (math.sin(phase) + 0.18 * math.sin(phase * 2)) *
            note.amplitude *
            envelope;
      }
      bytes.setInt16(
        44 + frame * 2,
        (value.clamp(-1.0, 1.0) * 32767).round(),
        Endian.little,
      );
    }
    File('${target.path}/$family.wav')
        .writeAsBytesSync(bytes.buffer.asUint8List());
  }
}

_Note? _note(String family, double time) {
  switch (family) {
    case 'pulse_a':
      const beat = 0.6;
      final local = time % beat;
      if (local >= 0.34) return null;
      return _Note(local, 0.34, (time ~/ beat).isEven ? 520 : 660, 0.19);
    case 'melodic_a':
      const beat = 0.6;
      final index = (time / beat).floor().clamp(0, 3);
      final local = time % beat;
      if (local >= 0.46) return null;
      return _Note(local, 0.46, [523.25, 659.25, 783.99, 659.25][index], 0.17);
    case 'urgent_a':
      const beat = 0.3;
      final local = time % beat;
      if (local >= 0.20) return null;
      return _Note(local, 0.20, (time ~/ beat).isEven ? 820 : 1100, 0.21);
  }
  return null;
}

class _Note {
  const _Note(this.localTime, this.duration, this.frequency, this.amplitude);
  final double localTime;
  final double duration;
  final double frequency;
  final double amplitude;
}

void _header(ByteData bytes, int sampleRate, int frames) {
  final length = frames * 2;
  void ascii(int offset, String value) {
    for (var i = 0; i < value.length; i++) {
      bytes.setUint8(offset + i, value.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  bytes.setUint32(4, 36 + length, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  bytes.setUint32(16, 16, Endian.little);
  bytes.setUint16(20, 1, Endian.little);
  bytes.setUint16(22, 1, Endian.little);
  bytes.setUint32(24, sampleRate, Endian.little);
  bytes.setUint32(28, sampleRate * 2, Endian.little);
  bytes.setUint16(32, 2, Endian.little);
  bytes.setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  bytes.setUint32(40, length, Endian.little);
}

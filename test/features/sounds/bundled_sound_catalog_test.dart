import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/sounds/domain/bundled_sound_catalog.dart';

void main() {
  test('every bundled family has a packaged PCM WAV with a distinct URI', () {
    expect(
      BundledSoundCatalog.sounds.map((item) => item.family).toSet(),
      hasLength(3),
    );
    expect(
      BundledSoundCatalog.sounds.map((item) => item.uri).toSet(),
      hasLength(3),
    );
    for (final sound in BundledSoundCatalog.sounds) {
      final rawName = sound.uri.split('/').last;
      final file = File('android/app/src/main/res/raw/$rawName.wav');
      expect(file.existsSync(), isTrue, reason: sound.id);
      final header = file.readAsBytesSync().take(12).toList();
      expect(String.fromCharCodes(header.take(4)), 'RIFF');
      expect(String.fromCharCodes(header.skip(8)), 'WAVE');
      expect(file.lengthSync(), greaterThan(44000));
      expect(BundledSoundCatalog.byUri(sound.uri)?.id, sound.id);
    }
  });

  test('family selection never returns the same family', () {
    for (final sound in BundledSoundCatalog.sounds) {
      expect(
        BundledSoundCatalog.differentFamily(sound.family)?.family,
        isNot(sound.family),
      );
    }
  });
}

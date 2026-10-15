class BundledSound {
  const BundledSound(this.id, this.family, this.title, this.uri);
  final String id;
  final String family;
  final String title;
  final String uri;
}

class BundledSoundCatalog {
  const BundledSoundCatalog._();

  static const sounds = <BundledSound>[
    BundledSound(
      'pulse-a',
      'PULSE',
      'Ryser Pulse',
      'android.resource://com.ryser.ryser/raw/pulse_a',
    ),
    BundledSound(
      'melodic-a',
      'MELODIC',
      'Ryser Melodic',
      'android.resource://com.ryser.ryser/raw/melodic_a',
    ),
    BundledSound(
      'urgent-a',
      'URGENT',
      'Ryser Urgent',
      'android.resource://com.ryser.ryser/raw/urgent_a',
    ),
  ];

  static BundledSound? byUri(String? uri) {
    for (final sound in sounds) {
      if (sound.uri == uri) return sound;
    }
    return null;
  }

  static BundledSound? byId(String? id) {
    for (final sound in sounds) {
      if (sound.id == id) return sound;
    }
    return null;
  }

  static BundledSound? differentFamily(String? family) {
    for (final sound in sounds) {
      if (sound.family != family) return sound;
    }
    return null;
  }
}

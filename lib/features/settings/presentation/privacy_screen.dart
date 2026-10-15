import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  static const supportEmail = String.fromEnvironment('RYSER_SUPPORT_EMAIL');
  static const privacyUrl = String.fromEnvironment('RYSER_PRIVACY_URL');
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('PRIVACY')),
    body: const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ryser stores your alarm settings, wake history, protocol versions, and mission settings on this device. No Ryser account is required.\n\n'
              'Camera access scans your registered QR target. Ryser stores a hash of the target rather than camera images or the QR text.\n\n'
              'Movement missions use motion sensors and, if permitted, foreground location as a fallback. Raw location readings are used in memory for progress and are not written to your wake history.\n\n'
              'Selected audio references stay on the device. The release app has no Internet permission and uses a bundled QR scanner. Ryser has no advertising or remote analytics service. Android and Google Play can provide system diagnostics independently of Ryser.\n\n'
              'Android cloud backup is disabled for Ryser. Uninstalling or clearing app storage removes Ryser’s local records and alarm setup. This also removes your scheduled alarms.\n\n'
              'You can revoke permissions through Android settings. Alarm Health shows permissions that affect ringing and mission availability.',
            ),
            if (supportEmail != '')
              SelectableText('Privacy contact: $supportEmail'),
            if (privacyUrl != '')
              SelectableText('Published policy: $privacyUrl'),
          ],
        ),
      ),
    ),
  );
}

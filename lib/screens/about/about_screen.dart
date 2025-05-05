import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  final _privacyPolicyUrl = 'https://sites.google.com/view/myquotes-privacypolicy';
  final _sourceCodeUrl = 'https://github.com/BaranMichal25/my_quotes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.about),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(Strings.privacy_policy),
            onTap: () {
              _openPrivacyPolicy(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text(Strings.source_code),
            onTap: () {
              _openSourceCode(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.copyright),
            title: const Text(Strings.open_source_licenses),
            onTap: () {
              _openOpenSourceLicenses(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    if (await canLaunchUrlString(_privacyPolicyUrl)) {
      await launchUrlString(_privacyPolicyUrl);
    } else {
      _showOpeningBrowserFailedToast(context);
    }
  }

  Future<void> _openSourceCode(BuildContext context) async {
    if (await canLaunchUrlString(_sourceCodeUrl)) {
      await launchUrlString(_sourceCodeUrl);
    } else {
      _showOpeningBrowserFailedToast(context);
    }
  }

  void _openOpenSourceLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: Strings.my_quotes,
      applicationVersion: '1.0.1',
    );
  }

  void _showOpeningBrowserFailedToast(BuildContext context) {
    Toast.show(
      message: Strings.could_not_open_the_browser,
      context: context,
      icon: const Icon(Icons.close, color: Colors.white),
      backgroundColor: Colors.red,
    );
  }
}

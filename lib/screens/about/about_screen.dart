import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  final _privacyPolicyUrl =
      'https://sites.google.com/view/myquotes-privacypolicy';
  final _sourceCodeUrl = 'https://github.com/BaranMichal25/my_quotes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.about),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text(Strings.privacy_policy),
            onTap: () {
              _openPrivacyPolicy(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text(Strings.source_code),
            onTap: () {
              _openSourceCode(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.copyright),
            title: Text(Strings.open_source_licenses),
            onTap: () {
              _openOpenSourceLicenses(context);
            },
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) async {
    if (await canLaunch(_privacyPolicyUrl)) {
      await launch(_privacyPolicyUrl);
    } else {
      _showOpeningBrowserFailedToast(context);
    }
  }

  void _openSourceCode(BuildContext context) async {
    if (await canLaunch(_sourceCodeUrl)) {
      await launch(_sourceCodeUrl);
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
      icon: Icon(Icons.close, color: Colors.white),
      backgroundColor: Colors.red,
    );
  }
}

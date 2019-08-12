import 'package:flutter/material.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Privacy Policy'),
            onTap: () {
              _openPrivacyPolicy(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Source code'),
            onTap: () {
              _openSourceCode(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.copyright),
            title: Text('Open source licenses'),
            onTap: () {
              _openOpenSourceLicenses(context);
            },
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) async {
    const url = 'https://sites.google.com/view/myquotes-privacypolicy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showOpeningBrowserFailedToast(context);
    }
  }

  void _openSourceCode(BuildContext context) async {
    const url = 'https://github.com/BaranMichal25/my_quotes';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showOpeningBrowserFailedToast(context);
    }
  }

  void _openOpenSourceLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'My Quotes',
      applicationVersion: '1.0.1',
    );
  }

  void _showOpeningBrowserFailedToast(BuildContext context) {
    Toast.show(
      message: 'Could not open the browser',
      context: context,
      icon: Icon(Icons.close, color: Colors.white),
      backgroundColor: Colors.red,
    );
  }
}

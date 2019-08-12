import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/model/quote.dart';

class ShareOrCopyQuoteDialog extends StatelessWidget {
  final Quote quote;

  const ShareOrCopyQuoteDialog({this.quote});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        PresentationFormatter.formatQuoteForSharing(quote),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context, ShareOrCopyQuoteDialogResult.share);
          },
          icon: Icon(Icons.share),
          label: Text(
            Strings.share,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          textColor: Colors.black,
          padding: const EdgeInsets.all(Dimens.halfDefaultSpacing),
        ),
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context, ShareOrCopyQuoteDialogResult.copy);
          },
          icon: Icon(Icons.content_copy),
          label: Text(
            Strings.copy,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          textColor: Colors.black,
          padding: const EdgeInsets.all(Dimens.halfDefaultSpacing),
        ),
      ],
    );
  }
}

enum ShareOrCopyQuoteDialogResult {
  share,
  copy,
}

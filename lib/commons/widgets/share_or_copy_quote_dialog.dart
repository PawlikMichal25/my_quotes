import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/model/quote.dart';

class ShareOrCopyQuoteDialog extends StatelessWidget {
  final Quote quote;

  const ShareOrCopyQuoteDialog({required this.quote});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        PresentationFormatter.formatQuoteForSharing(quote),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      children: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context, ShareOrCopyQuoteDialogResult.share);
          },
          icon: const Icon(Icons.share, color: Colors.black),
          label: const Text(
            Strings.share,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context, ShareOrCopyQuoteDialogResult.copy);
          },
          icon: const Icon(Icons.content_copy),
          label: const Text(
            Strings.copy,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(Dimens.halfDefaultSpacing),
          ),
        ),
      ],
    );
  }
}

enum ShareOrCopyQuoteDialogResult {
  share,
  copy,
}

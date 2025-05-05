import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/my_quotes_icons.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/resources/styles.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/commons/widgets/share_or_copy_quote_dialog.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:my_quotes/screens/edit_quote/edit_quote_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:my_quotes/tabs/quotes/quotes_tab_bloc.dart';

class QuotesTab extends StatelessWidget {
  final VoidCallback onDataChanged;

  const QuotesTab({required this.onDataChanged});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuotesTabBloc>(context);
    return StreamBuilder<Resource<List<Quote>>>(
      initialData: Resource.loading(),
      stream: bloc.quotesStream,
      builder: (_, AsyncSnapshot<Resource<List<Quote>>> snapshot) {
        final resource = snapshot.data;

        switch (resource?.status) {
          case Status.LOADING:
            return _buildProgressIndicator();
          case Status.SUCCESS:
            return _buildSuccessBody(resource!.data!);
          case Status.ERROR:
            return Text(resource!.message!);
          case null:
            return const Text(Strings.unknown_error);
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessBody(List<Quote> quotes) {
    if (quotes.isEmpty) {
      return _buildEmptyView();
    } else {
      return _buildQuotesList(quotes);
    }
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MyQuotesIcons.quotes,
            size: 120,
            color: Styles.lightGrey,
          ),
          const SizedBox(height: Dimens.halfDefaultSpacing),
          Text(
            Strings.no_quotes,
            style: TextStyle(
              color: Styles.lightGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesList(List<Quote> quotes) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (BuildContext context, int index) {
          final quote = quotes[index];

          return _buildQuoteTile(context, quote);
        },
      ),
    );
  }

  Widget _buildQuoteTile(BuildContext context, Quote quote) {
    return Card(
      elevation: Dimens.oneThirdDefaultSpacing,
      margin: const EdgeInsets.all(Dimens.halfDefaultSpacing),
      child: Material(
        child: InkWell(
          onTap: () {
            _onCardClicked(context, quote);
          },
          onLongPress: () {
            _onCardLongPressed(context, quote);
          },
          child: Padding(
            padding: const EdgeInsets.all(Dimens.defaultSpacing),
            child: Column(
              children: [
                Text(
                  quote.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: Dimens.halfDefaultSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(PresentationFormatter.formatAuthor(quote.author)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCardClicked(BuildContext context, Quote quote) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EditQuoteScreen(quote: quote),
      ),
    );
    onDataChanged();
  }

  Future<void> _onCardLongPressed(BuildContext context, Quote quote) async {
    final formattedQuote = PresentationFormatter.formatQuoteForSharing(quote);
    final result = await showDialog<ShareOrCopyQuoteDialogResult>(
      context: context,
      builder: (context) {
        return ShareOrCopyQuoteDialog(quote: quote);
      },
    );

    switch (result) {
      case ShareOrCopyQuoteDialogResult.share:
        await SharePlus.instance.share(ShareParams(text: formattedQuote));
      case ShareOrCopyQuoteDialogResult.copy:
        await Clipboard.setData(ClipboardData(text: formattedQuote));
        Toast.show(
          message: Strings.quote_copied_to_clipboard,
          context: context,
          icon: const Icon(Icons.done, color: Colors.white),
          backgroundColor: Colors.green,
        );
      case null:
      // do nothing
    }
  }
}

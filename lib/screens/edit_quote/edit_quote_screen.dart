import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/model/quote.dart';
import 'package:my_quotes/screens/edit_author/edit_author_result.dart';
import 'package:my_quotes/screens/edit_author/edit_author_screen.dart';

import 'package:my_quotes/screens/edit_quote/edit_quote_bloc.dart';

class EditQuoteScreen extends StatefulWidget {
  final Quote quote;

  const EditQuoteScreen({required this.quote});

  @override
  State<EditQuoteScreen> createState() => _EditQuoteScreenState();
}

class _EditQuoteScreenState extends State<EditQuoteScreen> {
  late EditQuoteBloc _editQuoteBloc;
  late Author _author;

  bool _quoteValid = true;
  bool _isProcessing = false;
  final _authorController = TextEditingController();
  final _quoteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _author = widget.quote.author;

    _authorController.text = PresentationFormatter.formatAuthor(_author);

    _quoteController.text = widget.quote.content;
    _quoteController.addListener(_onQuoteFormChanged);

    _editQuoteBloc = sl.get<EditQuoteBloc>();
  }

  @override
  void dispose() {
    _authorController.dispose();
    _quoteController.dispose();
    _editQuoteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.edit_quote),
        actions: [_buildDeleteAction()],
      ),
      body: Column(
        children: [
          _buildAuthorRow(),
          _buildQuoteForm(),
          const SizedBox(height: Dimens.tripleDefaultSpacing),
          _buildSaveButton(),
        ],
      ),
    );
  }

  void _onQuoteFormChanged() {
    final text = _quoteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _quoteValid = true;
      });
    }
  }

  Widget _buildDeleteAction() {
    if (_isProcessing) {
      return const CircularProgressIndicator();
    } else {
      return IconButton(
        icon: const Icon(Icons.delete),
        onPressed: _deleteQuote,
      );
    }
  }

  Widget _buildAuthorRow() {
    return Row(
      children: [
        Expanded(child: _buildAuthorForm()),
        _buildEditAuthorButton(),
      ],
    );
  }

  Widget _buildAuthorForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultSpacing),
      child: TextFormField(
        controller: _authorController,
        readOnly: true,
        maxLines: 2,
        minLines: 1,
        decoration: const InputDecoration(
          labelText: Strings.author,
        ),
      ),
    );
  }

  Widget _buildEditAuthorButton() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultSpacing),
      child: ElevatedButton(
        onPressed: _onEditAuthorClick,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.buttonRadius),
          ),
        ),
        child: const Text(Strings.edit_author),
      ),
    );
  }

  Future<void> _onEditAuthorClick() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<EditAuthorResult>(
        builder: (context) => EditAuthorScreen(author: _author, deletingEnabled: false),
      ),
    );

    if (result is AuthorChanged) {
      final newAuthor = result.author;
      setState(() {
        _author = newAuthor;
      });
      _authorController.text = PresentationFormatter.formatAuthor(newAuthor);
    }
  }

  Widget _buildQuoteForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultSpacing),
      child: TextFormField(
        maxLines: 8,
        minLines: 1,
        controller: _quoteController,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: Strings.quote,
          errorText: _quoteValid ? null : Strings.quote_cant_be_empty,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return _isProcessing
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _onSaveButtonClicked,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.buttonActionPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.buttonRadius),
              ),
            ),
            child: const Text(Strings.save),
          );
  }

  void _onSaveButtonClicked() {
    final text = _quoteController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _quoteValid = false;
      });
    }

    if (text.isNotEmpty) {
      setState(() {
        _quoteValid = true;
        _isProcessing = true;
      });
      _editQuote(text);
    }
  }

  Future<void> _editQuote(String newContent) async {
    if (_didQuoteChange(newContent)) {
      Navigator.pop(context);
    } else {
      await _editQuoteBloc.editQuote(widget.quote, newContent);
      _showSuccessToast(Strings.quote_edited);
      Navigator.pop(context);
    }
  }

  bool _didQuoteChange(String newContent) {
    return widget.quote.content == newContent;
  }

  Future<void> _deleteQuote() async {
    setState(() {
      _isProcessing = true;
    });
    await _editQuoteBloc.deleteQuote(widget.quote);
    _showSuccessToast(Strings.quote_deleted);
    Navigator.pop(context);
  }

  void _showSuccessToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: const Icon(Icons.done, color: Colors.white),
      backgroundColor: Colors.green,
    );
  }
}

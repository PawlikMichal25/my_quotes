import 'package:flutter/material.dart';
import 'package:my_quotes/commons/architecture/resource.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/utils/presentation_formatter.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/screens/add_author/add_author_screen.dart';

import 'add_quote_bloc.dart';

class AddQuoteScreen extends StatefulWidget {
  @override
  _AddQuoteScreenState createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  AddQuoteBloc _addQuoteBloc;
  Author _author;

  bool _authorValid = true;
  bool _quoteValid = true;
  bool _isAddingQuote = false;
  TextEditingController _quoteController;

  @override
  void initState() {
    super.initState();

    _quoteController = TextEditingController();
    _quoteController.addListener(_onQuoteFormChanged);

    _addQuoteBloc = sl.get<AddQuoteBloc>();
    _addQuoteBloc.loadAuthors();
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _addQuoteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.add_quote),
        ),
        body: StreamBuilder<Resource<List<Author>>>(
            initialData: Resource.loading(),
            stream: _addQuoteBloc.authorsStream,
            builder: (_, AsyncSnapshot<Resource<List<Author>>> snapshot) {
              final resource = snapshot.data;

              switch (resource.status) {
                case Status.LOADING:
                  return _buildProgressIndicator();
                case Status.SUCCESS:
                  return Column(
                    children: [
                      _buildAuthorRow(resource.data),
                      _buildQuoteForm(),
                      SizedBox(height: Dimens.tripleDefaultSpacing),
                      _buildSaveButton(),
                    ],
                  );
                case Status.ERROR:
                  return Text(resource.message);
              }
              return Text(Strings.unknown_error);
            }));
  }

  void _onQuoteFormChanged() {
    final text = _quoteController.text;
    if (text.isNotEmpty) {
      setState(() {
        _quoteValid = true;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildAuthorRow(List<Author> authors) {
    return Row(
      children: [
        Expanded(child: _buildAuthorFormField(authors)),
        _buildAddAuthorButton(),
      ],
    );
  }

  Widget _buildAuthorFormField(List<Author> authors) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultSpacing),
      child: FormField<Author>(
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: Strings.author,
              errorText: _authorValid ? null : Strings.you_must_select_an_author,
            ),
            isEmpty: _author == null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: _author,
                isDense: true,
                onChanged: (Author newValue) {
                  setState(() {
                    _author = newValue;
                    _authorValid = true;
                    state.didChange(newValue);
                  });
                },
                items: authors.map((Author author) {
                  return DropdownMenuItem(
                    value: author,
                    child: Text(
                      PresentationFormatter.formatAuthor(author),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddAuthorButton() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.defaultSpacing),
      child: RaisedButton(
        child: Text(Strings.add_new),
        onPressed: _onAddNewAuthorClick,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.buttonRadius),
        ),
      ),
    );
  }

  void _onAddNewAuthorClick() async {
    final author = await Navigator.push<Author>(
      context,
      MaterialPageRoute(builder: (context) => AddAuthorScreen()),
    );

    await _addQuoteBloc.loadAuthors();

    setState(() {
      _author = author;
      _authorValid = true;
    });
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
    return _isAddingQuote
        ? CircularProgressIndicator()
        : RaisedButton(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.buttonActionPadding),
            child: Text(Strings.save),
            onPressed: () => _onSaveButtonClicked(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.buttonRadius),
            ),
          );
  }

  void _onSaveButtonClicked() {
    final content = _quoteController.text.trim();

    if (_author == null) {
      setState(() {
        _authorValid = false;
      });
    }

    if (content.isEmpty) {
      setState(() {
        _quoteValid = false;
      });
    }

    if (_author != null && content.isNotEmpty) {
      setState(() {
        _authorValid = true;
        _quoteValid = true;
        _isAddingQuote = true;
      });
      _addQuote(content);
    }
  }

  void _addQuote(String content) async {
    final quote = await _addQuoteBloc.addQuote(
      content: content,
      author: _author,
    );

    _showSuccessToast(Strings.quote_created);
    Navigator.pop(context, quote);
  }

  void _showSuccessToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(Icons.done, color: Colors.white),
      backgroundColor: Colors.green,
    );
  }
}

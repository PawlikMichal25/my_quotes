import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/screens/edit_author/edit_author_result.dart';

import 'edit_author_bloc.dart';

class EditAuthorScreen extends StatefulWidget {
  final Author author;

  EditAuthorScreen({this.author});

  @override
  _EditAuthorScreenState createState() => _EditAuthorScreenState();
}

class _EditAuthorScreenState extends State<EditAuthorScreen> {
  EditAuthorBloc _editAuthorBloc;

  bool _firstNameValid = true;
  bool _isProcessing = false;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();

    _editAuthorBloc = sl.get<EditAuthorBloc>();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    _firstNameController.text = widget.author.firstName;
    _lastNameController.text = widget.author.lastName;

    _firstNameController.addListener(_onFirstNameFormChanged);
  }

  @override
  void dispose() {
    _editAuthorBloc.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit author'),
        actions: [
          _isProcessing
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteAuthor,
                )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.defaultSpacing),
            child: TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                errorText:
                    _firstNameValid ? null : 'First name can\'t be empty',
                labelText: 'First name',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.defaultSpacing),
            child: TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last name',
              ),
            ),
          ),
          SizedBox(height: Dimens.tripleDefaultSpacing),
          _isProcessing
              ? CircularProgressIndicator()
              : RaisedButton(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.buttonActionPadding),
                  child: Text('Save'),
                  onPressed: () => _onSaveButtonClicked(),
                ),
        ],
      ),
    );
  }

  void _onFirstNameFormChanged() {
    final text = _firstNameController.text;
    if (text.isNotEmpty) {
      setState(() {
        _firstNameValid = true;
      });
    }
  }

  void _onSaveButtonClicked() {
    final text = _firstNameController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _firstNameValid = false;
      });
    } else {
      setState(() {
        _firstNameValid = true;
        _isProcessing = true;
      });
      _editAuthor();
    }
  }

  void _editAuthor() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;

    if (_didAuthorChange(firstName, lastName)) {
      Navigator.pop(context);
    } else {
      final either = await _editAuthorBloc.editAuthor(
        authorId: widget.author.id,
        firstName: firstName,
        lastName: lastName,
      );

      if (either.isRight()) {
        _showSuccessToast('Author edited');
        Navigator.pop(context, EditAuthorResult.authorChanged(either.right));
      } else {
        setState(() {
          _isProcessing = false;
        });
        _showFailureToast(either.left);
      }
    }
  }

  void _deleteAuthor() async {
    setState(() {
      _isProcessing = true;
    });
    await _editAuthorBloc.deleteAuthor(authorId: widget.author.id);
    _showSuccessToast('Author deleted');
    Navigator.pop(context, EditAuthorResult.authorDeleted());
  }

  bool _didAuthorChange(String firstName, String lastName) {
    return widget.author.firstName == firstName &&
        widget.author.lastName == lastName;
  }

  void _showSuccessToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(Icons.done, color: Colors.white),
      backgroundColor: Colors.green,
    );
  }

  void _showFailureToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: Icon(Icons.close, color: Colors.white),
      backgroundColor: Colors.red,
    );
  }
}

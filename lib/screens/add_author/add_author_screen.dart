import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/injection/service_location.dart';

import 'add_author_bloc.dart';

class AddAuthorScreen extends StatefulWidget {
  @override
  _AddAuthorScreenState createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AddAuthorBloc _addAuthorBloc;

  bool _firstNameValid = true;
  bool _isAddingAuthor = false;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();

    _addAuthorBloc = sl.get<AddAuthorBloc>();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameController.addListener(_onFirstNameFormChanged);
  }

  @override
  void dispose() {
    _addAuthorBloc.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add author'),
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
          _isAddingAuthor
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
    final text = _firstNameController.text;
    if (text.isEmpty) {
      setState(() {
        _firstNameValid = false;
      });
    } else {
      setState(() {
        _firstNameValid = true;
        _isAddingAuthor = true;
      });
      _addAuthor();
    }
  }

  void _addAuthor() async {
    final either = await _addAuthorBloc.addAuthor(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );

    if (either.isRight()) {
      Navigator.pop(context, either.right);
    } else {
      setState(() {
        _isAddingAuthor = false;
      });
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(either.left)),
      );
    }
  }
}

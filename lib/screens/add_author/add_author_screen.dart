import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/injection/service_location.dart';

import 'package:my_quotes/screens/add_author/add_author_bloc.dart';

class AddAuthorScreen extends StatefulWidget {
  @override
  State<AddAuthorScreen> createState() => _AddAuthorScreenState();
}

class _AddAuthorScreenState extends State<AddAuthorScreen> {
  late AddAuthorBloc _addAuthorBloc;

  bool _firstNameValid = true;
  bool _isAddingAuthor = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

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
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.add_author),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.defaultSpacing),
            child: TextFormField(
              controller: _firstNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                errorText: _firstNameValid ? null : Strings.first_name_cant_be_empty,
                labelText: Strings.first_name,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.defaultSpacing),
            child: TextFormField(
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: Strings.last_name,
              ),
            ),
          ),
          const SizedBox(height: Dimens.tripleDefaultSpacing),
          _isAddingAuthor
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.buttonActionPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.buttonRadius),
                    ),
                  ),
                  onPressed: _onSaveButtonClicked,
                  child: const Text(Strings.save),
                ),
        ],
      ),
    );
  }

  void _onFirstNameFormChanged() {
    final text = _firstNameController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _firstNameValid = true;
      });
    }
  }

  void _onSaveButtonClicked() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (firstName.isEmpty) {
      setState(() {
        _firstNameValid = false;
      });
    } else {
      setState(() {
        _firstNameValid = true;
        _isAddingAuthor = true;
      });
      _addAuthor(firstName, lastName);
    }
  }

  Future<void> _addAuthor(String firstName, String lastName) async {
    final either = await _addAuthorBloc.addAuthor(
      firstName: firstName,
      lastName: lastName,
    );

    if (either.isRight()) {
      _showSuccessToast(Strings.author_created);
      Navigator.pop(context, either.right);
    } else {
      setState(() {
        _isAddingAuthor = false;
      });
      _showFailureToast(either.left!);
    }
  }

  void _showSuccessToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: const Icon(Icons.done, color: Colors.white),
      backgroundColor: Colors.green,
    );
  }

  void _showFailureToast(String message) {
    Toast.show(
      message: message,
      context: context,
      icon: const Icon(Icons.close, color: Colors.white),
      backgroundColor: Colors.red,
    );
  }
}

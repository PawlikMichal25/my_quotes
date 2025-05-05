import 'package:flutter/material.dart';
import 'package:my_quotes/commons/resources/dimens.dart';
import 'package:my_quotes/commons/resources/strings.dart';
import 'package:my_quotes/commons/widgets/toast.dart';
import 'package:my_quotes/injection/service_location.dart';
import 'package:my_quotes/model/author.dart';
import 'package:my_quotes/screens/edit_author/edit_author_result.dart';

import 'package:my_quotes/screens/edit_author/edit_author_bloc.dart';

class EditAuthorScreen extends StatefulWidget {
  final Author author;
  final bool deletingEnabled;

  const EditAuthorScreen({required this.author, required this.deletingEnabled});

  @override
  State<EditAuthorScreen> createState() => _EditAuthorScreenState();
}

class _EditAuthorScreenState extends State<EditAuthorScreen> {
  late EditAuthorBloc _editAuthorBloc;

  bool _firstNameValid = true;
  bool _isProcessing = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _editAuthorBloc = sl.get<EditAuthorBloc>();

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
        title: const Text(Strings.edit_author),
        actions: _buildActions(),
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
          _isProcessing
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _onSaveButtonClicked(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: Dimens.buttonActionPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.buttonRadius),
                    ),
                  ),
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

  List<Widget> _buildActions() {
    final delete = _buildDeleteAction();
    if (delete == null) {
      return [];
    } else {
      return [delete];
    }
  }

  Widget? _buildDeleteAction() {
    if (widget.deletingEnabled) {
      if (_isProcessing) {
        return const CircularProgressIndicator();
      } else {
        return IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteAuthor,
        );
      }
    }

    return null;
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
        _isProcessing = true;
      });
      _editAuthor(firstName, lastName);
    }
  }

  Future<void> _editAuthor(String firstName, String lastName) async {
    if (_didAuthorChange(firstName, lastName)) {
      Navigator.pop(context);
    } else {
      final updatedAuthor = await _editAuthorBloc.editAuthor(
        authorKey: widget.author.key,
        firstName: firstName,
        lastName: lastName,
      );

      _showSuccessToast(Strings.author_edited);
      Navigator.pop(context, EditAuthorResult.authorChanged(updatedAuthor));
    }
  }

  Future<void> _deleteAuthor() async {
    setState(() {
      _isProcessing = true;
    });
    await _editAuthorBloc.deleteAuthor(widget.author.key);
    _showSuccessToast(Strings.author_deleted);
    Navigator.pop(context, EditAuthorResult.authorDeleted());
  }

  bool _didAuthorChange(String firstName, String lastName) {
    return widget.author.firstName == firstName && widget.author.lastName == lastName;
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

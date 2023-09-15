import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/shopping_bloc.dart';

class AddListPage extends StatefulWidget {
  const AddListPage({super.key});

  static const nameInputKey = Key('AddListPage_Name_Input');
  static const submitButtonKey = Key('AddListPage_Submit_Input');

  static Route route() {
    return MaterialPageRoute<ListCreated>(builder: (_) => const AddListPage());
  }

  @override
  State<AddListPage> createState() => _AddListPageState();
}

class _AddListPageState extends State<AddListPage> {
  final _nameTextController = TextEditingController();

  bool? _isNameValid;

  @override
  void initState() {
    super.initState();

    _nameTextController.addListener(() {
      if ((_isNameValid ?? false) != _nameTextController.text.isNotEmpty) {
        setState(() {
          _isNameValid = _nameTextController.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(l10n.newItem(l10n.list.toLowerCase())),
      ),
      body: SafeArea(
        child: Padding(
          padding: Dims.largeEdgeInsets,
          child: Column(
            children: [
              TextField(
                controller: _nameTextController,
                key: AddListPage.nameInputKey,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.name,
                    errorText:
                        _isNameValid == false ? l10n.fieldRequired : null),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  key: AddListPage.submitButtonKey,
                  onPressed: _isNameValid == true
                      ? () {
                          Navigator.of(context).pop(ListCreated(
                              name: _nameTextController.text, sortOrder: 0));
                        }
                      : null,
                  child: Text(l10n.createItem(l10n.list.toLowerCase())),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

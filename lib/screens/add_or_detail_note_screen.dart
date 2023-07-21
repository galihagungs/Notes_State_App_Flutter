import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesstatemanagemen/provider/notes.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class AddOrDetailScreen extends StatefulWidget {
  static const routeName = '/addOrDetailScreen';
  @override
  State<AddOrDetailScreen> createState() => _AddOrDetailScreenState();
}

class _AddOrDetailScreenState extends State<AddOrDetailScreen> {
  Note _note = Note(
    id: '',
    title: '',
    note: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    isPinned: false,
  );

  bool _init = true;
  bool _isLoading = false;

  final _formkey = GlobalKey<FormState>();

  Future<void> addNote() async {
    _formkey.currentState?.save();
    // print('title: ' + _note.title);
    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();
      _note = _note.copyWith(createdAt: now, updatedAt: now);
      final notesProvider = Provider.of<Notes>(context, listen: false);
      // print(_note.id);
      if (_note.id == '') {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Tutup'),
              )
            ],
          );
        },
      );
    }

    Navigator.of(context).pop();
  }

  String _convertDate(DateTime dateTime) {
    int diff = DateTime.now().difference(dateTime).inDays;

    if (diff > 0) return DateFormat('dd-MM-yyyy').format(dateTime);

    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      // print(ModalRoute.of(context)!.settings.arguments);
      var ide = ModalRoute.of(context)!.settings.arguments.toString();

      if (ide != 'null') {
        // print('If Berjalan');
        _note = Provider.of<Notes>(context).getNote(ide);
        _init = false;
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: addNote,
            child: _isLoading ? CircularProgressIndicator() : Text('Simpan'),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _note.title,
                      decoration: InputDecoration(
                        hintText: 'Judul',
                        border: InputBorder.none,
                      ),
                      onSaved: (newValue) {
                        _note = _note.copyWith(title: newValue);
                      },
                    ),
                    TextFormField(
                      initialValue: _note.note,
                      decoration: InputDecoration(
                        hintText: 'Tulis Catatan Disini',
                        border: InputBorder.none,
                      ),
                      onSaved: (newValue) {
                        _note = _note.copyWith(note: newValue);
                      },
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: _note.updatedAt != null
                ? Text(
                    'Terakhir diubah ${_convertDate(_note.updatedAt as DateTime)}')
                : const Text(''),
          ),
        ],
      ),
    );
  }
}

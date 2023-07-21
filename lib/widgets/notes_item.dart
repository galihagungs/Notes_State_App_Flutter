import 'package:flutter/material.dart';
import 'package:notesstatemanagemen/icon/my_flutter_app_icons.dart';
import 'package:notesstatemanagemen/models/note.dart';
import 'package:notesstatemanagemen/provider/notes.dart';
import 'package:notesstatemanagemen/screens/add_or_detail_note_screen.dart';
import 'package:provider/provider.dart';

class NoteItem extends StatefulWidget {
  final String id;
  final BuildContext ctx;

  NoteItem({
    required this.id,
    required this.ctx,
  });
  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<Notes>(context, listen: false);
    Note note = notesProvider.getNote(widget.id);
    // print(note.updatedAt);
    return Dismissible(
      key: Key(note.id),
      onDismissed: (direction) {
        notesProvider.deleteNote(note.id).catchError((onError) {
          print('Terjadi Error');
          ScaffoldMessenger.of(widget.ctx).clearSnackBars();
          ScaffoldMessenger.of(widget.ctx).showSnackBar(
            SnackBar(
              content: Text(
                onError.toString(),
              ),
            ),
          );
        });
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(AddOrDetailScreen.routeName, arguments: note.id),
        child: GridTile(
          header: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  // widget.toggleIsPinned(widget.id);
                  notesProvider.toggleIsPinned(note.id).catchError((onError) {
                    ScaffoldMessenger.of(widget.ctx).clearSnackBars();
                    ScaffoldMessenger.of(widget.ctx).showSnackBar(
                      SnackBar(
                        content: Text(
                          onError.toString(),
                        ),
                      ),
                    );
                  });
                },
                icon: Icon(note.isPinned
                    ? MyFlutterApp.pin
                    : MyFlutterApp.pin_outline),
              )),
          footer: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: GridTileBar(
              backgroundColor: Colors.black87,
              title: Text(note.title),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[800],
            ),
            padding: const EdgeInsets.all(12),
            child: Text(note.note),
          ),
        ),
      ),
    );
  }
}

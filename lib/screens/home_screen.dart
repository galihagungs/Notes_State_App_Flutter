import 'package:flutter/material.dart';
import 'package:notesstatemanagemen/provider/notes.dart';
import 'package:notesstatemanagemen/screens/add_or_detail_note_screen.dart';
import 'package:notesstatemanagemen/widgets/notes_grid.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: FutureBuilder(
        future: Provider.of<Notes>(context, listen: false).getAndSetNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return NotesGrid();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddOrDetailScreen.routeName,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

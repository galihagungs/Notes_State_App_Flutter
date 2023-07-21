import 'package:notesstatemanagemen/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const TABLE_NOTES = 'notes';
  static const TABLE_NOTES_ID = 'id';
  static const TABLE_NOTES_NOTE = 'note';
  static const TABLE_NOTES_TITLE = 'title';
  static const TABLE_NOTES_ISPINNED = 'isPinned';
  static const TABLE_NOTES_UPDATEDAT = 'updated_at';
  static const TABLE_NOTES_CREATEDAT = 'created_at';

  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'notes.db'), version: 1,
        onCreate: (newDB, version) {
      newDB.execute(
        'CREATE TABLE notes (id TEXT PRIMARY KEY, title TEXT, note TEXT, isPinned INTEGER, updated_at TEXT, created_at TEXT)',
      );
    });
  }

  Future<List<Note>> getAllNote() async {
    final db = await DatabaseHelper.init();
    final results = await db.query('notes');

    List<Note> listNote = [];

    results.forEach((data) {
      listNote.add(Note.fromdb(data));
    });

    return listNote;
  }

  Future<void> insertAllNote(List<Note> listNote) async {
    final db = await DatabaseHelper.init();
    Batch batch = db.batch();

    listNote.forEach((note) {
      batch.insert('notes', note.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });

    await batch.commit();
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.update(
      TABLE_NOTES,
      note.toDb(),
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> toggleIsPinned(
      String id, bool isPinned, DateTime updatedAt) async {
    final db = await DatabaseHelper.init();
    await db.update(
      TABLE_NOTES,
      {
        TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
        TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String(),
      },
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletNote(String id) async {
    final db = await DatabaseHelper.init();
    await db.delete(
      TABLE_NOTES,
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertNotte(Note note) async {
    final db = await DatabaseHelper.init();
    await db.insert(
      TABLE_NOTES,
      note.toDb(),
    );
  }
}

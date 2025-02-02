import 'package:notevault/models/Mood.dart';
import 'package:notevault/models/TodoItem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL,
      mood TEXT NOT NULL,
      timestamp TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content TEXT NOT NULL,
      completed INTEGER NOT NULL DEFAULT 0
    )
  ''');
    await db.execute('''
    CREATE TABLE moods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mood TEXT NOT NULL,
      date TEXT NOT NULL
    )
  ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> fetchNotes() async {
    final db = await instance.database;
    final maps = await db.query('notes');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> deleteNoteById(int? id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertTodo(Todoitem todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  Future<int> updateTodo(Todoitem todo) async {
    final db = await instance.database;

    final updatedTodo = {
      'completed': todo.completed ? 1 : 0,
    };

    return await db.update(
      'todos',
      updatedTodo,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<List<Todoitem>> fetchTodos() async {
    final db = await instance.database;
    final maps = await db.query('todos');
    return maps.map((map) => Todoitem.fromMap(map)).toList();
  }

  Future<int> deleteTodoById(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertMood(Mood mood) async {
    final db = await database;
    await db.insert(
      'moods',
      {'mood': mood.mood, 'date': mood.date.toIso8601String()},
    );
  }

  Future<Map<String, int>> fetchMoodCounts() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT mood, COUNT(*) as count 
      FROM moods 
      GROUP BY mood
    ''');
    return {for (var row in result) row['mood'] as String: row['count'] as int};
  }

  Future<List<Mood>> fetchMood() async {
    final db = await instance.database;
    final maps = await db.query('moods');
    return maps.map((map) => Mood.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    final updatedNote = {
      'content': note.content,
      'mood': note.mood,
      'timestamp': note.timestamp.toIso8601String(),
    };

    return await db.update(
      'notes',
      updatedNote,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}

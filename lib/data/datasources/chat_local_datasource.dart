import 'package:path/path.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatMessageEntity>> getMessages(String sessionId);
  Future<void> saveMessage(ChatMessageEntity message);
  Future<void> clearHistory([String? sessionId]);
  Future<List<String>> getAllSessions();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Database? _database;

  ChatLocalDataSourceImpl([this._database]);

  Database? _db;

  Future<Database> get database async {
    if (_database != null) return _database;
    final currentDb = _db;
    if (currentDb != null) return currentDb;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'roll_and_reserve_chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chat_messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL,
            role TEXT NOT NULL,
            content TEXT NOT NULL,
            mode TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String sessionId) async {
    final db = await database;
    final results = await db.query(
      'chat_messages',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'created_at ASC',
    );
    return results.map((m) => ChatMessageEntity.fromMap(m)).toList();
  }

  @override
  Future<void> saveMessage(ChatMessageEntity message) async {
    final db = await database;
    await db.insert(
      'chat_messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearHistory([String? sessionId]) async {
    final db = await database;
    if (sessionId != null) {
      await db.delete(
        'chat_messages',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );
    } else {
      await db.delete('chat_messages');
    }
  }

  @override
  Future<List<String>> getAllSessions() async {
    final db = await database;
    final results = await db.rawQuery(
      'SELECT DISTINCT session_id FROM chat_messages ORDER BY created_at DESC',
    );
    return results.map((m) => m['session_id'] as String).toList();
  }
}

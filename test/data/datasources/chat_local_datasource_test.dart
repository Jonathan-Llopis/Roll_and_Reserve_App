import 'package:flutter_test/flutter_test.dart';
import 'package:roll_and_reserve/data/datasources/chat_local_datasource.dart';
import 'package:roll_and_reserve/domain/entities/chat_message_entity.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late Database db;
  late ChatLocalDataSourceImpl dataSource;

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
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
      ),
    );
    dataSource = ChatLocalDataSourceImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ChatLocalDataSourceImpl', () {
    const msg1 = ChatMessageEntity(
      sessionId: 'session_1',
      role: 'user',
      content: '¿Cuál es la regla básica de Catan?',
      mode: 'assistant',
      createdAt: 1000,
    );

    const msg2 = ChatMessageEntity(
      sessionId: 'session_1',
      role: 'assistant',
      content: 'En Catan, el objetivo es conseguir 10 puntos de victoria.',
      mode: 'assistant',
      createdAt: 2000,
    );

    const msgOther = ChatMessageEntity(
      sessionId: 'session_2',
      role: 'user',
      content: 'Hola Gemini',
      mode: 'gemini',
      createdAt: 3000,
    );

    test('should save messages and retrieve them in chronological order by sessionId', () async {
      await dataSource.saveMessage(msg2);
      await dataSource.saveMessage(msg1);

      final result = await dataSource.getMessages('session_1');

      expect(result.length, 2);
      expect(result[0].content, msg1.content);
      expect(result[0].role, 'user');
      expect(result[1].content, msg2.content);
      expect(result[1].role, 'assistant');
    });

    test('should filter messages strictly by sessionId', () async {
      await dataSource.saveMessage(msg1);
      await dataSource.saveMessage(msgOther);

      final session1Messages = await dataSource.getMessages('session_1');
      final session2Messages = await dataSource.getMessages('session_2');

      expect(session1Messages.length, 1);
      expect(session1Messages.first.content, msg1.content);

      expect(session2Messages.length, 1);
      expect(session2Messages.first.content, msgOther.content);
    });

    test('should clear history for a specific sessionId', () async {
      await dataSource.saveMessage(msg1);
      await dataSource.saveMessage(msgOther);

      await dataSource.clearHistory('session_1');

      final session1Messages = await dataSource.getMessages('session_1');
      final session2Messages = await dataSource.getMessages('session_2');

      expect(session1Messages, isEmpty);
      expect(session2Messages.length, 1);
    });

    test('should clear all history when sessionId is null', () async {
      await dataSource.saveMessage(msg1);
      await dataSource.saveMessage(msgOther);

      await dataSource.clearHistory();

      final session1Messages = await dataSource.getMessages('session_1');
      final session2Messages = await dataSource.getMessages('session_2');

      expect(session1Messages, isEmpty);
      expect(session2Messages, isEmpty);
    });

    test('should get distinct session ids ordered by creation', () async {
      await dataSource.saveMessage(msg1);
      await dataSource.saveMessage(msgOther);

      final sessions = await dataSource.getAllSessions();

      expect(sessions, containsAll(['session_1', 'session_2']));
    });
  });
}

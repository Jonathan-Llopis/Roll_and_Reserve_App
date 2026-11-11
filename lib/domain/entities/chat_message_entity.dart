import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final int? id;
  final String sessionId;
  final String role; // 'user' or 'assistant'
  final String content;
  final String mode; // 'deepseek', 'gemini', 'roleplay', 'assistant'
  final int createdAt;

  const ChatMessageEntity({
    this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.mode,
    required this.createdAt,
  });

  ChatMessageEntity copyWith({
    int? id,
    String? sessionId,
    String? role,
    String? content,
    String? mode,
    int? createdAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      mode: mode ?? this.mode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'session_id': sessionId,
      'role': role,
      'content': content,
      'mode': mode,
      'created_at': createdAt,
    };
  }

  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) {
    return ChatMessageEntity(
      id: map['id'] as int?,
      sessionId: map['session_id'] as String,
      role: map['role'] as String,
      content: map['content'] as String,
      mode: map['mode'] as String,
      createdAt: map['created_at'] as int,
    );
  }

  @override
  List<Object?> get props => [id, sessionId, role, content, mode, createdAt];
}

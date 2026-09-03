import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

enum AiChatStatus { loading, ready, aiTyping }

class AiChatState extends Equatable {
  final AiChatStatus status;
  final List<ChatMessageEntity> messages;

  const AiChatState({
    this.status = AiChatStatus.loading,
    this.messages = const [],
  });

  AiChatState copyWith({
    AiChatStatus? status,
    List<ChatMessageEntity>? messages,
  }) {
    return AiChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [status, messages];
}
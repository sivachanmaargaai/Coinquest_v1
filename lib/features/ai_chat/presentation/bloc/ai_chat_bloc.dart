import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'ai_chat_event.dart';
import 'ai_chat_state.dart';

/// Chat conversation with the "Money Buddy AI" assistant.
/// TODO: replace the canned reply logic in _generateReply with a real
/// SendChatMessageUseCase that calls an LLM-backed API.
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  AiChatBloc() : super(const AiChatState()) {
    on<AiChatStarted>(_onStarted);
    on<AiChatMessageSent>(_onMessageSent);
  }

  Future<void> _onStarted(
    AiChatStarted event,
    Emitter<AiChatState> emit,
  ) async {
    emit(state.copyWith(status: AiChatStatus.loading));
    await Future.delayed(const Duration(milliseconds: 300));

    emit(
      state.copyWith(
        status: AiChatStatus.ready,
        messages: [
          ChatMessageEntity(
            id: 'm1',
            text: 'Hi Alex! 👋 How can I help you with your money today?',
            sender: MessageSender.ai,
            timestamp: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<void> _onMessageSent(
    AiChatMessageSent event,
    Emitter<AiChatState> emit,
  ) async {
    if (event.text.trim().isEmpty) return;

    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: event.text.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage],
        status: AiChatStatus.aiTyping,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 900));

    final aiReply = ChatMessageEntity(
      id: '${DateTime.now().millisecondsSinceEpoch}_ai',
      text: _generateReply(event.text),
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, aiReply],
        status: AiChatStatus.ready,
      ),
    );
  }

  String _generateReply(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('save') || lower.contains('goal')) {
      return 'Try saving ₹50 extra per week — you\'d reach your Laptop goal about 3 weeks sooner! 🚀';
    } else if (lower.contains('allowance') || lower.contains('divide')) {
      return 'A simple split: 50% needs, 30% wants, 20% savings. Want me to set that up as your budget?';
    } else if (lower.contains('budget')) {
      return 'You\'re at 68% of your monthly budget with 6 days left — you\'re on track! Keep an eye on Shopping, it\'s closest to its limit.';
    }
    return 'Good question! I\'m still learning, but based on your recent activity, staying consistent with small savings adds up fast. 💪';
  }
}

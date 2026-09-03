import 'package:equatable/equatable.dart';

abstract class AiChatEvent extends Equatable {
  const AiChatEvent();

  @override
  List<Object?> get props => [];
}

class AiChatStarted extends AiChatEvent {
  const AiChatStarted();
}

class AiChatMessageSent extends AiChatEvent {
  final String text;
  const AiChatMessageSent(this.text);

  @override
  List<Object?> get props => [text];
}

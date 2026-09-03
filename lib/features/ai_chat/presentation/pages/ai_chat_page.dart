import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../bloc/ai_chat_bloc.dart';
import '../bloc/ai_chat_event.dart';
import '../bloc/ai_chat_state.dart';
import '../../../personalized_plan/presentation/pages/personalized_plan_page.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AiChatBloc()..add(const AiChatStarted()),
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _quickReplies = [
    'Divide my allowance',
    'Savings tips',
    'Budget help',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    context.read<AiChatBloc>().add(AiChatMessageSent(text));
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppSizes.space8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primaryText,
                      size: 20,
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPurple.withOpacity(0.4),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: AppColors.info,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: AppSizes.space8),
                  Expanded(
                    child: Text('Money Buddy AI', style: AppTextStyles.h3),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PersonalizedPlanPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.goldAccent,
                    ),
                  ),
                ],
              ),

              Expanded(
                child: BlocBuilder<AiChatBloc, AiChatState>(
                  builder: (context, state) {
                    if (state.status == AiChatStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.goldAccent,
                        ),
                      );
                    }

                    return ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.screenPaddingH,
                        vertical: AppSizes.space16,
                      ),
                      children: [
                        ...state.messages.map((m) => _ChatBubble(message: m)),
                        if (state.status == AiChatStatus.aiTyping)
                          const _TypingBubble(),
                      ],
                    );
                  },
                ),
              ),

              // Quick reply chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPaddingH,
                  ),
                  children: _quickReplies
                      .map(
                        (q) => Padding(
                          padding: const EdgeInsets.only(
                            right: AppSizes.space8,
                          ),
                          child: OutlinedButton(
                            onPressed: () => _send(context, q),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 36),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.space16,
                              ),
                            ),
                            child: Text(q, style: AppTextStyles.caption),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: AppSizes.space8),

              // Input bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH,
                  vertical: AppSizes.space8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryText,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ask me anything...',
                          prefixIcon: Icon(
                            Icons.mic_none_rounded,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        onSubmitted: (text) => _send(context, text),
                      ),
                    ),
                    const SizedBox(width: AppSizes.space8),
                    InkWell(
                      onTap: () => _send(context, _controller.text),
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldAccent,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: AppColors.darkPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessageEntity message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: AppSizes.space12),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space16,
          vertical: AppSizes.space12,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryPurple : AppColors.glassCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) ...[
              const Icon(
                Icons.smart_toy_rounded,
                size: 16,
                color: AppColors.info,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                message.text,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.space12),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.space16,
          vertical: AppSizes.space12,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.smart_toy_rounded, size: 16, color: AppColors.info),
            SizedBox(width: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.goldAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/chat/data/chat_repository.dart';
import 'package:chat_app/features/chat/domain/message_model.dart';
import 'package:chat_app/features/auth/presentation/auth_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

final messagesProvider = StreamProvider.family<List<MessageModel>, String>((ref, otherUserId) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  
  final repo = ref.watch(chatRepositoryProvider);
  return repo.getMessages(user.uid, otherUserId);
});

final typingStatusProvider = StreamProvider.family<bool, String>((ref, otherUserId) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(false);
  
  return ref.watch(chatRepositoryProvider).isOtherUserTyping(user.uid, otherUserId);
});


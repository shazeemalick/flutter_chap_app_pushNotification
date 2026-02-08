import 'package:firebase_database/firebase_database.dart';
import 'package:chat_app/features/chat/domain/message_model.dart';
import 'package:chat_app/core/app_constants.dart';

class ChatRepository {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<List<MessageModel>> getMessages(String senderId, String receiverId) {
    final chatId = getChatId(senderId, receiverId);
    return _db
        .ref()
        .child(AppConstants.messagesPath)
        .child(chatId)
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      final Map<dynamic, dynamic>? messagesMap = event.snapshot.value as Map<dynamic, dynamic>?;
      if (messagesMap == null) return [];
      
      final messages = messagesMap.values.map((m) => MessageModel.fromMap(m)).toList();
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  Future<void> sendMessage(MessageModel message) async {
    final chatId = getChatId(message.senderId, message.receiverId);
    final ref = _db.ref().child(AppConstants.messagesPath).child(chatId).push();
    final newMessage = message.copyWith(id: ref.key);
    await ref.set(newMessage.toMap());
    
    // Update chat list for both users
    await _updateChatList(message.senderId, message.receiverId, newMessage);
    await _updateChatList(message.receiverId, message.senderId, newMessage);
  }

  Future<void> _updateChatList(String userId, String otherUserId, MessageModel lastMessage) async {
    await _db.ref().child(AppConstants.chatListPath).child(userId).child(otherUserId).set({
      'lastMessage': lastMessage.content,
      'lastMessageTime': lastMessage.timestamp.millisecondsSinceEpoch,
      'otherUserId': otherUserId,
    });
  }

  Future<void> setTypingStatus(String senderId, String receiverId, bool isTyping) async {
    final chatId = getChatId(senderId, receiverId);
    await _db.ref().child('typing').child(chatId).child(senderId).set(isTyping);
  }

  Stream<bool> isOtherUserTyping(String senderId, String receiverId) {
    final chatId = getChatId(senderId, receiverId);
    return _db
        .ref()
        .child('typing')
        .child(chatId)
        .child(receiverId)
        .onValue
        .map((event) => event.snapshot.value as bool? ?? false);
  }

  Future<void> markMessagesAsRead(String senderId, String receiverId) async {
    final chatId = getChatId(senderId, receiverId);
    final snapshot = await _db.ref().child(AppConstants.messagesPath).child(chatId).get();
    
    if (snapshot.exists) {
      final Map<dynamic, dynamic> messagesMap = snapshot.value as Map<dynamic, dynamic>;
      messagesMap.forEach((key, value) {
        if (value['senderId'] == receiverId && value['isRead'] == false) {
          _db.ref().child(AppConstants.messagesPath).child(chatId).child(key).update({'isRead': true});
        }
      });
    }
  }

  String getChatId(String u1, String u2) {
    final ids = [u1, u2];
    ids.sort();
    return ids.join('_');
  }
}

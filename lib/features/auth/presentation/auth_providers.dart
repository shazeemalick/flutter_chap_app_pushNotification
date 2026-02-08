import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/features/auth/data/auth_repository.dart';
import 'package:chat_app/features/auth/domain/user_model.dart';
import 'package:chat_app/core/fcm_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(ref.watch(authRepositoryProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user != null) {
    return ref.watch(authRepositoryProvider).getUserData(user.uid);
  }
  return null;
});

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authRepositoryProvider).getAllUsers();
});

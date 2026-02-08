import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:chat_app/features/auth/domain/user_model.dart';
import 'package:chat_app/core/app_constants.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> getUserData(String uid) async {
    final snapshot = await _db.ref().child(AppConstants.usersPath).child(uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.value as Map<dynamic, dynamic>);
    }
    return null;
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String displayName) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    
    if (credential.user != null) {
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
      );
      
      await _db.ref().child(AppConstants.usersPath).child(user.id).set(user.toMap());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> setUserOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.ref().child(AppConstants.usersPath).child(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': ServerValue.timestamp,
      });
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.ref().child(AppConstants.usersPath).get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> usersMap = snapshot.value as Map<dynamic, dynamic>;
      final currentUser = _auth.currentUser;
      return usersMap.values
          .map((u) => UserModel.fromMap(u))
          .where((u) => u.id != currentUser?.uid)
          .toList();
    }
    return [];
  }

  Future<void> updatePushToken(String token) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _db.ref().child(AppConstants.usersPath).child(user.uid).update({
        'pushToken': token,
      });
    }
  }
}

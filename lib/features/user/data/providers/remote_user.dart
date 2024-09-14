import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/features/user/data/models/user.dart';
import 'package:moniman/features/user/domain/entities/user.dart';

abstract class RemoteUserProvider {
  Stream<User?> onUserChange({required String userId});
  Future<void> updateUser(UserModel user);
  Future<User> getUser({required String userId});
}

class RemoteUserProviderImpl implements RemoteUserProvider {
  final _firestore = FirebaseFirestore.instance;

  @override
  Stream<User?> onUserChange({required String userId}) {
    return _firestore.collection('users').doc(userId).snapshots().map(
      (snapshot) {
        if (!snapshot.exists) return null;
        final data = snapshot.data();
        data!['id'] = snapshot.id;
        return UserModel.fromMap(data);
      },
    );
  }

  @override
  Future<UserModel> getUser({required String userId}) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).get();
      final data = snapshot.data();
      data!['id'] = snapshot.id;
      return UserModel.fromMap(data);
    } on FirebaseException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toUpdateMap());
    } on FirebaseException catch (error) {
      throw Exception(error.message);
    }
  }
}

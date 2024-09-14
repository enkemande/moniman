import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/features/onboarding/data/models/onboarding_step.dart';

abstract class RemoteOnboardingProvider {
  Stream<List<OnboardingStepModel>> onStepsChange(String userId);
  Future<void> completeStep({
    required String type,
    required String userId,
  });
  Future<void> skipStep({
    required String type,
    required String userId,
  });
  Future<List<OnboardingStepModel>> getSteps(String userId);
}

class RemoteOnboardingProviderImpl implements RemoteOnboardingProvider {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<OnboardingStepModel>> getSteps(String userId) async {
    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("onboarding_steps")
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['type'] = doc.id;
        return OnboardingStepModel.fromMap(data);
      }).toList();
    } on FirebaseException catch (e) {
      throw OnboardingStepException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> completeStep({
    required String type,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("onboarding_steps")
          .doc(type)
          .set(
        {
          'completed': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw OnboardingStepException(e.message ?? 'An error occurred');
    }
  }

  @override
  Future<void> skipStep({
    required String type,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("onboarding_steps")
          .doc(type)
          .set(
        {
          'skipped': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } on FirebaseException catch (e) {
      throw OnboardingStepException(e.message ?? 'An error occurred');
    }
  }

  @override
  Stream<List<OnboardingStepModel>> onStepsChange(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("onboarding_steps")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['type'] = doc.id;
        return OnboardingStepModel.fromMap(data);
      }).toList();
    });
  }
}

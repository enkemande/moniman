import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/features/onboarding/data/models/onboarding_step.dart';

const onboardingSteps = [
  {'type': 'legalName', 'name': 'Legal Name'},
  // {'type': 'address', 'name': 'Address'},
  // {'type': 'bankDetails', 'name': 'Bank Details'},
  // {'type': 'documentVerification', 'name': 'Document Verification'},
];

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
  Future<void> initOnboardingSteps({
    required String userId,
  });
}

class RemoteOnboardingProviderImpl implements RemoteOnboardingProvider {
  final _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<OnboardingStepModel>> onStepsChange(String userId) {
    return _firestore
        .collection("accounts")
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

  @override
  Future<List<OnboardingStepModel>> getSteps(String userId) async {
    try {
      final snapshot = await _firestore
          .collection("accounts")
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
          .collection("accounts")
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
          .collection("accounts")
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
  Future<void> initOnboardingSteps({required String userId}) async {
    try {
      final collection = _firestore
          .collection('accounts')
          .doc(userId)
          .collection('onboarding_steps');

      await Future.wait(onboardingSteps.map((step) {
        return collection.doc(step['type']).set({
          'name': step['name'],
          'completed': false,
          'skipped': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }));
    } on FirebaseException catch (e) {
      throw OnboardingStepException(e.message ?? 'An error occurred');
    }
  }
}

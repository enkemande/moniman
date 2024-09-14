import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/exceptions.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/onboarding/data/providers/remote_onboarding.dart';
import 'package:moniman/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:moniman/features/onboarding/domain/repositories/onboarding.dart';

class OnboardingStepRepositoryImpl implements OnboardingRepository {
  final RemoteOnboardingProvider remoteOnboardingProvider;

  OnboardingStepRepositoryImpl({
    required this.remoteOnboardingProvider,
  });

  @override
  Future<Either<Failure, List<OnboardingStep>>> getSteps(String userId) async {
    try {
      final steps = await remoteOnboardingProvider.getSteps(userId);
      return Right(steps.map((step) => step.toEntity()).toList());
    } on OnboardingStepException catch (e) {
      return Left(OnboardingStepFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> completeStep({
    required String type,
    required String userId,
  }) async {
    try {
      await remoteOnboardingProvider.completeStep(
        type: type,
        userId: userId,
      );
      return const Right(null);
    } on OnboardingStepException catch (e) {
      return Left(OnboardingStepFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> skipStep({
    required String type,
    required String userId,
  }) async {
    try {
      await remoteOnboardingProvider.skipStep(
        type: type,
        userId: userId,
      );
      return const Right(null);
    } on OnboardingStepException catch (e) {
      return Left(OnboardingStepFailure(e.message));
    }
  }

  @override
  Stream<List<OnboardingStep>> onStepsChange(String userId) {
    return remoteOnboardingProvider
        .onStepsChange(userId)
        .map((steps) => steps.map((step) => step.toEntity()).toList());
  }
}

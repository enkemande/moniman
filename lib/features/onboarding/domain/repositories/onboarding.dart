import 'package:dartz/dartz.dart';
import 'package:moniman/core/errors/failures.dart';
import 'package:moniman/features/onboarding/domain/entities/onboarding_step.dart';

abstract class OnboardingRepository {
  Stream<List<OnboardingStep>> onStepsChange(String userId);
  Future<Either<Failure, List<OnboardingStep>>> getSteps(String userId);
  Future<Either<Failure, void>> completeStep({
    required String type,
    required String userId,
  });
  Future<Either<Failure, void>> skipStep({
    required String type,
    required String userId,
  });
}

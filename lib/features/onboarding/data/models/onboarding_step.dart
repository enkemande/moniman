import 'package:equatable/equatable.dart';
import 'package:moniman/features/onboarding/domain/entities/onboarding_step.dart';

class OnboardingStepModel extends Equatable {
  final String name;
  final String type;
  final bool completed;
  final bool skipped;

  const OnboardingStepModel({
    required this.name,
    required this.type,
    required this.completed,
    required this.skipped,
  });

  factory OnboardingStepModel.fromMap(Map<String, dynamic> map) {
    return OnboardingStepModel(
      name: map['name'],
      type: map['type'],
      completed: map['completed'],
      skipped: map['skipped'],
    );
  }

  factory OnboardingStepModel.fromEntity(OnboardingStep entity) {
    return OnboardingStepModel(
      name: entity.name,
      type: entity.type,
      completed: entity.completed,
      skipped: entity.skipped,
    );
  }

  OnboardingStep toEntity() {
    return OnboardingStep(
      name: name,
      type: type,
      completed: completed,
      skipped: skipped,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'completed': completed,
      'skipped': skipped,
    };
  }

  @override
  List<Object?> get props => [name, type, completed, skipped];
}

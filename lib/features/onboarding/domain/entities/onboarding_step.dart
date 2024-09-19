import 'package:equatable/equatable.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';

class OnboardingStep extends Equatable {
  final String name;
  final String type;
  final bool completed;
  final bool skipped;

  const OnboardingStep({
    required this.name,
    required this.type,
    required this.completed,
    required this.skipped,
  });

  String get path {
    switch (type) {
      case 'legalName':
        return AppRoute.setupLegalNameOnboardingStep.path;
      default:
        return '';
    }
  }

  // empty default values
  static OnboardingStep empty() {
    return const OnboardingStep(
      name: '',
      type: '',
      completed: false,
      skipped: false,
    );
  }

  OnboardingStep copyWith({
    String? name,
    String? type,
    bool? completed,
    bool? skipped,
  }) {
    return OnboardingStep(
      name: name ?? this.name,
      type: type ?? this.type,
      completed: completed ?? this.completed,
      skipped: skipped ?? this.skipped,
    );
  }

  @override
  List<Object?> get props => [name, type, completed, skipped];
}

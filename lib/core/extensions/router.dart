import 'package:moniman/core/enums/routes.dart';

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.verifyPhoneNumber:
        return '/verify-phone-number';
      case AppRoute.verifyOtp:
        return '/verify-otp';
      case AppRoute.dashboard:
        return '/dashboard';
      case AppRoute.deposit:
        return '/deposit';
      case AppRoute.depositConfirmation:
        return '/deposit-confirmation';
      case AppRoute.withdraw:
        return '/withdraw';
      case AppRoute.withdrawConfirmation:
        return '/withdraw-confirmation';
      case AppRoute.payment:
        return '/payment';
      case AppRoute.paymentConfirmation:
        return '/payment-confirmation';
      case AppRoute.setupLegalNameOnboardingStep:
        return '/onboarding/setup-legal-name';
      case AppRoute.profile:
        return '/profile';
    }
  }

  String get name {
    return toString().split('.').last;
  }
}

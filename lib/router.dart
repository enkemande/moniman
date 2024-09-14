import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moniman/core/enums/routes.dart';
import 'package:moniman/core/extensions/router.dart';
import 'package:moniman/core/utils/stream_change_notifier.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/auth/presentation/pages/verify_otp.dart';
import 'package:moniman/features/auth/presentation/pages/verify_phone_number.dart';
import 'package:moniman/features/dashboard/presentation/pages/dashboard.dart';
import 'package:moniman/features/deposit/presentation/pages/deposit.dart';
import 'package:moniman/features/deposit/presentation/pages/deposit_confirmation.dart';
import 'package:moniman/features/onboarding/presentation/pages/setup_legal_name.dart';
import 'package:moniman/features/onboarding/presentation/widgets/onboarding_guard.dart';
import 'package:moniman/features/user/presentation/pages/user_profile.dart';
import 'package:moniman/service_locator.dart';

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final protectedRoutes = [
    AppRoute.dashboard.path,
    AppRoute.setupLegalNameOnboardingStep.path,
    AppRoute.deposit.path,
    AppRoute.withdraw.path,
    AppRoute.depositConfirmation.path,
    AppRoute.withdrawConfirmation.path,
    AppRoute.profile.path,
  ];

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // debugLogDiagnostics: true,
    initialLocation: AppRoute.dashboard.path,
    refreshListenable: StreamChangeNotifier([sl<AuthBloc>().stream]),
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final isProtectedRoute = protectedRoutes.contains(state.uri.path);
      final isAuthenticated = authBloc.state is Authenticated;
      final isUnAuthenticated = authBloc.state is Unauthenticated;
      final isAuthError = authBloc.state is AuthError;

      if (isAuthenticated && !isProtectedRoute) {
        return AppRoute.dashboard.path;
      }

      if ((isAuthError || isUnAuthenticated) && isProtectedRoute) {
        return AppRoute.verifyPhoneNumber.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoute.verifyPhoneNumber.name,
        path: AppRoute.verifyPhoneNumber.path,
        builder: (context, state) => VerifyPhoneNumberPage(),
      ),
      GoRoute(
        name: AppRoute.verifyOtp.name,
        path: AppRoute.verifyOtp.path,
        builder: (context, state) {
          final verificationId = state.uri.queryParameters['verificationId']!;
          return VerifyOtpPage(verificationId: verificationId);
        },
      ),
      GoRoute(
        name: AppRoute.setupLegalNameOnboardingStep.name,
        path: AppRoute.setupLegalNameOnboardingStep.path,
        builder: (context, state) => const SetupLegalNameOnboardingStepPage(),
      ),
      GoRoute(
        name: AppRoute.deposit.name,
        path: AppRoute.deposit.path,
        builder: (context, state) => OnboardingGuard(child: DepositPage()),
      ),
      GoRoute(
        name: AppRoute.depositConfirmation.name,
        path: AppRoute.depositConfirmation.path,
        builder: (context, state) => const OnboardingGuard(
          child: DepositConfirmationPage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return OnboardingGuard(
            child: Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navigationShell.currentIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                onTap: (index) {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                },
              ),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.dashboard.name,
                path: AppRoute.dashboard.path,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.profile.name,
                path: AppRoute.profile.path,
                builder: (context, state) => const UserProfilePage(),
              ),
            ],
          ),
        ],
      )
    ],
  );
}

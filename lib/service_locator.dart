import 'package:get_it/get_it.dart';
import 'package:moniman/features/auth/data/providers/remote_auth.dart';
import 'package:moniman/features/auth/data/repositories/auth.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/auth/domain/repositories/auth.dart';
import 'package:moniman/features/deposit/data/providers/remote_deposit.dart';
import 'package:moniman/features/deposit/data/repositories/deposit.dart';
import 'package:moniman/features/deposit/domain/bloc/deposit_bloc.dart';
import 'package:moniman/features/deposit/domain/repositories/deposit.dart';
import 'package:moniman/features/onboarding/data/providers/remote_onboarding.dart';
import 'package:moniman/features/onboarding/data/repositories/onboarding.dart';
import 'package:moniman/features/onboarding/domain/bloc/onboarding_bloc.dart';
import 'package:moniman/features/onboarding/domain/repositories/onboarding.dart';
import 'package:moniman/features/transactions/data/providers/remote_transaction.dart';
import 'package:moniman/features/transactions/data/repositories/transaction.dart';
import 'package:moniman/features/transactions/domain/bloc/transactions_bloc.dart';
import 'package:moniman/features/transactions/domain/repositories/transaction.dart';
import 'package:moniman/features/user/data/providers/remote_user.dart';
import 'package:moniman/features/user/data/repositories/user.dart';
import 'package:moniman/features/user/domain/bloc/user_bloc.dart';
import 'package:moniman/features/user/domain/repositories/user.dart';
import 'package:moniman/router.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Providers
  sl.registerSingleton<RemoteAuthProvider>(RemoteAuthProviderImpl());
  sl.registerSingleton<RemoteOnboardingProvider>(
    RemoteOnboardingProviderImpl(),
  );
  sl.registerSingleton<RemoteDepositProvider>(
    RemoteDepositProviderImpl(),
  );
  sl.registerSingleton<RemoteUserProvider>(
    RemoteUserProviderImpl(),
  );
  sl.registerSingleton<RemoteTransactionProvider>(
    RemoteTransactionProviderImpl(),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteAuthProvider: sl(),
  ));
  sl.registerSingleton<OnboardingRepository>(OnboardingStepRepositoryImpl(
    remoteOnboardingProvider: sl(),
  ));
  sl.registerSingleton<DepositRepository>(DepositRepositoryImpl(
    remoteDepositProvider: sl(),
  ));
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(
    remoteUserProvider: sl(),
  ));
  sl.registerSingleton<TransactionRepository>(TransactionRepositoryImpl(
    remoteTransactionProvider: sl(),
  ));

  // Blocs
  sl.registerSingleton<AuthBloc>(AuthBloc(authRepository: sl()));
  sl.registerSingleton<OnboardingBloc>(
    OnboardingBloc(
      authBloc: sl(),
      onboardingRepository: sl(),
    ),
  );
  sl.registerSingleton<UserBloc>(UserBloc(
    userRepository: sl(),
    authBloc: sl(),
    onboardingBloc: sl(),
  ));
  sl.registerSingleton<TransactionsBloc>(
    TransactionsBloc(
      transactionRepository: sl(),
      authBloc: sl(),
    ),
  );
  sl.registerSingleton<DepositBloc>(DepositBloc(
    depositRepository: sl(),
    authBloc: sl(),
  ));

  // Router
  sl.registerSingleton<AppRouter>(AppRouter());
}

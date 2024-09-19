import 'package:get_it/get_it.dart';
import 'package:moniman/core/utils/aes_encryption.dart';
import 'package:moniman/core/utils/rsa_encryption.dart';
import 'package:moniman/core/utils/secure_storage.dart';
import 'package:moniman/features/account/data/providers/remote_account.dart';
import 'package:moniman/features/account/data/repositories/account.dart';
import 'package:moniman/features/account/domain/bloc/account_bloc.dart';
import 'package:moniman/features/account/domain/repositories/account.dart';
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
import 'package:moniman/features/transaction_history/data/providers/remote_transaction_history.dart';
import 'package:moniman/features/transaction_history/data/repositories/transaction_history.dart';
import 'package:moniman/features/transaction_history/domain/bloc/transaction_history_bloc.dart';
import 'package:moniman/features/transaction_history/domain/repositories/transaction_history.dart';
import 'package:moniman/router.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Utils
  sl.registerSingleton<RsaEncryption>(RsaEncryption());
  sl.registerSingleton<SecureStorage>(SecureStorage());
  sl.registerSingleton<AesEncryption>(AesEncryption());

  // Providers
  sl.registerSingleton<RemoteOnboardingProvider>(
    RemoteOnboardingProviderImpl(),
  );
  sl.registerSingleton<RemoteAccountProvider>(RemoteAccountProviderImpl(
    secureStorage: sl(),
    rsaEncryption: sl(),
  ));
  sl.registerSingleton<RemoteDepositProvider>(
    RemoteDepositProviderImpl(
      rsaEncryption: sl(),
      secureStorage: sl(),
      aesEncryption: sl(),
    ),
  );

  sl.registerSingleton<RemoteAuthProvider>(RemoteAuthProviderImpl(
    rsaEncryption: sl(),
    remoteOnboardingProvider: sl(),
    remoteAccountProvider: sl(),
    secureStorage: sl(),
  ));

  sl.registerSingleton<RemoteTransactionHistoryProvider>(
    RemoteTransactionHistoryProviderImpl(
      aesEncryption: sl(),
      rsaEncryption: sl(),
      secureStorage: sl(),
    ),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteAuthProvider: sl(),
  ));
  sl.registerSingleton<AccountRepository>(AccountRepositoryImpl(
    remoteAccountProvider: sl(),
  ));
  sl.registerSingleton<OnboardingRepository>(OnboardingStepRepositoryImpl(
    remoteOnboardingProvider: sl(),
  ));
  sl.registerSingleton<DepositRepository>(DepositRepositoryImpl(
    remoteDepositProvider: sl(),
  ));
  sl.registerSingleton<TransactionHistoryRepository>(
    TransactionHistoryRepositoryImpl(
      remoteTransactionHistoryProvider: sl(),
    ),
  );

  // Blocs
  sl.registerSingleton<AuthBloc>(AuthBloc(authRepository: sl()));
  sl.registerSingleton<AccountBloc>(AccountBloc(
    accountRepository: sl(),
    authBloc: sl(),
  ));
  sl.registerSingleton<OnboardingBloc>(
    OnboardingBloc(
      authBloc: sl(),
      onboardingRepository: sl(),
    ),
  );
  sl.registerSingleton<DepositBloc>(DepositBloc(
    depositRepository: sl(),
    authBloc: sl(),
  ));
  sl.registerSingleton<TransactionHistoryBloc>(
    TransactionHistoryBloc(
      transactionHistoryRepository: sl(),
      authBloc: sl(),
    ),
  );

  // Router
  sl.registerSingleton<AppRouter>(AppRouter());
}

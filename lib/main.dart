import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:moniman/core/presentation/theme/app_theme.dart';
import 'package:moniman/features/account/domain/bloc/account_bloc.dart';
import 'package:moniman/features/auth/domain/bloc/auth_bloc.dart';
import 'package:moniman/features/deposit/domain/bloc/deposit_bloc.dart';
import 'package:moniman/features/onboarding/domain/bloc/onboarding_bloc.dart';
import 'package:moniman/features/transaction_history/domain/bloc/transaction_history_bloc.dart';
import 'package:moniman/firebase_options.dart';
import 'package:moniman/router.dart';
import 'package:moniman/service_locator.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    try {
      FirebaseFunctions.instance.useFunctionsEmulator('192.168.86.77', 5001);
      FirebaseFirestore.instance.useFirestoreEmulator('192.168.86.77', 3007);
      await FirebaseAuth.instance.useAuthEmulator('192.168.86.77', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<AccountBloc>()),
        BlocProvider(create: (context) => sl<OnboardingBloc>()),
        BlocProvider(create: (context) => sl<TransactionHistoryBloc>()),
        BlocProvider(create: (context) => sl<DepositBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routerConfig: sl<AppRouter>().router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}

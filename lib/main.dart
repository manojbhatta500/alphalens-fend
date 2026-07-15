import 'package:alphalens_fend/blocs/Extract_entity/extract_entity_cubit.dart';
import 'package:alphalens_fend/blocs/company/company_cubit.dart';
import 'package:alphalens_fend/blocs/login/login_cubit.dart';
import 'package:alphalens_fend/data/repositories/auth/auth_repository.dart';
import 'package:alphalens_fend/data/repositories/company/company_repository.dart';
import 'package:alphalens_fend/data/repositories/company/extract_entity_repository.dart';
import 'package:alphalens_fend/ui/auth/screens/login_screen.dart';
import 'package:alphalens_fend/ui/auth/screens/signup_screen.dart';
import 'package:alphalens_fend/ui/dashboard/dashboard.dart';
import 'package:alphalens_fend/ui/landing/landing_screen.dart';
import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alphalens_fend/utils/api_client.dart';
import 'package:alphalens_fend/blocs/signup/signup_cubit.dart';

import 'blocs/theme/theme_cubit.dart';
import 'blocs/theme/theme_state.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
    await TokenStorage.deleteToken();

     final isLoggedIn = await TokenStorage.isLoggedIn();




  // 1. Initialize your single-instance backend dependencies
  final apiClient = ApiClient();
  final authRepository = AuthRepository(apiClient);
  final companyRepository = CompanyRepository(apiClient);
  final extractEntityRepository = ExtractEntityRepository(apiClient); // 👇 ADD THIS LINE

  runApp(
    // 2. Inject BOTH repositories down into the tree using MultiRepositoryProvider
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CompanyRepository>.value(value: companyRepository),
        RepositoryProvider<ExtractEntityRepository>.value(value: extractEntityRepository),
      ],
      child: AlphaLensApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class AlphaLensApp extends StatelessWidget {
    final bool isLoggedIn;

  const AlphaLensApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Theme State management
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        // Scoped Signup State management linked safely to your repository
        BlocProvider<SignupCubit>(
          create: (context) => SignupCubit(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
        ),
          BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
            RepositoryProvider.of<AuthRepository>(context),
          ),
        ),
           BlocProvider<CompanyCubit>(
          create: (context) => CompanyCubit(
            RepositoryProvider.of<CompanyRepository>(context),
          ),
        ),
         BlocProvider<ExtractEntityCubit>(
          create: (context) => ExtractEntityCubit(
            RepositoryProvider.of<ExtractEntityRepository>(context),
          ),
        ),
        
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'AlphaLens',
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.blue,
              scaffoldBackgroundColor: const Color(0xFF0F172A),
            ),
             initialRoute: isLoggedIn ? '/dashboard' : '/',
            routes: {
              '/': (context) => const LandingScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/dashboard': (context) => const Dashboard(),
            },
          );
        },
      ),
    );
  }
}
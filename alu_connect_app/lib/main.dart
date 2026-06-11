import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/opportunity_details_screen.dart';
import 'screens/create_opportunity_screen.dart';
import 'providers/user_provider.dart';
import 'providers/event_provider.dart';
import 'providers/feed_provider.dart';
import 'models/opportunity_model.dart';
import 'features/badges/providers/badges_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => BadgesProvider()),
      ],
      child: MaterialApp(
        title: 'ALU Connect',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.offWhite,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.red,
            primary: AppColors.red,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.navyBlue,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/opportunity-details') {
            final opportunityId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) =>
                  OpportunityDetailsScreen(opportunityId: opportunityId),
            );
          } else if (settings.name == '/create-opportunity') {
            final opportunityType =
                settings.arguments as OpportunityType? ?? OpportunityType.event;
            return MaterialPageRoute(
              builder: (context) =>
                  CreateOpportunityScreen(opportunityType: opportunityType),
            );
          }
          return null;
        },
      ),
    );
  }
}

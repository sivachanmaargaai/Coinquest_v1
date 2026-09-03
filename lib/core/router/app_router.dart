import 'package:coinquest_v1_app/features/age_selection/presentation/pages/segment2_intro_page.dart';
import 'package:flutter/material.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/welcome/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/age_selection/presentation/pages/age_selection_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

/// Route name constants — use these everywhere instead of raw strings.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String signUp = '/sign-up';
  static const String ageSelection = '/age-selection'; // to be built next
  static const String segment2Intro = '/segment2-intro';

  static const String home = '/home';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case AppRoutes.ageSelection:
        return MaterialPageRoute(builder: (_) => const AgeSelectionPage());
      case AppRoutes.segment2Intro:
        return MaterialPageRoute(builder: (_) => const Segment2IntroPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

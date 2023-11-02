import 'package:flutter/material.dart';
import 'package:medyo/features/auth/views/change_pass_screen.dart';
import 'package:medyo/features/auth/views/login_screen.dart';
import 'package:medyo/features/auth/views/password_recovery_stage_three.dart';
import 'package:medyo/features/auth/views/reset_pass_phase_one.dart';
import 'package:medyo/features/auth/views/reset_pass_phase_two.dart';
import 'package:medyo/features/auth/views/sign_up_screen.dart';
import 'package:medyo/features/catagories/afternoon_reset_all.dart';
import 'package:medyo/features/catagories/all_catagories.dart';
import 'package:medyo/features/catagories/most_recommended_channels.dart';
import 'package:medyo/features/core/models/category_list_model/category.dart';
import 'package:medyo/features/core/views/home_screen_wrapper.dart';
import 'package:medyo/features/core/views/menu_page.dart';
import 'package:medyo/features/core/views/onboarding_screen.dart';
import 'package:medyo/features/core/views/player_screen.dart';
import 'package:medyo/features/core/views/premium_sub_screen.dart';
import 'package:medyo/features/core/views/splash_screen.dart';
import 'package:medyo/features/core/views/sub_category_page.dart';
import 'package:medyo/features/other/views/contact_us.dart';
import 'package:medyo/features/other/views/privacy_policy.dart';
import 'package:medyo/features/profile/views/downloads_page.dart';
import 'package:medyo/features/profile/views/my_subscription_screen.dart';
import 'package:medyo/features/theme/theme_change.dart';
import 'package:medyo/utils/context_less_nav.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  /*We are mapping all th eroutes here
  so that we can call any named route
  without making typing mistake
  */
  Routes._();
  //core
  static const splash = '/';
  static const onBoardingScreen = '/onBoardingScreen';
  static const homeScreen = '/homeScreen';
  static const loginScreen = '/loginScreen';
  static const signUpScreen = '/signUpScreen';
  static const resetPassPhaseOneScreen = '/resetPassPhaseOneScreen';
  static const resetPassPhaseTwoScreen = '/resetPassPhaseTwoScreen';
  static const resetPassPhaseThreeScreen = '/resetPassPhaseThreeScreen';
  static const changePass = '/changePass';
  static const downLoadScreen = '/downLoadScreen';
  static const subCategoryScreen = '/subCategoryScreen';
  static const playerScreen = '/playerScreen';
  static const premiumSubScreen = '/premiumSubScreen';
  static const mySubScreen = '/mySubScreen';
  static const contactUs = '/contactUs';
  static const privacyPolicy = '/privacyPolicy';
  static const allcatagories = '/allcatagories';
  static const afternoonreset = '/afternoonreset';
  static const mostrecommendedchannel = '/mostrecommendedchannel';
  static const themechange = '/themechange';
  static const menupage = '/menupage';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashScreen();
      break;
    case Routes.onBoardingScreen:
      child = const OnBoardingScreen();
      break;
    case Routes.homeScreen:
      child = const HomeScreenWrapper();
      break;
    case Routes.loginScreen:
      child = const LoginScreen();
      break;
    case Routes.signUpScreen:
      child = const SignUpScreen();
      break;
    case Routes.resetPassPhaseOneScreen:
      child = const ResetPassPhaseOneScreen();
      break;
    case Routes.resetPassPhaseTwoScreen:
      child = ResetPassPhaseTwoScreen(
        forEmailorPhone: settings.arguments as String,
      );
      break;
    case Routes.resetPassPhaseThreeScreen:
      child = ResetPassPhaseThreeScreen(
        token: settings.arguments as String,
      );
      break;
    case Routes.changePass:
      child = const ChangePassScreen();
      break;
    case Routes.downLoadScreen:
      child = const MyDownLoadsScreen();
      break;
    case Routes.subCategoryScreen:
      child = SubCategoryPage(
        category: settings.arguments as Category,
      );
      break;
    case Routes.playerScreen:
      child = const PlayerScreen();
      break;
    case Routes.premiumSubScreen:
      child = const PremiumSubScreen();
      break;
    case Routes.mySubScreen:
      child = const MySubScreen();
      break;
    case Routes.contactUs:
      child = const ContactUs();
      break;
    case Routes.privacyPolicy:
      child = const PrivacyPolicy();
      break;
    case Routes.allcatagories:
      child = const AllCatagoriesScreen();
      break;
    case Routes.afternoonreset:
      child = const AfterNoonResetAllScreen();
      break;
    case Routes.mostrecommendedchannel:
      child = const MostRecommendedChannelsScreen();
      break;
    case Routes.themechange:
      child = const ThemeChangeScreen();
      break;
    case Routes.menupage:
      child = const MenuPage();
      break;

    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint('Route: ${settings.name}');

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: 700.milisec,
    reverseDuration: 700.milisec,
  );
}

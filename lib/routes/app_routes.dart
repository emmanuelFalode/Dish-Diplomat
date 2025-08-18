import 'package:foodapp/screens/Sign-in-up/forgot_password.dart';
import 'package:foodapp/screens/Sign-in-up/location.dart';
import 'package:foodapp/screens/Sign-in-up/verification.dart';
import 'package:foodapp/screens/cart.dart';
import 'package:foodapp/screens/menu/widget/items_details.dart';
import 'package:foodapp/screens/onboarding/onboarding.dart';
import 'package:foodapp/screens/splash_screen/splash1.dart';
import 'package:go_router/go_router.dart';
import 'package:foodapp/screens/splash_screen/splash_view.dart';
import 'package:foodapp/screens/bottombars/bottom_bar_page.dart';
import 'package:foodapp/screens/Sign-in-up/signin.dart';
import 'package:foodapp/screens/Sign-in-up/signup.dart';
import 'package:foodapp/screens/menu/menu.dart';
import 'package:foodapp/screens/menu/menu_items.dart';
import 'package:foodapp/screens/bottombars/notification.dart';
import 'package:foodapp/screens/bottombars/profile.dart';
import 'package:foodapp/screens/bottombars/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash1',
  routes: [
    GoRoute(
      path: '/splash_view',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(path: '/splash1', builder: (context, state) => const Splash1()),
    GoRoute(path: '/', builder: (context, state) => const BottomBarPage()),
    GoRoute(
      path: '/verification',
      builder: (context, state) => const Verification(),
    ),
    GoRoute(path: '/cart', builder: (context, state) => const Cart()),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(path: '/signin', builder: (context, state) => const Signin()),
    GoRoute(path: '/signin', builder: (context, state) => const Signin()),
    GoRoute(path: '/location', builder: (context, state) => const Location()),
    GoRoute(path: '/menu', builder: (context, state) => const Menu()),
    GoRoute(
      path: '/menu_items',
      builder: (context, state) => const MenuItems(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const Notifications(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const Profile()),
    GoRoute(
      path: '/items_details',
      builder: (context, state) => const ItemsDetails(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
  ],
);

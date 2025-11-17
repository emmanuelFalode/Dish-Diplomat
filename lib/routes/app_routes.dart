import 'package:foodapp/screens/Sign-in-up/forgot_password.dart';
import 'package:foodapp/screens/Sign-in-up/location.dart';
import 'package:foodapp/screens/Sign-in-up/signup.dart';
import 'package:foodapp/screens/Sign-in-up/verify_email.dart';
import 'package:foodapp/screens/bottombars/order.dart';
import 'package:foodapp/screens/cart/cart.dart';
import 'package:foodapp/screens/change_password/change_password.dart';
import 'package:foodapp/screens/checkout/checkout.dart';
import 'package:foodapp/screens/checkout/order_successful.dart';
import 'package:foodapp/screens/edit_profile/edit_profile.dart';
import 'package:foodapp/screens/menu/widget/items_details.dart';
import 'package:foodapp/screens/onboarding/onboarding.dart';
import 'package:foodapp/screens/splash_screen/splash1.dart';
import 'package:go_router/go_router.dart';
import 'package:foodapp/screens/splash_screen/splash_view.dart';
import 'package:foodapp/screens/bottombars/bottom_bar_page.dart';
import 'package:foodapp/screens/Sign-in-up/signin.dart';
import 'package:foodapp/screens/menu/menu.dart';
import 'package:foodapp/screens/menu/menu_items.dart';
import 'package:foodapp/screens/bottombars/contact.dart';
import 'package:foodapp/screens/bottombars/profile.dart';
import 'package:foodapp/screens/bottombars/home.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash1',
  // initialLocation: '/location',
  routes: [
    GoRoute(
      path: '/splash_view',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(path: '/splash1', builder: (context, state) => const Splash1()),
    GoRoute(
      path: '/verify_email',
      builder: (context, state) => const Verification(),
    ),
    GoRoute(path: '/', builder: (context, state) => const BottomBarPage()),
    // GoRoute(
    //   path: '/verification',
    //   builder: (context, state) => const Verification(),
    // ),
    GoRoute(path: '/cart', builder: (context, state) => const Cart()),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(path: '/signin', builder: (context, state) => const Signin()),
    GoRoute(
      path: '/bottom',
      builder: (context, state) => const BottomBarPage(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),

    GoRoute(
      path: '/order_successful',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map<String, dynamic>;
        final orderId = (extra['orderId'] as String?) ?? '—';
        final total = (extra['total'] as num?)?.toDouble();
        final eta = (extra['eta'] as int?) ?? 35;

        return OrderSuccessPage(
          orderId: orderId,
          total: total,
          etaMinutes: eta,
        );
      },
    ),

    GoRoute(path: '/location', builder: (context, state) => const Location()),
    GoRoute(path: '/menu', builder: (context, state) => const Menu()),
    GoRoute(path: '/cart', builder: (context, state) => const Cart()),
    GoRoute(path: '/signup', builder: (context, state) => const Signup()),
    GoRoute(
      path: '/change_password',
      builder: (context, state) => const ChangePasswordPage(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfilePage(),
    ),
    GoRoute(
      path: '/menu_items',
      builder: (context, state) => const MenuItems(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const CustomerCarePage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const Profile()),
    GoRoute(path: '/order', builder: (context, state) => const OrdersPage()),
    GoRoute(
      path: '/items_details',
      builder: (context, state) => const ItemsDetails(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
  ],
);

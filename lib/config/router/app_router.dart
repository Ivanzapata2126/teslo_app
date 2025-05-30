import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

final goRouteProvider = Provider(
  (ref) {
    final goRouterNotifier = ref.read(goRouterNotifierProvider);
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: goRouterNotifier,
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const CheckAuthStatusScreen(),
        ),

        ///* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),

        GoRoute(
          path: '/product/:id',
          builder: (context, state) => ProductScreen(productId: state.params['id'] ?? 'no-id',),
        ),

      ],
      redirect: (context, state) {
        final isGoingTo = state.subloc;
        final autStatus = goRouterNotifier.authStatus;

        if (isGoingTo == '/splash' && autStatus == AuthStatus.checking) return null;

        if (autStatus == AuthStatus.notAuthenticated) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;
          return '/login';
        }

        if (autStatus == AuthStatus.authenticated) {
          if (isGoingTo == '/login' ||
              isGoingTo == '/register' ||
              isGoingTo == '/splash') return '/';
        }
        return null;
      },
    );
  },
);

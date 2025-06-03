import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/ui/layout/layout_screen.dart';
import 'package:attend_app/ui/login_screen/login_screen_view.dart';
import 'package:flutter/material.dart';

import '../../ui/splash_screen/splash_screen.dart';

class RoutesGenerate {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PagesRoutes.splashScreen:
        return MaterialPageRoute(
            builder: (_) => const SplashScreen(), settings: settings);
      case PagesRoutes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => const LoginScreenView(), settings: settings);
      case PagesRoutes.layoutScreen:
        return MaterialPageRoute(
            builder: (context) => const LayoutScreen(), settings: settings);
      default:
        return unDefinedRoute();
    }
  }
}

Route<dynamic> unDefinedRoute() {
  return MaterialPageRoute(
    builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Un defined route"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Un defined route"),
        ),
      );
    },
  );
}

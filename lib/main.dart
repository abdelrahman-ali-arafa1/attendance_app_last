import 'package:attend_app/core/Services/theme_service.dart';
import 'package:attend_app/core/Utils/theme_manager.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import 'package:attend_app/ui/layout/layout_screen.dart';
import 'package:attend_app/ui/splash_screen/splash_screen.dart';
import 'package:attend_app/ui/login_screen/login_screen_view.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attend_app/ui/help_support/help_support_screen.dart';

// إنشاء GlobalKey للوصول إلى حالة MyApp من أي مكان
final GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  // تهيئة SharedPreferences
  await SharedPreferenceServices.init();

  // Get theme mode
  final themeService = ThemeService();
  final isDarkMode = await themeService.isDarkMode();

  runApp(MyApp(isDarkMode: isDarkMode, key: myAppKey));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  // دالة عامة للوصول إلى toggleTheme من أي مكان
  static void toggleTheme(BuildContext context) {
    myAppKey.currentState?.toggleTheme();
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    final isDark = !(_themeMode == ThemeMode.dark);
    await _themeService.setDarkMode(isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeNotifier(
      toggleTheme: toggleTheme,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Attendance App',
            debugShowCheckedModeBanner: false,
            theme: ThemeManager.getLightTheme(),
            darkTheme: ThemeManager.getDarkTheme(),
            themeMode: _themeMode,
            initialRoute: PagesRoutes.splashScreen,
            routes: {
              PagesRoutes.splashScreen: (context) => const SplashScreen(),
              PagesRoutes.layoutScreen: (context) => const LayoutScreen(),
              PagesRoutes.loginScreen: (context) => const LoginScreenView(),
              PagesRoutes.helpSupportScreen: (context) =>
                  const HelpSupportScreen(),
            },
            themeAnimationDuration: const Duration(milliseconds: 300),
            themeAnimationCurve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

class ThemeNotifier extends InheritedWidget {
  final Function toggleTheme;

  const ThemeNotifier({
    super.key,
    required this.toggleTheme,
    required Widget child,
  }) : super(child: child);

  static ThemeNotifier of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeNotifier>();
    assert(result != null, 'No ThemeNotifier found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeNotifier oldWidget) {
    return oldWidget.toggleTheme != toggleTheme;
  }
}

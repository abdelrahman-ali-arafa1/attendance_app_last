import 'dart:async';
import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _showElements = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        _showElements = true;
      });
    });

    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    final token = SharedPreferenceServices.getData(AppConstants.token);
    if (mounted) {
      if (token != null &&
          token.toString().isNotEmpty &&
          token.toString() != 'null') {
        Navigator.pushReplacementNamed(context, PagesRoutes.layoutScreen);
      } else {
        Navigator.pushReplacementNamed(context, PagesRoutes.loginScreen);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF2E3192),
                    Color(0xFF662D91),
                    Color(0xFF23ACA2),
                  ]
                : const [
                    Color(0xFF6A3DE8),
                    Color(0xFF5E3AD3),
                    Color(0xFF23ACA2),
                  ],
            stops: const [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated floating shapes
              ...List.generate(12, (index) {
                final size = 60.0 + (index % 3) * 30.0;
                final posX = (index % 4) * (screenSize.width / 4);
                final posY = (index ~/ 4) * (screenSize.height / 6) + 50.0;

                return Positioned(
                  left: posX,
                  top: posY,
                  child: AnimatedOpacity(
                    opacity: _showElements ? 0.2 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      width: _showElements ? size : 0,
                      height: _showElements ? size : 0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            index % 2 == 0 ? size : size / 4),
                        color: Colors.white.withAlpha(51),
                      ),
                    ),
                  ),
                );
              }),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo animation
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotateAnimation.value,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: screenSize.width * 0.35,
                              height: screenSize.width * 0.35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withAlpha(38)
                                    : Colors.white.withAlpha(51),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(26),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(screenSize.width * 0.035),
                              child: Hero(
                                tag: 'app_logo',
                                child: Image.asset(
                                  ImageAssets.appLogo,
                                  width: screenSize.width * 0.25,
                                  height: screenSize.width * 0.25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: screenSize.height * 0.05),

                    // Animated text elements
                    if (_showElements)
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withAlpha(204),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            "FCAI",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenSize.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: FontFamily.fontFamily,
                            ),
                          ),
                        ),
                      ),

                    if (_showElements)
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          "Attendance System",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: FontFamily.fontFamily,
                          ),
                        ),
                      ),

                    SizedBox(height: screenSize.height * 0.06),

                    // Modern loading indicator
                    if (_showElements)
                      FadeIn(
                        duration: const Duration(milliseconds: 1200),
                        child: _LoadingIndicator(size: screenSize.width * 0.15),
                      ),
                  ],
                ),
              ),

              // Bottom text
              if (_showElements)
                Positioned(
                  bottom: screenSize.height * 0.05,
                  left: 0,
                  right: 0,
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      "© 2023 FCAI Attendance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withAlpha(178),
                        fontFamily: FontFamily.fontFamily,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatefulWidget {
  final double size;

  const _LoadingIndicator({required this.size});

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _LoadingPainter(
              animation: _controller,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  const _LoadingPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final phase = (animation.value - (i / 8)) % 1.0;
      final opacity = (1.0 - phase) % 1.0;

      paint.color = color.withAlpha((opacity * 255).toInt());

      final x = center.dx + radius * 0.7 * math.cos(angle);
      final y = center.dy + radius * 0.7 * math.sin(angle);

      canvas.drawCircle(
        Offset(x, y),
        3 + (opacity * 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LoadingPainter oldDelegate) => true;
}

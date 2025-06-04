import 'package:animate_do/animate_do.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/Widget/custom_diaolg.dart';
import '../manager/scan_qr_cubit/scan_qr_state.dart';
import 'package:attend_app/di/injectable_initializer.dart';
import '../manager/scan_qr_cubit/scan_qr_view_model.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AttendanceCubit>()..startScanning(),
      child: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceErrorState) {
            DialogUtils.showMessage(
              context: context,
              message: state.errorMessage,
              title: "Error",
              postActionName: "OK",
            );
          }
        },
        builder: (context, state) {
          final viewModel = context.read<AttendanceCubit>();

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          // Header
                          _buildHeader(context),
                          SizedBox(height: 20.h),

                          // Main Content
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight -
                                  180.h, // Adjust as needed
                            ),
                            child: _buildContentBasedOnState(
                                context, state, viewModel),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageIcon(
              AssetImage(IconAssets.scanIcon),
              size: 24,
              color: ColorsManager.primaryColor,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "QR Scanner",
                  style: getTextStyle(
                    FontSize.s20,
                    FontWeightManager.semiBold,
                    Theme.of(context).brightness == Brightness.dark
                        ? ColorsManager.darkTextPrimary
                        : ColorsManager.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentBasedOnState(
      BuildContext context, AttendanceState state, AttendanceCubit viewModel) {
    if (state is ScanningState || state is AttendanceInitial) {
      return _buildScannerView(context);
    } else if (state is QRDetectedState) {
      return _buildQRDetectedView(context, state);
    } else if (state is SendingAttendanceState) {
      return _buildSendingView(context);
    } else if (state is AttendanceSuccessState) {
      return _buildSuccessView(context, state, viewModel);
    } else if (state is AttendanceErrorState) {
      return _buildErrorView(context, state, viewModel);
    }

    // Default fallback
    return _buildScannerView(context);
  }

  Widget _buildScannerView(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16.h),
          Text(
            "Place the QR code inside the frame",
            style: getTextStyle(
              FontSize.s16,
              FontWeightManager.medium,
              Theme.of(context).brightness == Brightness.dark
                  ? ColorsManager.darkTextPrimary
                  : ColorsManager.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // Scanner Container
          Container(
            height: 320.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: ColorsManager.primaryColor,
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Scanner View
                  Positioned.fill(
                    child: MobileScanner(
                      onDetect: (BarcodeCapture capture) {
                        final barcode = capture.barcodes.first;
                        final raw = barcode.rawValue;
                        if (raw != null) {
                          context.read<AttendanceCubit>().onQRScanned(raw);
                        }
                      },
                    ),
                  ),

                  // Scanner Overlay Animation
                  const AnimatedScannerOverlay(),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Info Card
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: ColorsManager.primaryColor,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scanning QR Code",
                          style: getTextStyle(
                            FontSize.s14,
                            FontWeightManager.semiBold,
                            Theme.of(context).brightness == Brightness.dark
                                ? ColorsManager.darkTextPrimary
                                : ColorsManager.lightTextPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Your attendance will be automatically recorded",
                          style: getTextStyle(
                            FontSize.s12,
                            FontWeightManager.regular,
                            Theme.of(context).brightness == Brightness.dark
                                ? ColorsManager.darkTextSecondary
                                : ColorsManager.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRDetectedView(BuildContext context, QRDetectedState state) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.network(
                    'https://lottie.host/8ce1cd0f-247f-4b40-bd09-411da8a60324/uJqEEcwH0n.json',
                    width: 180.w,
                    height: 180.h,
                    repeat: true,
                    frameRate: FrameRate.max,
                  ),
                  SizedBox(height: 20.h),
                  ZoomIn(
                    child: Text(
                      "QR Code Detected",
                      style: getTextStyle(
                        FontSize.s20,
                        FontWeightManager.bold,
                        Theme.of(context).brightness == Brightness.dark
                            ? ColorsManager.darkTextPrimary
                            : ColorsManager.lightTextPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FadeInUp(
                    child: Text(
                      "Processing your attendance...",
                      style: getTextStyle(
                        FontSize.s14,
                        FontWeightManager.medium,
                        Theme.of(context).brightness == Brightness.dark
                            ? ColorsManager.darkTextSecondary
                            : ColorsManager.lightTextSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.h),
          SizedBox(height: 20.h), // Keep some spacing
          Text(
            "Sending Attendance Data",
            style: getTextStyle(
              FontSize.s18,
              FontWeightManager.semiBold,
              Theme.of(context).brightness == Brightness.dark
                  ? ColorsManager.darkTextPrimary
                  : ColorsManager.lightTextPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Please wait a moment...",
              style: getTextStyle(
                FontSize.s14,
                FontWeightManager.medium,
                ColorsManager.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, AttendanceSuccessState state,
      AttendanceCubit viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Removed Lottie animation that was causing the 403 error
              // Lottie.network(
              //   'https://lottie.host/0a31b75d-a4b9-445f-af99-c532fb7e27a7/B49WtWSXl0.json',
              //   width: 180.w,
              //   height: 180.h,
              //   repeat: false,
              //   frameRate: FrameRate.max,
              // ),
              SizedBox(height: 20.h), // Keep some spacing
              FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  "Attendance Recorded!",
                  style: getTextStyle(
                    FontSize.s20,
                    FontWeightManager.bold,
                    ColorsManager.greenColor,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  "Your attendance has been successfully recorded",
                  style: getTextStyle(
                    FontSize.s14,
                    FontWeightManager.medium,
                    Theme.of(context).brightness == Brightness.dark
                        ? ColorsManager.darkTextSecondary
                        : ColorsManager.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.startScanning(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scan Again"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, AttendanceErrorState state,
      AttendanceCubit viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: ColorsManager.redColor,
                size: 80,
              ),
              SizedBox(height: 20.h),
              FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  "Error",
                  style: getTextStyle(
                    FontSize.s20,
                    FontWeightManager.bold,
                    ColorsManager.redColor,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              FadeInUp(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  state.errorMessage,
                  style: getTextStyle(
                    FontSize.s14,
                    FontWeightManager.medium,
                    Theme.of(context).brightness == Brightness.dark
                        ? ColorsManager.darkTextSecondary
                        : ColorsManager.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.startScanning(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Try Again"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Animated Scanner Overlay
class AnimatedScannerOverlay extends StatefulWidget {
  const AnimatedScannerOverlay({Key? key}) : super(key: key);

  @override
  State<AnimatedScannerOverlay> createState() => _AnimatedScannerOverlayState();
}

class _AnimatedScannerOverlayState extends State<AnimatedScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScannerOverlayPainter(
        animation: _animation,
        borderColor: ColorsManager.primaryColor,
        scanLineColor: ColorsManager.greenColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

// Custom Painter for Scanner Overlay
class ScannerOverlayPainter extends CustomPainter {
  final Animation<double>? animation;
  final Color borderColor;
  final Color scanLineColor;

  ScannerOverlayPainter({
    this.animation,
    required this.borderColor,
    required this.scanLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw corners
    final cornerSize = width * 0.1; // 10% of width for corner size
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // Top left corner
    canvas.drawLine(const Offset(0, 0), Offset(cornerSize, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerSize), paint);

    // Top right corner
    canvas.drawLine(Offset(width, 0), Offset(width - cornerSize, 0), paint);
    canvas.drawLine(Offset(width, 0), Offset(width, cornerSize), paint);

    // Bottom left corner
    canvas.drawLine(Offset(0, height), Offset(cornerSize, height), paint);
    canvas.drawLine(Offset(0, height), Offset(0, height - cornerSize), paint);

    // Bottom right corner
    canvas.drawLine(
        Offset(width, height), Offset(width - cornerSize, height), paint);
    canvas.drawLine(
        Offset(width, height), Offset(width, height - cornerSize), paint);

    // Draw scan line
    if (animation != null) {
      final scanLinePaint = Paint()
        ..color = scanLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Animated horizontal line
      final y = height * animation!.value;
      canvas.drawLine(Offset(0, y), Offset(width, y), scanLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}

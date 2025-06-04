import 'dart:convert';
import 'dart:io';
import 'package:attend_app/core/Services/theme_service.dart';
import 'package:attend_app/core/Utils/assets_manager.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:attend_app/core/Services/shared_preference_services.dart';
import 'package:attend_app/core/Utils/constant_manager.dart';
import 'package:attend_app/core/routes_manager/page_routes.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attend_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  String? userName;
  String? userEmail;
  String? profileImagePath;
  String? studentId;
  String? department;
  String? level;
  String? semester;
  int totalCourses = 0;
  double attendanceRate = 0.0;
  double absenceRate = 0.0;
  final ThemeService _themeService = ThemeService();
  final ImagePicker _imagePicker = ImagePicker();
  static const String _loginRoute = PagesRoutes.loginScreen;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCoursesAndAttendance();
  }

  Future<void> _loadUserData() async {
    setState(() {
      userName =
          SharedPreferenceServices.getData(AppConstants.userName)?.toString() ??
              "";
      userEmail = SharedPreferenceServices.getData(AppConstants.userEmail)
              ?.toString() ??
          "";
      profileImagePath =
          SharedPreferenceServices.getData(AppConstants.profileImage)
              ?.toString();
      studentId = SharedPreferenceServices.getData(AppConstants.studentId)
              ?.toString() ??
          "";

      // Try to load department, level, and semester if they exist
      department = SharedPreferenceServices.getData('department')?.toString();
      level = SharedPreferenceServices.getData('level')?.toString();
      semester = SharedPreferenceServices.getData('semester')?.toString();
    });
  }

  Future<void> _loadCoursesAndAttendance() async {
    try {
      // Load courses list
      final coursesJson =
          SharedPreferenceServices.getData('coursesList')?.toString();
      if (coursesJson != null) {
        final coursesData = jsonDecode(coursesJson) as List;
        totalCourses = coursesData.length;
      }

      // Load attendance stats if available
      final attendanceSummaryJson =
          SharedPreferenceServices.getData('attendanceSummary')?.toString();
      if (attendanceSummaryJson != null) {
        final attendanceData = jsonDecode(attendanceSummaryJson);
        final present = attendanceData['present'] as int? ?? 0;
        final absent = attendanceData['absent'] as int? ?? 0;
        final total = present + absent;

        if (total > 0) {
          attendanceRate = (present / total) * 100;
          absenceRate = (absent / total) * 100;
        }
      } else {
        // Default values if no attendance data
        attendanceRate = 85.0;
        absenceRate = 15.0;
      }
    } catch (e) {
      debugPrint('Error loading courses and attendance: $e');
      // Default values
      totalCourses = 5;
      attendanceRate = 85.0;
      absenceRate = 15.0;
    }

    setState(() {});
  }

  Future<bool> _requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) return false;
    }
    final storageStatus = await Permission.photos.request();
    if (!storageStatus.isGranted) {
      // fallback for Android
      final filesStatus = await Permission.storage.request();
      if (!filesStatus.isGranted) return false;
    }
    return true;
  }

  Future<void> _pickImage() async {
    try {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a Photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final hasPermission = await _requestPermissions(source);
        if (!hasPermission) {
          if (!mounted) return;
          // Use ScaffoldMessenger.maybeOf to avoid BuildContext issues
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(
              content: Text('Please grant the required permissions.'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        final XFile? image = await _imagePicker.pickImage(
          source: source,
          imageQuality: 70,
        );
        if (!mounted) return;

        if (image != null) {
          // Store file path before async operations
          final String imagePath = image.path;
          await SharedPreferenceServices.saveData(
              AppConstants.profileImage, imagePath);
          // Check if still mounted before calling setState
          if (!mounted) return;
          setState(() {
            profileImagePath = imagePath;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (!mounted) return;
      // Use ScaffoldMessenger.maybeOf to avoid BuildContext issues
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please check app permissions.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _logout(BuildContext context) {
    // Perform synchronous operations
    SharedPreferenceServices.deleteData(AppConstants.token);
    SharedPreferenceServices.deleteData(AppConstants.studentId);
    SharedPreferenceServices.deleteData(AppConstants.userName);
    SharedPreferenceServices.deleteData(AppConstants.userEmail);
    // Keep the profile image to persist between sessions

    // Navigate immediately (synchronously)
    Navigator.of(context)
        .pushNamedAndRemoveUntil(_loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? Colors.black12 : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    // Profile Image and Info
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsManager.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      ColorsManager.primaryColor.withAlpha(26),
                                  child: profileImagePath != null
                                      ? ClipOval(
                                          child: Image.file(
                                            File(profileImagePath!),
                                            width: 92,
                                            height: 92,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 46,
                                          backgroundImage:
                                              AssetImage(ImageAssets.appLogo),
                                          backgroundColor: Colors.white,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ColorsManager.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.black12
                                            : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName?.isNotEmpty == true
                                ? userName!
                                : "User Name",
                            style: getTextStyle(
                              FontSize.s20,
                              FontWeightManager.bold,
                              isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail?.isNotEmpty == true
                                ? userEmail!
                                : "user@email.com",
                            style: getTextStyle(
                              FontSize.s14,
                              FontWeightManager.medium,
                              isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          if (studentId != null && studentId!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "ID: $studentId",
                                style: getTextStyle(
                                  FontSize.s14,
                                  FontWeightManager.medium,
                                  isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),

                    // Quick Stats
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickStat(
                              "Total Courses",
                              totalCourses.toString(),
                              Icons.book,
                              isDark,
                            ),
                            _buildQuickStat(
                              "Attendance",
                              "${attendanceRate.toStringAsFixed(1)}%",
                              Icons.check_circle,
                              isDark,
                            ),
                            _buildQuickStat(
                              "Absences",
                              "${absenceRate.toStringAsFixed(1)}%",
                              Icons.warning,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Account Section
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: _buildSection(
                        "Account",
                        [
                          _buildMenuItem(
                            context,
                            icon: Icons.person_outline,
                            title: "Personal Information",
                            subtitle: "Manage your personal details",
                            onTap: () {
                              _showPersonalInfoDialog(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.school_outlined,
                            title: "Academic Details",
                            subtitle: "View your academic information",
                            onTap: () {
                              _showAcademicDetailsDialog(context);
                            },
                          ),
                        ],
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Settings Section
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: _buildSection(
                        "Settings",
                        [
                          _buildMenuItem(
                            context,
                            icon: isDark ? Icons.dark_mode : Icons.light_mode,
                            title: "Dark Mode",
                            subtitle: isDark
                                ? "Switch to light mode"
                                : "Switch to dark mode",
                            isSwitch: true,
                            switchValue: isDark,
                            onSwitchChanged: (value) {
                              // Make this synchronous by removing async/await
                              _themeService.setDarkMode(value);
                              MyApp.toggleTheme(context);
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.notifications_outlined,
                            title: "Notifications",
                            subtitle: "Manage your notifications",
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.security_outlined,
                            title: "Security",
                            subtitle: "Password and security settings",
                            onTap: () {},
                          ),
                        ],
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // About Section
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: _buildSection(
                        "About",
                        [
                          _buildMenuItem(
                            context,
                            icon: Icons.help_outline,
                            title: "Help & Support",
                            subtitle: "Get help with the app",
                            onTap: () => Navigator.pushNamed(
                              context,
                              PagesRoutes.helpSupportScreen,
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.info_outline,
                            title: "About App",
                            subtitle: "Version 1.0.0",
                            onTap: () {},
                          ),
                        ],
                        isDark,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Logout Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _logout(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFFFF5252),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.logout),
                          label: Text(
                            "Logout",
                            style: getTextStyle(
                              FontSize.s16,
                              FontWeightManager.medium,
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(
      String title, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.black26 : ColorsManager.primaryColor.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: ColorsManager.primaryColor,
            size: 24,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: getTextStyle(
              FontSize.s18,
              FontWeightManager.bold,
              isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: getTextStyle(
              FontSize.s12,
              FontWeightManager.medium,
              isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: getTextStyle(
                FontSize.s18,
                FontWeightManager.bold,
                isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool isSwitch = false,
    bool? switchValue,
    Function(bool)? onSwitchChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white12 : Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: ColorsManager.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      FontSize.s16,
                      FontWeightManager.medium,
                      isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: getTextStyle(
                        FontSize.s12,
                        FontWeightManager.regular,
                        isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSwitch)
              Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
                activeColor: ColorsManager.primaryColor,
                activeTrackColor: ColorsManager.primaryColor.withAlpha(77),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white54 : Colors.black54,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  // Edit Personal Info Dialog
  void _showPersonalInfoDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);
    final idController = TextEditingController(text: studentId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Personal Information',
          style: getTextStyle(
            FontSize.s18,
            FontWeightManager.bold,
            isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
                readOnly: true, // Cannot be edited
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                readOnly: true, // Cannot be edited
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  icon: Icon(Icons.numbers),
                ),
                readOnly: true, // Cannot be edited
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeightManager.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Academic Details Dialog
  void _showAcademicDetailsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Academic Details',
          style: getTextStyle(
            FontSize.s18,
            FontWeightManager.bold,
            isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAcademicDetailItem(
                icon: Icons.school,
                label: 'Department',
                value: department ?? 'Computer Science',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildAcademicDetailItem(
                icon: Icons.trending_up,
                label: 'Level',
                value: level ?? '4',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildAcademicDetailItem(
                icon: Icons.calendar_today,
                label: 'Semester',
                value: semester ?? '8',
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildAcademicDetailItem(
                icon: Icons.book,
                label: 'Total Courses',
                value: totalCourses.toString(),
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildAcademicDetailItem(
                icon: Icons.check_circle,
                label: 'Attendance Rate',
                value: '${attendanceRate.toStringAsFixed(1)}%',
                isDark: isDark,
                valueColor: Colors.green,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: ColorsManager.primaryColor,
                fontWeight: FontWeightManager.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: ColorsManager.primaryColor,
          size: 22,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getTextStyle(
                  FontSize.s14,
                  FontWeightManager.medium,
                  isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: getTextStyle(
                  FontSize.s16,
                  FontWeightManager.bold,
                  valueColor ?? (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

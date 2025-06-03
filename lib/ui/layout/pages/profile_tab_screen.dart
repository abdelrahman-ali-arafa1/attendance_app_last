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
  bool _isDarkMode = false;
  final ThemeService _themeService = ThemeService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final isDark = await _themeService.isDarkMode();
    setState(() {
      _isDarkMode = isDark;
    });
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
    });
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
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please grant the required permissions.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
        final XFile? image = await _imagePicker.pickImage(
          source: source,
          imageQuality: 70,
        );
        if (image != null) {
          await SharedPreferenceServices.saveData(
              AppConstants.profileImage, image.path);
          setState(() {
            profileImagePath = image.path;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to pick image. Please check app permissions.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _logout(BuildContext context) async {
    await SharedPreferenceServices.deleteData(AppConstants.token);
    await SharedPreferenceServices.deleteData(AppConstants.studentId);
    await SharedPreferenceServices.deleteData(AppConstants.userName);
    await SharedPreferenceServices.deleteData(AppConstants.userEmail);

    // يمكنك حذف أي بيانات إضافية هنا
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, PagesRoutes.loginScreen, (route) => false);
    }
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
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    // Profile Image and Info
                    FadeInDown(
                      duration: Duration(milliseconds: 500),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsManager.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: ColorsManager.primaryColor
                                      .withOpacity(0.1),
                                  child: profileImagePath != null
                                      ? ClipOval(
                                          child: Image.file(
                                            File(profileImagePath!),
                                            width: 92,
                                            height: 92,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : CircleAvatar(
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
                                    padding: EdgeInsets.all(8),
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
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(height: 4),
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
                          SizedBox(height: 24),
                        ],
                      ),
                    ),

                    // Quick Stats
                    FadeInUp(
                      duration: Duration(milliseconds: 600),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickStat(
                              "Total Courses",
                              "5",
                              Icons.book,
                              isDark,
                            ),
                            _buildQuickStat(
                              "Attendance",
                              "85%",
                              Icons.check_circle,
                              isDark,
                            ),
                            _buildQuickStat(
                              "Absences",
                              "15%",
                              Icons.warning,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Account Section
                    FadeInUp(
                      duration: Duration(milliseconds: 700),
                      child: _buildSection(
                        "Account",
                        [
                          _buildMenuItem(
                            context,
                            icon: Icons.person_outline,
                            title: "Personal Information",
                            subtitle: "Manage your personal details",
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.school_outlined,
                            title: "Academic Details",
                            subtitle: "View your academic information",
                            onTap: () {},
                          ),
                        ],
                        isDark,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Settings Section
                    FadeInUp(
                      duration: Duration(milliseconds: 800),
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
                            onSwitchChanged: (value) async {
                              await _themeService.setDarkMode(value);
                              setState(() {
                                _isDarkMode = value;
                              });
                              if (mounted) {
                                MyApp.toggleTheme(context);
                              }
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

                    SizedBox(height: 16),

                    // About Section
                    FadeInUp(
                      duration: Duration(milliseconds: 900),
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

                    SizedBox(height: 24),

                    // Logout Button
                    FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _logout(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFFF5252),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(Icons.logout),
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

                    SizedBox(height: 40),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black26
            : ColorsManager.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: ColorsManager.primaryColor,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: getTextStyle(
              FontSize.s18,
              FontWeightManager.bold,
              isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 4),
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
            padding: EdgeInsets.all(16),
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: ColorsManager.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
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
                    SizedBox(height: 2),
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
                activeTrackColor: ColorsManager.primaryColor.withOpacity(0.3),
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
}

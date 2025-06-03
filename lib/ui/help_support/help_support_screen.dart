import 'package:flutter/material.dart';
import 'package:attend_app/core/Utils/colors_manager.dart';
import 'package:attend_app/core/Utils/font_manager.dart';
import 'package:attend_app/core/Utils/style_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: getTextStyle(
            FontSize.s20,
            FontWeightManager.semiBold,
            isDark ? Colors.white : Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Support Section
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: _buildContactSupport(context, isDark),
              ),
              SizedBox(height: 24.h),

              // FAQ Section
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: _buildFAQSection(context, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Support',
            style: getTextStyle(
              FontSize.s18,
              FontWeightManager.bold,
              isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          _buildContactItem(
            context,
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'abdelra7manaliarafa@gmail.com',
            isDark: isDark,
            onTap: () {
              // TODO: Implement email launch
            },
          ),
          Divider(color: isDark ? Colors.white24 : Colors.grey.shade200),
          _buildContactItem(
            context,
            icon: Icons.phone_outlined,
            title: 'Phone',
            subtitle: '+20 1093838989',
            isDark: isDark,
            onTap: () {
              // TODO: Implement phone call
            },
          ),
          Divider(color: isDark ? Colors.white24 : Colors.grey.shade200),
          _buildContactItem(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Available 24/7',
            isDark: isDark,
            onTap: () {
              // TODO: Implement live chat
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions',
            style: getTextStyle(
              FontSize.s18,
              FontWeightManager.bold,
              isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          _buildFAQItem(
            context,
            'How do I mark my attendance?',
            'You can mark your attendance by scanning the QR code provided by your instructor during class.',
            isDark,
          ),
          _buildFAQItem(
            context,
            'What if I forget to mark my attendance?',
            'Contact your instructor immediately if you forget to mark your attendance. They can help you resolve the issue.',
            isDark,
          ),
          _buildFAQItem(
            context,
            'How can I view my attendance history?',
            'Go to the dashboard and check the attendance section to view your complete attendance history.',
            isDark,
          ),
          _buildFAQItem(
            context,
            'What is the minimum attendance requirement?',
            'The minimum attendance requirement is typically 75%, but this may vary by course and institution.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
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
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: getTextStyle(
                      FontSize.s14,
                      FontWeightManager.regular,
                      isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildFAQItem(
    BuildContext context,
    String question,
    String answer,
    bool isDark,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: getTextStyle(
            FontSize.s16,
            FontWeightManager.medium,
            isDark ? Colors.white : Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              answer,
              style: getTextStyle(
                FontSize.s14,
                FontWeightManager.regular,
                isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
        iconColor: ColorsManager.primaryColor,
        collapsedIconColor: isDark ? Colors.white54 : Colors.black54,
      ),
    );
  }
}

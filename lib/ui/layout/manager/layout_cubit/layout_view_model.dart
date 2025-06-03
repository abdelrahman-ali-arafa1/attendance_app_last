import 'package:attend_app/ui/layout/manager/layout_cubit/layout_state.dart';
import 'package:attend_app/ui/layout/pages/attendance_tab_screen.dart';
import 'package:attend_app/ui/layout/pages/profile_tab_screen.dart';
import 'package:attend_app/ui/layout/pages/scan_teb_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutViewModel extends Cubit<LayoutState> {
  LayoutViewModel() : super(InitialLayoutState());
  int currentIndex = 0;
  List<Widget> tabs = [
    const AttendanceTabScreen(),
    const ScanQrScreen(),
    const ProfileTabScreen()
  ];
  void changeTab(int index) {
    emit(InitialLayoutState());
    currentIndex = index;
    emit(ChangeTabState());
  }
}

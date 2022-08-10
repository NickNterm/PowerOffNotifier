import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:power_off_notifier/constants/colors.dart';
import 'package:power_off_notifier/pages/main/main_screen.dart';
import 'package:power_off_notifier/providers/department_announcements.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) async {
      if (pref.getString("department") != null) {
        bool isDepartmentAnnouncementsRead =
            await Provider.of<DepartmentAnnouncementsController>(context,
                    listen: false)
                .getAnnouncementsFromDepartment(pref.getString("department")!);
        if (isDepartmentAnnouncementsRead) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
          );
        }
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("department", "ΙΩΑΝΝΙΝΩΝ");
        bool isDepartmentAnnouncementsRead =
            await Provider.of<DepartmentAnnouncementsController>(context,
                    listen: false)
                .getAnnouncementsFromDepartment("ΙΩΑΝΝΙΝΩΝ");
        if (isDepartmentAnnouncementsRead) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/logo/icon.png",
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Power Off Notifier",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const SpinKitThreeBounce(
                  color: kPrimaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

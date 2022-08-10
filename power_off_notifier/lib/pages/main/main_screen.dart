import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:power_off_notifier/constants/colors.dart';
import 'package:power_off_notifier/constants/variables.dart';
import 'package:power_off_notifier/models/announcement.dart';
import 'package:power_off_notifier/providers/department_announcements.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/announcement_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedDepartement = "ΙΩΑΝΝΙΝΩΝ";
  @override
  void initState() {
    super.initState();
    readDepartment();
  }

  void readDepartment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      selectedDepartement = pref.getString("department")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(title: const Text("Power Off Notifier")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: kElevatedColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BoldText(text: "Νομός "),
                  DropdownButton(
                    value: selectedDepartement,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: departements.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      Provider.of<DepartmentAnnouncementsController>(context,
                              listen: false)
                          .getAnnouncementsFromDepartment(newValue!);
                      setState(() {
                        SharedPreferences.getInstance().then(
                            (pref) => pref.setString("department", newValue));
                        selectedDepartement = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Consumer<DepartmentAnnouncementsController>(
              builder: (context, value, child) {
                if (value.announcements != null) {
                  if (value.announcements!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: value.announcements!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Announcement announcement = value.announcements![index];
                        return AnnouncementCard(announcement: announcement);
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(height: 50),
                        Icon(
                          Icons.content_paste,
                          size: 75,
                        ),
                        SizedBox(height: 20),
                        Text("Δεν βρέθηκαν ανακοινώσεις")
                      ],
                    );
                  }
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(30),
                    child: SpinKitRing(
                      color: kPrimaryColor,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

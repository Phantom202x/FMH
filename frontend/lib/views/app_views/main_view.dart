import 'package:app/components/user_card.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/services/face_scan_services.dart';
import 'package:app/services/notification_services.dart';
import 'package:app/services/report_services.dart';
import 'package:app/models/report_models.dart';
import 'package:app/views/report_views/report_list_view.dart';
import 'package:app/views/settings_views/settings_view.dart';
import 'package:app/views/face_scan_views/face_scan_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainAppView extends StatefulWidget {
  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  final userData = AuthServices().getUserInfos();

  final _notifStream = NotificationServices().reportsNotifications();
  int _counter = 0;
  var notifBuffer = {};

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _notifStream,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.isNotEmpty &&
            snapshot.data!.last != notifBuffer) {
          DateTime now = DateTime.now();
          var diff =
              now.difference(DateTime.parse(snapshot.data!.last["created_at"]));

          if (diff.inHours < 5) {
            _counter++;
            NotificationServices().showNotification(
              context: context,
              size: size,
              id: 0,
              title: l10n.alert_notif_title,
              body: l10n.alert_notif_msg,
              data: snapshot.data!.last,
            );
            notifBuffer = snapshot.data!.last;
          }
        }
        return Scaffold(
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 227, 238, 240),
                    Color.fromARGB(255, 227, 238, 240),
                    Color.fromARGB(255, 243, 243, 243)
                  ],
                ),
              ),
              child: ListView(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo/Layer_1.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const Spacer(),
                        Stack(
                          children: [
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: IconButton(
                                onPressed: () async {
                                  await ReportServices()
                                      .getReports()
                                      .then((value) {
                                    List<Report> reports = [];
                                    for (var report in value) {
                                      reports.add(Report(
                                        fullName: report["full_name"],
                                        phone:
                                            (report["phone_number"]).toString(),
                                        nationality: report["nationality"],
                                        author: report["author"],
                                      ));
                                    }
                                    setState(() {
                                      _counter = 0;
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ReportListView(
                                          reports: reports,
                                        ),
                                      ),
                                    );
                                  });
                                },
                                icon: Icon(Icons.notifications_outlined),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(170, 255, 255, 255),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    '$_counter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SettingsView(),
                                ),
                              );
                            },
                            icon: Icon(Icons.tune_outlined),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(170, 255, 255, 255),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${l10n.hi} ${userData["full_name"]}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      l10n.welcome_message,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 30),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double totalWidth = constraints.maxWidth - 32;
                      double spacing = 15;
                      double cardSize = (totalWidth - spacing) / 2;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cards
                          // First Card
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                            child: SizedBox(
                              width: cardSize - 20,
                              height: cardSize - 20,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Icon(Icons.error,
                                          color: Colors.green),
                                      content: Text(
                                        l10n.report_confirmation,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    Size(cardSize * .8, 56)),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey[800]),
                                          ),
                                          child: Text(l10n.no),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.of(context)
                                                .pushNamed("report");
                                          },
                                          style: ButtonStyle(
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    Size(cardSize * .8, 56)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Text(l10n.yes),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5)),
                                              ],
                                            ),
                                            width: 40,
                                            height: 30,
                                            child: Icon(
                                                Icons.person_outline_rounded,
                                                color: Colors.green,
                                                size: 28),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: AutoSizeText(
                                        maxLines: 2,
                                        l10n.cant_find_hadj,
                                        style: TextStyle(
                                            fontSize: 6,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Second Card
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                            child: SizedBox(
                              width: cardSize - 20,
                              height: cardSize - 20,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () async {
                                  await FaceScanServices()
                                      .getImageFromCamera()
                                      .then((value) {
                                    if (value == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(l10n.no_image_taken)),
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FaceScanView(image: value)),
                                    );
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5)),
                                              ],
                                            ),
                                            width: 40,
                                            height: 30,
                                            child: Icon(
                                                Icons.person_outline_rounded,
                                                color: Colors.blue,
                                                size: 28),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: AutoSizeText(
                                        maxLines: 2,
                                        l10n.found_hadj,
                                        style: TextStyle(
                                            fontSize: 6,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // End cards
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportListView(reports: []),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Latest Report',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  UserCard(
                    name: userData['full_name'],
                    nationality: userData['full_name'],
                    image:
                        userData['image'] ?? 'assets/images/default_avatar.png',
                    status: 'missing',
                    age: userData?['age'] ?? 60,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FaceScanServices()
                            .getImageFromCamera()
                            .then((value) {
                          if (value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.no_image_taken)),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FaceScanView(image: value)),
                          );
                        });
                      },
                      child: AutoSizeText(
                        l10n.scan_face,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}




















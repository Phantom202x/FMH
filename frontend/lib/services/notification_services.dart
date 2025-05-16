import 'package:app/l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/views/report_views/full_report_view.dart';

class NotificationServices {
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInit = false;
  bool get isInit => _isInit;

  Future<void> init() async {
    if (_isInit) return;
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("mipmap/ic_launcher");

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationPlugin.initialize(initializationSettings);
    _isInit = true;
  }

  NotificationDetails getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        color: Colors.green,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    context,
    size,
    int id = 0,
    String? title,
    String? body,
    String? payload,
    Map data = const {},
  }) async {
    final reportId = data["id"].toString();
    if (await _wasNotified(reportId)) return;

    await _markAsNotified(reportId);

    await notificationPlugin.show(
      id,
      title,
      body,
      getNotificationDetails(),
      payload: payload,
    );

    final l10n = AppLocalizations.of(context)!;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      barrierColor: Colors.black54,
      pageBuilder: (context, _, __) {
        return Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
              padding: const EdgeInsets.all(16),
              width: size.width,
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/logo/logo.png",
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AutoSizeText(
                          l10n.notification,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        width: 8,
                        height: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        DateTime.parse(data["created_at"])
                            .toLocal()
                            .toString()
                            .split(".")[0],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: Colors.grey,
                          fontFamily: "Poppins",
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AutoSizeText(
                    l10n.missging_person_reported,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 4),
                  AutoSizeText(
                    "${l10n.name}: ${data["full_name"] ?? ""}, ${l10n.nationality}: ${data["nationality"] ?? ""}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FullReportView(data: data),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Colors.green),
                      ),
                      child: AutoSizeText(
                        l10n.open_full_report,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(
            Tween<Offset>(
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
            ),
          ),
          child: child,
        );
      },
    );
  }

  reportsNotifications() {
    var supabase = Supabase.instance.client;
    return supabase.from("Reports").stream(primaryKey: ["id"]);
  }

  Future<bool> _wasNotified(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notified_$id") ?? false;
  }

  Future<void> _markAsNotified(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notified_$id", true);
  }
}












// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:app/views/report_views/full_report_view.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class NotificationServices {
//   final notificationPlugin = FlutterLocalNotificationsPlugin();
//   bool _isInit = false;
//   bool get isInit => _isInit;

//   Future<void> init() async {
//     if (_isInit) return;
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings("mipmap/ic_launcher");

//     DarwinInitializationSettings initializationSettingsIOS =
//         const DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await notificationPlugin.initialize(initializationSettings);
//     _isInit = true;
//   }

//   NotificationDetails getNotificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         channelDescription: 'channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//         color: Colors.green,
//       ),
//       iOS: DarwinNotificationDetails(),
//     );
//   }

//   Future<void> showNotification({
//     context,
//     size,
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//     Map data = const {},
//   }) async {
//     await notificationPlugin.show(
//       id,
//       title,
//       body,
//       getNotificationDetails(),
//       payload: payload,
//     );

//     final l10n = AppLocalizations.of(context)!;

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: "Close",
//       barrierColor: Colors.black54,
//       pageBuilder: (context, _, __) {
//         return Column(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               margin: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
//               padding: const EdgeInsets.all(16),
//               width: size.width,
//               height: 220,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset(
//                         "assets/logo/logo.png",
//                         width: 50,
//                         height: 50,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: AutoSizeText(
//                           l10n.notification,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             decoration: TextDecoration.none,
//                             color: Colors.black,
//                             fontFamily: "Poppins",
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         width: 8,
//                         height: 8,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       AutoSizeText(
//                         DateTime.parse(data["created_at"])
//                             .toLocal()
//                             .toString()
//                             .split(".")[0],
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.normal,
//                           decoration: TextDecoration.none,
//                           color: Colors.grey,
//                           fontFamily: "Poppins",
//                         ),
//                         textAlign: TextAlign.end,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   AutoSizeText(
//                     l10n.missging_person_reported,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal,
//                       decoration: TextDecoration.none,
//                       color: Colors.grey,
//                       fontFamily: "Poppins",
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   AutoSizeText(
//                     "${l10n.name}: ${data["full_name"] ?? ""}, ${l10n.nationality}: ${data["nationality"] ?? ""}",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal,
//                       decoration: TextDecoration.none,
//                       color: Colors.grey,
//                       fontFamily: "Poppins",
//                     ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 30,
//                     child: FilledButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => FullReportView(data: data),
//                           ),
//                         );
//                       },
//                       style: ButtonStyle(
//                         backgroundColor:
//                             const WidgetStatePropertyAll(Colors.green),
//                       ),
//                       child: AutoSizeText(
//                         l10n.open_full_report,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return SlideTransition(
//           position: CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeOut,
//           ).drive(
//             Tween<Offset>(
//               begin: const Offset(0, -1),
//               end: const Offset(0, 0),
//             ),
//           ),
//           child: child,
//         );
//       },
//     );
//   }

//   reportsNotifications() {
//     var supabase = Supabase.instance.client;
//     return supabase.from("Reports").stream(primaryKey: ["id"]);
//   }
// }

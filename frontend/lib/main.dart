import 'package:app/services/auth_services.dart';
import 'package:app/services/notification_services.dart';
import 'package:app/services/settings_services.dart';
import 'package:app/viewmodels/app_viewmodels/app_bloc.dart';
import 'package:app/viewmodels/face_scan_viewmodels/face_scan_bloc.dart';
import 'package:app/viewmodels/auth_viewmodels/auth_bloc.dart';
import 'package:app/viewmodels/settings_viewmodels/settings_bloc.dart';
import 'package:app/views/app_views/responsive_view.dart';
import 'package:app/views/auth_views/admin_login_view.dart';
import 'package:app/views/auth_views/guest_login_view.dart';
import 'package:app/views/auth_views/welcome_view.dart';
import 'package:app/views/report_views/report_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    //url: SupabaseConstants.supabaseUrl,
    //anonKey: SupabaseConstants.supabaseKey,
    // url:"https://ncwzdzlcwuqqpzxyhrtl.supabase.co",
    // anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jd3pkemxjd3VxcXB6eHlocnRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQzNTgwNTMsImV4cCI6MjA1OTkzNDA1M30.ILY1kDXcH0kiO2Z_cJrIMIDRfULUxOENhK6jLY_7jhk"
    
    url:"https://pafrlirbdezfaloemgxg.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBhZnJsaXJiZGV6ZmFsb2VtZ3hnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwMDk4MzIsImV4cCI6MjA2MDU4NTgzMn0.gXO_hRuznX1wFNBCnElcOiWthZ93t-cVWeQGOYZw6j4"
  );
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            AuthServices(),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(SettingsServices())
            ..add(
              SettingsInitialEvent(),
            ),
        ),
        BlocProvider(
          create: (context) => FaceScanBloc(),
        )
      ],
      child: BlocBuilder<SettingsBloc, Map>(
        builder: (context, settings) => MaterialApp(
          title: 'FMH',
          debugShowCheckedModeBanner: false,
          locale: settings['language'],
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            fontFamily: "Poppins",
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          initialRoute: "auth",
          routes: {
            "/": (context) => const WelcomeView(),
            "login": (context) => const AdminLoginView(),
            "register": (context) => const GuestLoginView(),
            "app": (context) => const ResponsiveView(),
            "report": (context) => const ReportCreationView(),
          },
        ),
      ),
    );
  }
}

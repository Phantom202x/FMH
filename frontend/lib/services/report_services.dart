import 'package:app/models/report_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportServices {
  // reports
  Future getReports() {
    var supabase = Supabase.instance.client;

    var response = supabase.from("Reports").select();
    return response;
  }

  Future createReport(Report report) async {
    var supabase = Supabase.instance.client;

    var response = await supabase.from("Reports").insert(
          report.serialize(),
        );
    return response;
  }

  reportsNotifications() {
    var supabase = Supabase.instance.client;

    var response = supabase.from("Reports").stream(primaryKey: ["id"]);
    return response;
  }
}

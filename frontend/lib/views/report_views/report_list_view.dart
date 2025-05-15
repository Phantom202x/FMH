import 'package:app/models/report_models.dart';
import 'package:app/views/app_views/main_view.dart';
import 'package:app/views/report_views/report_element_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportListView extends StatefulWidget {
  final List<Report> reports;
  const ReportListView({required this.reports, super.key});

  @override
  State<ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends State<ReportListView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const MainAppView()),
            );
          },
        ),
        title: Text(
          l10n.back,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: Container(
            margin: const EdgeInsets.all(18),
            child: Text(
              //"${widget.reports.length} reports",
              l10n.notifications,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.reports.length,
        itemBuilder: (context, index) {
          return ReportViewElement(report: widget.reports[index]);
        },
      ),
    );
  }
}

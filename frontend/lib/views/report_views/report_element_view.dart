import 'package:app/models/report_models.dart';
import 'package:app/views/report_views/full_report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportViewElement extends StatelessWidget {
  final Report report;
  const ReportViewElement({required this.report, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      width: size.width,
      height: 260,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              CircleAvatar(
                radius: 36,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${l10n.missing_person_alert}\n",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontFamily: "Poppins",
                        ),
                      ),
                      TextSpan(
                        text: l10n.date,
                        style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          color: Colors.black54,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(
            l10n.missging_person_reported,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              color: Colors.grey,
              fontFamily: "Poppins",
            ),
          ),
          Text(
            "${l10n.name}: ${report.fullName}, ${l10n.nationality}: ${report.nationality}, ${l10n.phone} : ${report.phone}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
              color: Colors.grey,
              fontFamily: "Poppins",
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FullReportView(
                    data: report.serialize(),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
              fixedSize: WidgetStatePropertyAll(
                Size(size.width - 32, 50),
              ),
            ),
            child: Text(l10n.open_full_report),
          ),
        ],
      ),
    );
  }
}

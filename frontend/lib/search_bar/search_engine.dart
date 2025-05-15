
import 'package:app/components/user_card.dart';
import 'package:app/services/auth_services.dart';
import 'package:app/services/report_services.dart';
import 'package:flutter/material.dart';
import 'package:app/models/report_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchEngine extends StatefulWidget {
  final String fullname;
  final String nationality;
  final String phonenumber;

  const SearchEngine({
    required this.fullname,
    required this.nationality,
    required this.phonenumber,
    super.key,
  });

  @override
  State<SearchEngine> createState() => _SearchEngineState();
}

class _SearchEngineState extends State<SearchEngine> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<dynamic> _matchedUsers = [];
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    _verifyUserByName();
  }

  Future<void> _verifyUserByName() async {
    setState(() => _isLoading = true);
    
    try {
      final allUsers = await supabase.from('Hadj').select('full_name, age ,nationality');

      _matchedUsers = allUsers.where((user) {
        final name = (user['full_name'] ?? '').toString().toLowerCase().trim();
        return name == widget.fullname.toLowerCase().trim();
      }).toList();
    } catch (e) {
      debugPrint("Error verifying user: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _submitReport() async {
    try {
      final currentUser = await AuthServices().getUserInfos();

      final report = Report(
        author: currentUser["full_name"],
        fullName: widget.fullname,
        phone: widget.phonenumber,
        nationality: widget.nationality,
      );

      await ReportServices().createReport(report);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating report: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    //Future<List<Map<String, dynamic>>> Alluser= AuthServices().getUserInfos();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search Hadjs'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [Color(0xFF00CC99), Color(0xFF00BFFF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                        ),
                      )
                    : _matchedUsers.isEmpty
                        ? const Center(child: Text("No matching Hadj found."))
                        : ListView.builder(
                            itemCount: _matchedUsers.length,
                            itemBuilder: (context, index) {
                              final user = _matchedUsers[index];
                              final fullName = user['full_name'];
                              final nationality = user['nationality'];

                              return GestureDetector(
                                onTap: _submitReport,
                                child: UserCard(
                                  name: fullName,
                                  nationality: nationality,
                                  status: 'missing 4h ago',
                                  age:int.parse( user['age']),
                                  image: user['image'] ??'assets/images/default_avatar.png',
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


















































import 'package:app/l10n/app_localizations.dart';
import 'package:app/viewmodels/auth_viewmodels/auth_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  const ProfileView({required this.userInfo, super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(),
          centerTitle: true,
          title: const AutoSizeText(
            "Profile",
            maxLines: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          toolbarHeight: 100,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Column(
            children: [
              const SizedBox(height: 20),
              AutoSizeText(
                l10n.profile_overview,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoTile(
                  l10n.full_name, widget.userInfo["full_name"] ?? ""),
              const SizedBox(height: 12),
              SingleChildScrollView( scrollDirection: Axis.horizontal,
                child: _buildInfoTile(l10n.email_hint, widget.userInfo["email"] ?? "")),
              const SizedBox(height: 12),
              _buildInfoTile(
                  l10n.nationality, widget.userInfo["nationality"] ?? ""),
              const SizedBox(height: 12),
              _buildInfoTile(l10n.phone_hint, widget.userInfo["phone"] ?? ""),
              const SizedBox(height: 12),
              _buildInfoTile(
                  l10n.password_hint, widget.userInfo["password"] ?? ""),
              const Spacer(),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       final confirm = await showDialog<bool>(
              //         context: context,
              //         builder: (context) => AlertDialog(
              //           title:
              //               const AutoSizeText('Confirm Deletion', maxLines: 1),
              //           content: const AutoSizeText(
              //             'Are you sure you want to delete your account? This action cannot be undone.',
              //             maxLines: 3,
              //           ),
              //           actions: [
              //             TextButton(
              //               onPressed: () => Navigator.pop(context, false),
              //               child: const AutoSizeText('Cancel', maxLines: 1),
              //             ),
              //             TextButton(
              //               onPressed: () => Navigator.pop(context, true),
              //               child: const AutoSizeText('Delete', maxLines: 1),
              //             ),
              //           ],
              //         ),
              //       );

              //       if (confirm == true) {
              //         final userId =
              //             Supabase.instance.client.auth.currentUser?.id;

              //         if (userId != null) {
              //           context
              //               .read<AuthBloc>()
              //               .add(DeleteAccount(userId: userId));
              //         } else {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content:
              //                   AutoSizeText("No user found.", maxLines: 1),
              //             ),
              //           );
              //         }
              //       }
              //     },
              //     style: ButtonStyle(
              //       fixedSize: WidgetStatePropertyAll(
              //         Size(size.width * .7, 50),
              //       ),
              //       backgroundColor: const WidgetStatePropertyAll(Colors.red),
              //       foregroundColor: const WidgetStatePropertyAll(Colors.white),
              //     ),
              //     child: Text(l10n.delete_my_account),
              //   ),
              // ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      width: size.width,
      height: 56,
      child: Row(
        children: [
          AutoSizeText(label, maxLines: 1),
          const Spacer(),
          AutoSizeText(value, maxLines: 1),
        ],
      ),
    );
  }
}

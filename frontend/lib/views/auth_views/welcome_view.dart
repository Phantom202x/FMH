import 'package:app/viewmodels/app_viewmodels/app_bloc.dart';
import 'package:app/views/auth_views/login_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  VideoPlayerController? _controller;
  late AppBloc navigationBloc;
  @override
  void initState() {
    super.initState();
    navigationBloc = BlocProvider.of<AppBloc>(context);
    _controller = VideoPlayerController.asset("assets/video/intro.mp4")
      ..initialize().then((_) {
        _controller!.play();
        _controller!.setLooping(true);
        //Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller!.value.isInitialized) {
      _controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<AppBloc, NavigationState>(
          listener: (context, state) {
            if (state is WelcomePageState) {
              _controller!.play();
            }
            if (state is LoginPageState) {
              _controller!.pause();

              Navigator.pushNamed(context, "login");
            }
            if (state is RegisterPageState) {
              _controller!.pause();

              Navigator.pushNamed(context, "register");
            }
            if (state is AppPageState) {
              _controller!.dispose();

              Navigator.pushReplacementNamed(context, "app");
            }
          },
        )
      ],
      child: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            navigationBloc.add(GoToAppPage());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Scaffold(
                  body: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller!.value.size.width,
                            height: _controller!.value.size.height,
                            child: _controller!.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white12,
                              Colors.white30,
                              Colors.white54,
                              Colors.white60,
                              Colors.white70,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          "assets/logo/logo.png",
                          filterQuality: FilterQuality.medium,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        //height: 40,
                        child: Column(
                          spacing: 16,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginChoice()),
                                    (route) => false);
                              },
                              style: ButtonStyle(
                                fixedSize: WidgetStatePropertyAll(
                                  Size(size.width * .7, 50),
                                ),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              child: Text('Start'),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Aides and Services',
                                style:
                                    TextStyle(color: const Color(0xFF39CC20)),
                              ),
                            ),
                            // ElevatedButton(
                            //   onPressed: () =>
                            //       navigationBloc.add(GoToRegisterPage()),
                            //   style: ButtonStyle(
                            //     fixedSize: WidgetStatePropertyAll(
                            //       Size(size.width * .7, 50),
                            //     ),
                            //     backgroundColor:
                            //         WidgetStatePropertyAll(Colors.green),
                            //     foregroundColor:
                            //         WidgetStatePropertyAll(Colors.white),
                            //   ),
                            //   child: Text(l10n.guest_button),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Placeholder();
              }
            },
          );
        },
      ),
    );
  }
}

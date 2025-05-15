import 'dart:io';
import 'package:app/services/face_scan_services.dart';
import 'package:app/views/report_views/full_report_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FaceScanView extends StatefulWidget {
  final File image;
  const FaceScanView({required this.image, super.key});

  @override
  State<FaceScanView> createState() => _FaceScanViewState();
}

class _FaceScanViewState extends State<FaceScanView> {
  bool isLoading = false;
  File? image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
    _startFaceScan(image!);
  }

  Future<void> _startFaceScan(File img) async {
    setState(() => isLoading = true);

    final result = await FaceScanServices().matchFace(img);

    setState(() => isLoading = false);

    if (result == null) {
      _showFaceScanGuide();
      _showSnackbar(AppLocalizations.of(context)!.no_face_detected);
    } else if (result == 'no_match') {
      _showFaceScanGuide();
      _showSnackbar(AppLocalizations.of(context)!.no_match_found);
    } else {
      _showSnackbar(AppLocalizations.of(context)!.match_found);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FullReportView(
              image: image!,
              data: result,
            ),
          ),
        );
      });
    }
  }

  void _showFaceScanGuide() {
    final size = MediaQuery.of(context).size;
    FaceScanServices().faceScanGuide(context, size);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _rescanFace() async {
    final pickedImage = await FaceScanServices().getImageFromCamera();
    if (pickedImage != null) {
      setState(() => image = pickedImage);
      _startFaceScan(pickedImage);
    } else {
      _showSnackbar(AppLocalizations.of(context)!.no_image_taken);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black),
          Positioned(
            top: 50,
            child: Text(
              l10n.face_scan_title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (image != null)
            Center(
              child: Container(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.file(image!),
              ),
            ),
          Positioned(
            bottom: 120,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              width: 300,
              child: Row(
                children: [
                  const Icon(Icons.priority_high, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.make_sure_face,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.green,
              ),
            )
          else
            Positioned(
              bottom: 30,
              child: FilledButton(
                onPressed: _rescanFace,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text(l10n.scan_again),
              ),
            ),
        ],
      ),
    );
  }
}














// import 'dart:io';
// import 'package:app/services/face_scan_services.dart';
// import 'package:app/views/report_views/full_report_view.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:app/viewmodels/face_scan_viewmodels/face_scan_bloc.dart';

// class FaceScanView extends StatefulWidget {
//   final File image;
//   const FaceScanView({required this.image, super.key});


//   @override
//   State<FaceScanView> createState() => _FaceScanViewState();
// }

// class _FaceScanViewState extends State<FaceScanView> {
//   late FaceScanBloc _faceScanBloc;
//   bool isLoading = false;
//   File? image;

//   @override
//   void initState() {
//     super.initState();
//     _faceScanBloc = BlocProvider.of<FaceScanBloc>(context);
//     _faceScanBloc.add(SearchMatch(image: widget.image));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       body: MultiBlocListener(
//         listeners: [
//           BlocListener<FaceScanBloc, FaceScanState>(
//             listener: (context, state) async {
//               if (state is FaceMatchLoading) {
//                 setState(() => isLoading = true);
//               }
//               if (state is NoMatchFound || state is NoFaceDetected) {
//                 setState(() => isLoading = false);

//                 FaceScanServices().faceScanGuide(context, size);

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                       state is NoMatchFound
//                           ? l10n.no_match_found
//                           : l10n.no_face_detected,
//                     ),
//                   ),
//                 );
//               }
//               if (state is MatchFound) {
//                 setState(() => isLoading = false);
//                 print('Match found: ${state.faceMatch}');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(l10n.match_found)),
//                 );
//                 Future.delayed(const Duration(seconds: 1), () {
//                   print('Navigating to FullReportView...');
//                   final data = state.faceMatch.serialize();
//                   print(data);
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(
//                       builder: (context) => FullReportView(
//                         image: image ?? widget.image,
//                         data: data,
//                         //data: state.faceMatch.serialize(),
//                       ),
//                     ),
//                   );
//                 });
//               }
//             },
//           ),
//         ],
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Background color
//             Container(color: Colors.black),

//             // Title at the top
//             Positioned(
//               top: 50,
//               child: Text(
//                 l10n.face_scan_title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             // Image container
//             Center(
//               child: Container(
//                 clipBehavior: Clip.antiAlias,
//                 margin: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Image.file(image ?? widget.image),
//               ),
//             ),

//             // Information box at the bottom
//             Positioned(
//               bottom: 120,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 width: 300,
//                 child: Row(
//                   children: [
//                     const Icon(Icons.priority_high, color: Colors.green),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         l10n.make_sure_face,
//                         style: const TextStyle(
//                           color: Colors.green,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Loading spinner
//             if (isLoading)
//               const Center(
//                 child: CircularProgressIndicator(
//                   strokeCap: StrokeCap.round,
//                   color: Colors.green,
//                 ),
//               )
//             else
//               Positioned(
//                 bottom: 30,
//                 child: FilledButton(
//                   onPressed: () async {
//                     final pickedImage =
//                         await FaceScanServices().getImageFromCamera();
//                     if (pickedImage != null) {
//                       _faceScanBloc.add(SearchMatch(image: pickedImage));
//                       setState(() {
//                         image = pickedImage;
//                       });
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(l10n.no_image_taken)),
//                       );
//                     }
//                   },
//                   style: FilledButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 40, vertical: 16),
//                   ),
//                   child: Text(l10n.scan_again),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

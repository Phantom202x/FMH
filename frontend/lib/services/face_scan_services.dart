import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FaceScanServices {
  getImageFromCamera() async {
    print('getting Image');
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return null;
    File image = File(pickedFile.path);
    print('Image taken');
    return image;
  }

  Future<Map<String, dynamic>> matchFace(File image) async {
    var uri = Uri.parse("http://109.176.198.177:8000/recognize");
    print('Starting Matching');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', image.path));
    print('Atached Image');

    try {
      print('preparing send');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('sends');
      if (response.statusCode == 200) {
        print("Face match successful: ${response.body}");
        return json.decode(response.body);
        // Map<String, dynamic> data = json.decode(response.body);
        // return data;
      } else {
        print(
            "Server responded with error: ${response.statusCode} ${response.reasonPhrase}");
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print("No internet connection: $e");
      throw Exception('No internet connection.');
    } on TimeoutException catch (e) {
      print("Request timed out: $e");
      throw Exception('Connection timeout.');
    } catch (e) {
      print("Unexpected error: $e");
      throw Exception('Unexpected error occurred.');
    }
  }
  
  

  // Future matchFace(File image) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse("http://62.72.16.168:8000/recognize"));
  //   request.files.add(
  //     await http.MultipartFile.fromPath('file', image.path),
  //   );
  //   request.headers.addAll({
  //     "Content-Type": "multipart/form-data",
  //     //"Accept": "application/json",
  //   });

  //   try {
  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       String jsonResponse = await response.stream.bytesToString();
  //       Map<String, dynamic> data = json.decode(jsonResponse);
  //       return data;
  //     } else {
  //       return response.reasonPhrase;
  //     }
  //   } catch (e) {
  //     rethrow;
  //     //print("here");
  //     //print("Exception: $e");
  //   }
  // }

  faceScanGuide(context, size) {
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
              margin: const EdgeInsets.symmetric(
                vertical: 36,
                horizontal: 16,
              ),
              padding: const EdgeInsets.all(16),
              width: size.width,
              height: size.height * 0.5,
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Image.asset(
                        "assets/logo/logo.png",
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        l10n.face_scanning_guide,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                  Text(
                    l10n.distance_message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    "- instructions for face scanning 2",
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
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      fixedSize: WidgetStatePropertyAll(
                        Size(size.width - 32, 50),
                      ),
                    ),
                    child: Text(l10n.got_it),
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
              begin: Offset(0, -1),
              end: Offset(0, 0),
            ),
          ),
          child: child,
        );
      },
    );
  }
}

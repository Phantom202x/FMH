import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:equatable/equatable.dart";
import "package:app/services/face_scan_services.dart";
import "package:app/models/face_scan_models.dart";

part "face_scan_state.dart";
part "face_scan_events.dart";

class FaceScanBloc extends Bloc<FaceScanEvents, FaceScanState> {
  FaceScanBloc() : super(FaceScanInitial()) {
    on<FaceScanEvents>(
      (event, emit) async {
        if (event is SearchMatch) {
          emit(FaceMatchLoading());
          try {
            Map<String, dynamic> data = await FaceScanServices().matchFace(
              event.image,
            );

            if (data.containsKey("identity")) {
              FaceMatch match = FaceMatch(
                id: data["identity"]["id"],
                fullName: data["identity"]["full_name"],
                nationality: data["identity"]["nationality"],
                age: data["identity"]["age"],
                bloodType: data["identity"]["blood_type"],
                gender: data["identity"]["gender"],
                contact: data["identity"]["contact"],
                illness: data["identity"]["illness"],
              );

              emit(MatchFound(match));
            } else if (data["message"] == "No matching identity found") {
              emit(NoMatchFound());
            } else if (data["message"] == "No face detected") {
              emit(NoFaceDetected());
            }
          } catch (e) {
            print("Exception: --- $e");
          }
        }
      },
    );
  }
}

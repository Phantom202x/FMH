part of "face_scan_bloc.dart";

abstract class FaceScanState {
  const FaceScanState();

  @override
  List<Object> get props => [];
}

class FaceScanInitial extends FaceScanState {}

class FaceMatchLoading extends FaceScanState {}

class MatchFound extends FaceScanState {
  final FaceMatch faceMatch;

  const MatchFound(this.faceMatch);
}

class NoMatchFound extends FaceScanState {}

class NoFaceDetected extends FaceScanState {}

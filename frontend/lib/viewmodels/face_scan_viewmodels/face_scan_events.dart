part of "face_scan_bloc.dart";

abstract class FaceScanEvents extends Equatable {
  const FaceScanEvents();

  @override
  List<Object> get props => [];
}

class SearchMatch extends FaceScanEvents {
  final File image;
  const SearchMatch({required this.image});
  //@override
  //List<Object> get props => [image];
}

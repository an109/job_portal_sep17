import 'package:equatable/equatable.dart';

abstract class YourExperienceEvent extends Equatable {
  const YourExperienceEvent();
}

class LoadPickExperienceProof extends YourExperienceEvent {
  final String experienceName;
  const LoadPickExperienceProof(this.experienceName);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

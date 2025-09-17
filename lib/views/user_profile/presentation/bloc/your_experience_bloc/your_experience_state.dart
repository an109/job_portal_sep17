import 'package:equatable/equatable.dart';
import 'package:job_portal/views/user_profile/domain/entities/update_user_profile_entity.dart';

abstract class YourExperienceState extends Equatable {
  const YourExperienceState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class YourExperienceInitial extends YourExperienceState {
  const YourExperienceInitial();
}

// class UpdateYourExperienceLoading extends YourExperienceState {
//   const UpdateYourExperienceLoading();
// }

// class UpdateYourExperienceLoaded extends YourExperienceState {
//   final UpdateUserProfileEntity updateUserProfileEntity;

//   const UpdateYourExperienceLoaded(this.updateUserProfileEntity);
// }

// class UpdateYourExperienceError extends YourExperienceState {
//   const UpdateYourExperienceError();
// }

class PickExperienceProofLoading extends YourExperienceState {
  const PickExperienceProofLoading();
}

class PickExperienceProofLoaded extends YourExperienceState {
  final Map<String, dynamic> experienceProof;

  const PickExperienceProofLoaded(this.experienceProof);
}

class PickExperienceProofError extends YourExperienceState {
  const PickExperienceProofError();
}

class NoExperienceProofPicked extends YourExperienceState {
  const NoExperienceProofPicked();
}

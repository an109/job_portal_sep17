import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:job_portal/views/user_profile/domain/entities/terms_and_conditions_entity.dart';

@immutable
abstract class TermsAndConditionsState extends Equatable {
  const TermsAndConditionsState();

  @override
  List<Object?> get props => [];
}

class TnCInitial extends TermsAndConditionsState {
  const TnCInitial();
}

class TnCLoading extends TermsAndConditionsState {
  const TnCLoading();
}

class TnCLoaded extends TermsAndConditionsState {
  final TermsAndConditionEntity termsAndConditionEntity;
  const TnCLoaded(this.termsAndConditionEntity);
}

class TnCError extends TermsAndConditionsState {
  const TnCError();
}

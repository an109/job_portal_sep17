import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DetailedSignupEvent extends Equatable {
  const DetailedSignupEvent();
}

class DetailedSignupGetMasterAllData extends DetailedSignupEvent {
  const DetailedSignupGetMasterAllData();
  @override
  List<Object?> get props => [];
}

class DetailedSignupInitialize extends DetailedSignupEvent {
  const DetailedSignupInitialize();

  @override
  List<Object?> get props => [];
}

class DetailedSignupGetBasicUserInfo extends DetailedSignupEvent {
  final Map<String, dynamic> emailMap;

  const DetailedSignupGetBasicUserInfo(this.emailMap);

  @override
  List<Object?> get props => [emailMap];
}

class DetailedSignupGetCollegeDetails extends DetailedSignupEvent {
  final Map<String, dynamic> emailMap;

  const DetailedSignupGetCollegeDetails(this.emailMap);

  @override
  List<Object?> get props => [emailMap];
}

class DetailedSignupGetSpecializations extends DetailedSignupEvent {
  final String course_id;

  const DetailedSignupGetSpecializations(this.course_id);

  @override
  List<Object?> get props => [course_id];
}

class DetailedSingupSubmitUserDetails extends DetailedSignupEvent {
  final Map<String, dynamic> params;
  const DetailedSingupSubmitUserDetails(this.params);

  @override
  List<Object?> get props => [params];
}

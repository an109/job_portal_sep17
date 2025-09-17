import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/basic_user_data_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/submit_detailed_user_profile.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

@immutable
abstract class DetailedSignupState extends Equatable {
  const DetailedSignupState();

  @override
  List<Object?> get props => [];
}

class MasterAllDataLoaded extends DetailedSignupState {
  const MasterAllDataLoaded();
}

class MasterAllDataError extends DetailedSignupState {
  const MasterAllDataError();
}

class DetailedSignupInitial extends DetailedSignupState {
  const DetailedSignupInitial();
}

class DetailedSignupGetBasicUserInfoLoading extends DetailedSignupState {
  const DetailedSignupGetBasicUserInfoLoading();
}

class DetailedSignupGetBasicUserInfoLoaded extends DetailedSignupState {
  final BasicUserInfoResponse basicUserInfoResponse;
  final LocationListEntity locations;

  const DetailedSignupGetBasicUserInfoLoaded(
      this.basicUserInfoResponse, this.locations);

  @override
  List<Object?> get props => [basicUserInfoResponse, locations];
}

class DetailedSignupGetBasicUserInfoError extends DetailedSignupState {
  const DetailedSignupGetBasicUserInfoError();
}

class DetailedSignupGetCollegeDetailsLoading extends DetailedSignupState {
  const DetailedSignupGetCollegeDetailsLoading();
}

class DetailedSignupGetCollegeDetailsLoaded extends DetailedSignupState {
  final CollegeListEntity collegesListResponse;
  final CourseListEntity coursesListResponse;

  const DetailedSignupGetCollegeDetailsLoaded(
      this.collegesListResponse,
      this.coursesListResponse,
      );

  @override
  List<Object?> get props => [collegesListResponse, coursesListResponse];
}

class DetailedSignupGetCollegeDetailsError extends DetailedSignupState {
  const DetailedSignupGetCollegeDetailsError();
}

class DetailedSingupSubmitUserDetailsLoading extends DetailedSignupState {
  const DetailedSingupSubmitUserDetailsLoading();
}

class DetailedSingupSubmitUserDetailsLoaded extends DetailedSignupState {
  final SubmitDetailedUserProfile submitDetailedUserProfile;

  const DetailedSingupSubmitUserDetailsLoaded(this.submitDetailedUserProfile);

  @override
  List<Object?> get props => [submitDetailedUserProfile];
}

class DetailedSingupSubmitUserDetailsError extends DetailedSignupState {
  final String error;

  const DetailedSingupSubmitUserDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}

class DetailedSignupSpecializationLoading extends DetailedSignupState {
  final CollegeListEntity? collegesListResponse;
  final CourseListEntity? coursesListResponse;

  const DetailedSignupSpecializationLoading({
    this.collegesListResponse,
    this.coursesListResponse,
  });

  @override
  List<Object?> get props => [collegesListResponse, coursesListResponse];
}

class DetailedSignupSpecializationLoaded extends DetailedSignupState {
  final List<SpecializationEntity> specializationListResponse;
  final CollegeListEntity? collegesListResponse;
  final CourseListEntity? coursesListResponse;

  const DetailedSignupSpecializationLoaded(
      this.specializationListResponse, {
        this.collegesListResponse,
        this.coursesListResponse,
      });

  @override
  List<Object?> get props => [
    specializationListResponse,
    collegesListResponse,
    coursesListResponse,
  ];
}

class DetailedSignupSpecializationError extends DetailedSignupState {
  const DetailedSignupSpecializationError();
}

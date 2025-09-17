import 'package:equatable/equatable.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

abstract class MasterDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MasterDataInitial extends MasterDataState {}

class MasterDataLoading extends MasterDataState {}

class MasterDataLoaded extends MasterDataState {
  final List<LocationEntity> locations;
  final List<LocationEntity> jobLocations;
  final List<String> genders;
  final List<CollegeEntity> colleges;
  final List<CourseEntity> courses;
  final List<DomainEntity> domains;
  final List<SkillEntity> skills;
  final List<SpecializationEntity> specializations;
  final List<CompanyEntity> companies;


  MasterDataLoaded({
    required this.locations,
    required this.jobLocations,
    required this.genders,
    required this.colleges,
    required this.courses,
    required this.domains,
    required this.skills,
    required this.specializations,
    required this.companies,

  });

  @override
  List<Object?> get props => [
    locations,
    jobLocations,
    genders,
    colleges,
    courses,
    domains,
    skills,
    specializations,
    companies,
  ];
}

class MasterDataError extends MasterDataState {
  final String message;
  MasterDataError(this.message);

  @override
  List<Object?> get props => [message];
}

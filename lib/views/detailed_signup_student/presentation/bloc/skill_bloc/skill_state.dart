import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/domian_all_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/skill_submission_response.dart';
import 'package:job_portal/views/detailed_signup_student/data/model/subskill_response.dart';
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

@immutable
abstract class SkillState extends Equatable {
  const SkillState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SkillInitial extends SkillState {
  const SkillInitial();
}

class SubSkillLoading extends SkillState {
  const SubSkillLoading();
}

class SubSkillLoaded extends SkillState {
  final SkillListEntity subSkillResponse;
  final String domain;
  final String domainId;

  const SubSkillLoaded(this.subSkillResponse, this.domain, this.domainId);
}

class SubSkillError extends SkillState {
  const SubSkillError();
}

class SkillStateDomainLoading extends SkillState {
  const SkillStateDomainLoading();
}

class SkillStateDomainLoaded extends SkillState {
  final DomainListEntity domainAllResponse;

  const SkillStateDomainLoaded(this.domainAllResponse);
}

class SkillStateDomainError extends SkillState {
  const SkillStateDomainError();
}

class SkillCertificatesLoaded extends SkillState {
  final Map<String, dynamic> skillCertificates;

  const SkillCertificatesLoaded(this.skillCertificates);
}

class SkillCertificateLoading extends SkillState {
  const SkillCertificateLoading();
}

class SubmitSkillLoading extends SkillState {
  const SubmitSkillLoading();
}

class SubmitSkillLoaded extends SkillState {
  final SkillSubmitionResponse skillSubmitionResponse;

  const SubmitSkillLoaded(this.skillSubmitionResponse);
}

class SubmitSkillError extends SkillState {
  const SubmitSkillError();
}

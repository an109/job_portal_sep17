import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SkillEvent extends Equatable {
  const SkillEvent();
}

class LoadDomains extends SkillEvent {
  const LoadDomains();

  @override
  List<Object?> get props => [];
}

class LoadSubSkills extends SkillEvent {
  final String domain;
  final String domainId;
  const LoadSubSkills(this.domain, this.domainId);

  @override
  List<Object?> get props => [];
}

class PickCertificate extends SkillEvent {
  final String? skillName;
  const PickCertificate({this.skillName});

  @override
  // TODO: implement props
  List<Object?> get props => [skillName];
}

class RemoveCertificate extends SkillEvent {
  final String? skillName;
  const RemoveCertificate({this.skillName});

  @override
  // TODO: implement props
  List<Object?> get props => [skillName];
}

class SubmitSkills extends SkillEvent {
  final Map<String, dynamic> data;

  const SubmitSkills(this.data);

  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

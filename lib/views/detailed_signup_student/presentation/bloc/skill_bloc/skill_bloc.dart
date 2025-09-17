import 'dart:developer' as developer show log;

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_portal/views/detailed_signup_student/domain/usecases/skill_usecase.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_event.dart';
import 'package:job_portal/views/detailed_signup_student/presentation/bloc/skill_bloc/skill_state.dart';

class SkillBloc extends Bloc<SkillEvent, SkillState> {
  final SkillUsecase skillUsecase;
  Map<String, dynamic> skillCertificates = {};

  SkillBloc(this.skillUsecase) : super(const SkillInitial()) {
    on<LoadSubSkills>(_onGetSubSkills);
    on<LoadDomains>(_onGetDomains);
    on<PickCertificate>(_onLoadCertificate);
    on<SubmitSkills>(_onSubmitSkillsAndProfile);
    on<RemoveCertificate>(_onRemoveCertificate);
  }

  Future<void> _onGetDomains(
      LoadDomains event, Emitter<SkillState> emit) async {
    try {
      emit(const SkillStateDomainLoading());
      final response = await skillUsecase.getDomains();
      emit(SkillStateDomainLoaded(response.data!)); // pass result
    } catch (e) {
      developer.log('Error in get domains in bloc : ${e}');
      emit(const SkillStateDomainError());
    }
  }

  Future<void> _onGetSubSkills(
      LoadSubSkills event, Emitter<SkillState> emit) async {
    try {
      emit(const SubSkillLoading());
      final response = await skillUsecase.getSubSkills(event.domainId);
      emit(SubSkillLoaded(
          response.data!, event.domain, event.domainId)); // pass result
    } catch (e) {
      emit(const SubSkillError());
    }
  }

  Future<void> _onLoadCertificate(
      PickCertificate event, Emitter<SkillState> emit) async {
    try {
      emit(const SkillCertificateLoading());
      final file = await FilePicker.platform.pickFiles();

      if (file != null && event.skillName != null) {
        skillCertificates[event.skillName!] = file;
        developer.log(file.files.first.path ?? 'null path');
      }
      emit(SkillCertificatesLoaded(skillCertificates));
    } catch (e) {
      developer.log('Error while picking images: ${e.toString()}');
    }
  }

  Future<void> _onRemoveCertificate(
      RemoveCertificate event, Emitter<SkillState> emit) async {
    emit(const SkillCertificateLoading());
    try {
      if (event.skillName != null) {
        skillCertificates.remove(event.skillName);
      }
      emit(SkillCertificatesLoaded(skillCertificates));
    } catch (e) {
      developer.log('Error removing certificate');
    }
  }

  Future<void> _onSubmitSkillsAndProfile(
      SubmitSkills event, Emitter<SkillState> emit) async {
    try {
      emit(const SubmitSkillLoading());
      final response =
          await skillUsecase.submitSkillsAndCertificates(event.data);
      emit(SubmitSkillLoaded(response.data!));
    } catch (e) {
      emit(const SubSkillError());
    }
  }
}

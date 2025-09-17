import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class CompanyRegisterEvent extends Equatable {
  const CompanyRegisterEvent();

  @override
  List<Object?> get props => [];
}

class CreateCompany extends CompanyRegisterEvent {
  final Map<String, dynamic> data;

  const CreateCompany(this.data);

  @override
  List<Object?> get props => [data];
}

class LoadMasterData extends CompanyRegisterEvent {}
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/company_register_entity.dart';

@immutable
abstract class CompanyRegisterState extends Equatable {
  const CompanyRegisterState();

  @override
  List<Object?> get props => [];
}

class CompanyRegisterInitial extends CompanyRegisterState {}

class CompanyRegisterLoading extends CompanyRegisterState {}

class CompanyRegisterSuccess extends CompanyRegisterState {
  final CompanyRegisterEntity? data;

  const CompanyRegisterSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class CompanyRegisterError extends CompanyRegisterState {
  final String message;

  const CompanyRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}

class MasterDataLoaded extends CompanyRegisterState {
  final Map<String, dynamic> data;

  const MasterDataLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class MasterDataError extends CompanyRegisterState {
  final String message;

  const MasterDataError(this.message);

  @override
  List<Object?> get props => [message];
}
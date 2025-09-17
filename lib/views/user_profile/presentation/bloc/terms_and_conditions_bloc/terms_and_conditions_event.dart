import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class TermsAndConditionsEvent extends Equatable {
  const TermsAndConditionsEvent();
}

class LoadTnC extends TermsAndConditionsEvent {
  const LoadTnC();

  @override
  List<Object?> get props => [];
}

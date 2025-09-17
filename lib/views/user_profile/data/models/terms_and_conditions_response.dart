import 'package:job_portal/views/user_profile/domain/entities/terms_and_conditions_entity.dart';

class TermsAndConditionModel extends TermsAndConditionEntity {
  TermsAndConditionModel({required super.terms_and_condition});

  factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) {
    return TermsAndConditionModel(
      terms_and_condition: json['terms_and_condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'terms_and_condition': terms_and_condition,
    };
  }
}

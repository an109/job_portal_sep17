// domain_model.dart
import 'package:job_portal/views/detailed_signup_student/domain/entities/metadata_entities.dart';

class DomainModel extends DomainEntity {
  const DomainModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DomainListModel extends DomainListEntity {
  const DomainListModel({
    required List<DomainEntity> domains,
  }) : super(domains: domains);

  factory DomainListModel.fromJson(Map<String, dynamic> json) {
    return DomainListModel(
      domains: (json['domains'] as List<dynamic>?)
              ?.map((e) => DomainModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domains': domains
          .map((domain) => DomainModel(
                id: domain.id,
                name: domain.name,
              ).toJson())
          .toList(),
    };
  }
}

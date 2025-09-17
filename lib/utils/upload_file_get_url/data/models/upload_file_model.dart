import 'package:job_portal/utils/upload_file_get_url/domain/entities/upload_file_entity.dart';

class UploadFileModel extends UploadFileEntity {
  const UploadFileModel({required super.url});

  factory UploadFileModel.fromJson(Map<String, dynamic> json) {
    return UploadFileModel(
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

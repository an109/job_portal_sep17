// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruiter_schedule_interview_api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _RecruiterScheduleInterviewApiService
    implements RecruiterScheduleInterviewApiService {
  _RecruiterScheduleInterviewApiService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??= 'http://bvrcrafts.com:5000/api/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<RecruiterScheduleInterviewResponseModel> scheduleInterview(
    int applicantId,
    String message,
    String interviewType,
    String interviewDate,
    String startTime,
    String endTime,
    String? videoLink,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'message': message,
      'interview_type': interviewType,
      'interview_date': interviewDate,
      'start_time': startTime,
      'end_time': endTime,
      'video_link': videoLink,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<RecruiterScheduleInterviewResponseModel>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        contentType: 'application/x-www-form-urlencoded',
      )
          .compose(
            _dio.options,
            'interview-invitations/${applicantId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late RecruiterScheduleInterviewResponseModel _value;
    try {
      _value = RecruiterScheduleInterviewResponseModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on

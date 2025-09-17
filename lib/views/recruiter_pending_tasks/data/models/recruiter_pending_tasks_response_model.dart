class PendingTasksResponseModel {
  final ResumeReview resumeReview;
  final InterviewToSchedule interviewToSchedule;
  final OfferLetterPending offerLetterPending;

  PendingTasksResponseModel({
    required this.resumeReview,
    required this.interviewToSchedule,
    required this.offerLetterPending,
  });

  factory PendingTasksResponseModel.fromJson(Map<String, dynamic> json) =>
      PendingTasksResponseModel(
        resumeReview: ResumeReview.fromJson(json['resumeReview']),
        interviewToSchedule: InterviewToSchedule.fromJson(json['interviewToSchedule']),
        offerLetterPending: OfferLetterPending.fromJson(json['offerLetterPending']),
      );

  Map<String, dynamic> toJson() => {
    'resumeReview': resumeReview.toJson(),
    'interviewToSchedule': interviewToSchedule.toJson(),
    'offerLetterPending': offerLetterPending.toJson(),
  };
}

class ResumeReview {
  final int count;

  ResumeReview({required this.count});

  factory ResumeReview.fromJson(Map<String, dynamic> json) => ResumeReview(count: json['count']);

  Map<String, dynamic> toJson() => {'count': count};
}

class InterviewToSchedule {
  final int count;

  InterviewToSchedule({required this.count});

  factory InterviewToSchedule.fromJson(Map<String, dynamic> json) =>
      InterviewToSchedule(count: json['count']);

  Map<String, dynamic> toJson() => {'count': count};
}

class OfferLetterPending {
  final int count;

  OfferLetterPending({required this.count});

  factory OfferLetterPending.fromJson(Map<String, dynamic> json) =>
      OfferLetterPending(count: json['count']);

  Map<String, dynamic> toJson() => {'count': count};
}
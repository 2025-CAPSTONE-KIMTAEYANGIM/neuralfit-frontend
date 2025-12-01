class AIReport {
  final int medicalRecordId;
  final String approvalStatus;
  final String introduction;
  final String currentStatus;
  final String cognitiveTestInterpretation;
  final String biomarkerInterpretation;
  final String summaryOpinion;
  final String recommendations;
  final DateTime createdAt;
  final DateTime updatedAt;

  AIReport({
    required this.medicalRecordId,
    required this.approvalStatus,
    required this.introduction,
    required this.currentStatus,
    required this.cognitiveTestInterpretation,
    required this.biomarkerInterpretation,
    required this.summaryOpinion,
    required this.recommendations,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AIReport.fromJson(Map<String, dynamic> json) {
    return AIReport(
      medicalRecordId: json['medicalRecordId'],
      approvalStatus: json['approvalStatus'],
      introduction: json['introduction'],
      currentStatus: json['currentStatus'],
      cognitiveTestInterpretation: json['cognitiveTestInterpretation'],
      biomarkerInterpretation: json['biomarkerInterpretation'],
      summaryOpinion: json['summaryOpinion'],
      recommendations: json['recommendations'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

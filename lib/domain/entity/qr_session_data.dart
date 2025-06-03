class QrSessionData {
  final String sessionId;
  final String courseId;
  final DateTime sessionDate;
  final DateTime expiresAt;

  QrSessionData({
    required this.sessionId,
    required this.courseId,
    required this.sessionDate,
    required this.expiresAt,
  });

  factory QrSessionData.fromJson(Map<String, dynamic> json) {
    return QrSessionData(
      sessionId: json['sessionId'],
      courseId: json['courseId'],
      sessionDate: DateTime.parse(json['sessionDate']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
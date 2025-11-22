class StressLog {
  final int? id;
  final String text;
  final int? angerLevel;
  final int? anxiety;
  final int? techFactor;
  final int? humanFactor;
  final Map<String, dynamic>? forensicResult;
  final String? justification;
  final String? consolation;
  final DateTime? createdAt;

  StressLog({
    this.id,
    required this.text,
    this.angerLevel,
    this.anxiety,
    this.techFactor,
    this.humanFactor,
    this.forensicResult,
    this.justification,
    this.consolation,
    this.createdAt,
  });

  factory StressLog.fromJson(Map<String, dynamic> json) {
    return StressLog(
      id: json['id'],
      text: json['text'],
      angerLevel: json['angerLevel'],
      anxiety: json['anxiety'],
      techFactor: json['techFactor'],
      humanFactor: json['humanFactor'],
      forensicResult: json['forensicResult'],
      justification: json['justification'],
      consolation: json['consolation'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

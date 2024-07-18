class Status {
  String name;
  String status;
  String sessionUrl;

  Status({
    required this.name,
    required this.status,
    required this.sessionUrl,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      name: json['name'],
      status: json['status'],
      sessionUrl: json['session_url'],
    );
  }
}

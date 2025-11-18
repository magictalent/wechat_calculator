class FriendRequest {
  FriendRequest({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.fromName,
    required this.fromEmail,
    required this.fromImage,
    required this.status,
    required this.createdAt,
  });

  late String id;
  late String fromId;
  late String toId;
  late String fromName;
  late String fromEmail;
  late String fromImage;
  late String status; // 'pending', 'accepted', 'rejected'
  late String createdAt;

  FriendRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    fromId = json['from_id'] ?? '';
    toId = json['to_id'] ?? '';
    fromName = json['from_name'] ?? '';
    fromEmail = json['from_email'] ?? '';
    fromImage = json['from_image'] ?? '';
    status = json['status'] ?? '';
    createdAt = json['created_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['from_id'] = fromId;
    data['to_id'] = toId;
    data['from_name'] = fromName;
    data['from_email'] = fromEmail;
    data['from_image'] = fromImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}


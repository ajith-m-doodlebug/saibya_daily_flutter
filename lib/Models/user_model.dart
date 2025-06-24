class UserModel {
  int? id;
  String? name;
  String? phoneNumber;
  bool? isVerified;

  UserModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
    };
  }
}

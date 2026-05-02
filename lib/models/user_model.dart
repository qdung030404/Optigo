class UserModel {
  final String uid;
  final String userName;
  final String phoneNumber;
  UserModel({
    required this.uid, required this.userName, required this.phoneNumber,
  });

  factory UserModel.formMap(Map<String, dynamic> map, String uid){
    return UserModel(
        uid: uid,
        userName: map['user_name'] ?? '',
        phoneNumber: map['phone_number'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'phone_number': phoneNumber,
    };
  }
}


class UserModel{
  late String userId;
  late String userName;
  late String email;
  String? image;
  late String type;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    this.image,
    required this.type
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      email: map['email'] as String,
      image: map['image'], // No type casting, allows null value
      type: map['type'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return ({
      "userId" : userId,
      "userName" : userName,
      "email" : email,
      "image" : image,
      "type" : type
    });
  }
}

//Models
class UserModel {
  final String id;
  final String name;
  final String emailId;
  final String emailIdFirebaseId;
  final String gender;
  final String userName;
  final String imgUrl;
  final String joinedDate;
  final String phoneNumber;
  final String phoneNumberFirebaseId;
  final bool isPrivate;
  final List<String> posts;
  final List<String> followers;
  final List<String> followings;
  final List<String> closeFriends;
  final List<String> acceptedFollowerRequests;
  final List<String> declinedFollowerRequests;
  final List<String> requestingFollowers;
  final List<String> acceptedFollowingRequests;
  final List<String> declinedFollowingRequests;
  final List<String> requestingFollowing;
  final List<String> postLiked;
  final List<String> commentLiked;
  final List<String> commented;
  final List<String> fav;

  UserModel(
      {required this.id,
      required this.name,
      required this.emailId,
      required this.emailIdFirebaseId,
      required this.phoneNumberFirebaseId,
      required this.gender,
      required this.userName,
      required this.imgUrl,
      required this.joinedDate,
      required this.phoneNumber,
      required this.isPrivate,
      required this.posts,
      required this.followers,
      required this.followings,
      required this.closeFriends,
      required this.acceptedFollowerRequests,
      required this.declinedFollowerRequests,
      required this.requestingFollowers,
      required this.acceptedFollowingRequests,
      required this.declinedFollowingRequests,
      required this.requestingFollowing,
      required this.postLiked,
      required this.commentLiked,
      required this.commented,
      required this.fav});
}

class UnsignUserModel {
  final String id;
  final String name;
  final String gender;
  final String userName;
  final String emailId;
  final String imgUrl;
  final String joinedDate;
  final String phoneNumber;
  final String phoneNumberFirebaseId;
  final String emailIdFirebaseId;
  final bool isPrivate;
  final List<String> deviceTokens;
  final List<String> posts;
  final List<String> followers;
  final List<String> followings;

  UnsignUserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.userName,
    required this.emailId,
    required this.imgUrl,
    required this.joinedDate,
    required this.phoneNumber,
    required this.emailIdFirebaseId,
    required this.phoneNumberFirebaseId,
    required this.isPrivate,
    required this.deviceTokens,
    required this.posts,
    required this.followers,
    required this.followings,
  });
}

class PostModel {
  final String id;
  final String userId;
  final String description;
  final String url;
  final String profileUrl;
  final String profileName;
  final String profileUserName;
  final String postedDate;
  final List<String> likes;
  final List<String> comments;

  PostModel(
      {required this.id,
      required this.userId,
      required this.description,
      required this.url,
      required this.profileUrl,
      required this.profileName,
      required this.profileUserName,
      required this.postedDate,
      required this.likes,
      required this.comments});
}

class UserPostModel {
  final String id;
  final String userId;
  final String description;
  final String url;
  final String postedDate;
  final List<String> likes;
  final List<String> comments;

  UserPostModel(
      {required this.id,
      required this.userId,
      required this.description,
      required this.url,
      required this.postedDate,
      required this.likes,
      required this.comments});
}

class Comment {
  final String id;
  final String commented;
  final String description;
  final String to;
  final String time;
  final String reply;
  final String postId;
  final String name;
  final String userName;
  final String imgUrl;
  final List<String> likes;

  Comment({
    required this.id,
    required this.time,
    required this.commented,
    required this.description,
    required this.to,
    required this.reply,
    required this.postId,
    required this.name,
    required this.userName,
    required this.imgUrl,
    required this.likes,
  });
}

class Message {
  String from;
  String message;
  int time;
  String to;
  String type;
  bool read;

  Message(
      {required this.from,
      required this.message,
      required this.time,
      required this.read,
      required this.type,
      required this.to});

  static fromMap(Object? data) {}
}

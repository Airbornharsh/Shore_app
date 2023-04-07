//Models
class UserModel {
  final String id;
  final String name;
  final String emailId;
  final String gender;
  final String userName;
  final String imgUrl;
  final String joinedDate;
  final String phoneNumber;
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
  final String imgUrl;
  final String joinedDate;
  final String phoneNumber;
  final bool isPrivate;
  final List<String> socketIds;
  final List<String> posts;
  final List<String> followers;
  final List<String> followings;

  UnsignUserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.userName,
    required this.imgUrl,
    required this.joinedDate,
    required this.phoneNumber,
    required this.isPrivate,
    required this.socketIds,
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

class CommentModel {
  final String id;
  final String commented;
  final String description;
  final String to;
  final String postId;
  final List<String> likes;

  CommentModel({
    required this.id,
    required this.commented,
    required this.description,
    required this.to,
    required this.postId,
    required this.likes,
  });
}

class Message {
  String from;
  String message;
  String time;
  

  Message({required this.from, required this.message, required this.time});
}

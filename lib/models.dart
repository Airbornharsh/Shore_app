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
  final List<String> posts;
  final List<String> friends;
  final List<String> closeFriends;
  final List<Map<String, dynamic>> requestingFriends;
  final List<String> requestedFriends;
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
      required this.posts,
      required this.friends,
      required this.closeFriends,
      required this.requestedFriends,
      required this.requestingFriends,
      required this.postLiked,
      required this.commentLiked,
      required this.commented,
      required this.fav});
}

class PostModel {
  final String userId;
  final String description;
  final String url;
  final String postDate;
  final List<String> likes;
  final List<String> comments;

  PostModel(
      {required this.userId,
      required this.description,
      required this.url,
      required this.postDate,
      required this.likes,
      required this.comments});
}

class CommentModel {
  final String commented;
  final String description;
  final String to;
  final String postId;
  final List<String> likes;

  CommentModel({
    required this.commented,
    required this.description,
    required this.to,
    required this.postId,
    required this.likes,
  });
}

class EndpointConstants {
  static const String baseUrl = 'https://nuvia-server-1.onrender.com';
  static const String nuvia = '/nuvia/v1/api/';
  static const String auth = '${nuvia}auth/';
  static const String register = '${auth}register?language=';
  static const String login = '${auth}login?language=';
  static const String profile = '${auth}profile?language=';
  static const String content = "${nuvia}content/";
  static const String selectTopics = "${content}select-topics?language=";
  static const String getAllTopic = "${content}get-all-topic?language=";
  static const String post = "${nuvia}post/";
  static const String add = "${post}add?language=";
  static const String myPosts = "${post}my-posts?language=";
  static const String allPosts = "${post}all-posts?language=";
  static const String forYouPosts = "${post}foryou?language=";
  static const String interaction = "${post}interaction/";
  static const String addLike = "${interaction}like?language=";
  static const String allLike = interaction;
  static const String mySharedPosts = "${interaction}my-shared-posts?language=";
  static const myReplies = "${interaction}my-comments";
  static const String users = "${nuvia}user/";
  static const String getUsers = "${users}users";
  static const String follow = "${users}follow/";
  static const String unfollow = "${users}unfollow/";
  static const String userProfile = "${users}profile/";
  static const String following = "${users}following?language=";
  static const String followers = "${users}followers?language=";

}

enum AppRoutes {
  auth('/auth'),
  home('/home'),
  search('/search'),
  favorite('/favorite'),
  notification('/notification'),
  userProfile('/user-profile'),
  editProfile('/edit-profile'),
  daikoins('/daikoins'),
  friends('/friends'),
  addFriends('/add-friends'),
  listChallenges('/list-challenges');

  const AppRoutes(this.route);

  final String route;
  // final String? path;

  String get name => route.replaceAll('/', '');
}

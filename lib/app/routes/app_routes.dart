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
  createChallenge('/create-challenge'),
  listChallenges('/list-challenges'),
  challengeDetails('/challenge-details', path: '/challenge/:challengeId'),
  ;

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}

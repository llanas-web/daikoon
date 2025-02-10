enum AppRoutes {
  auth('/auth'),
  home('/home'),
  search('/search'),
  favorite('/favorite'),
  notification('/notification'),
  userProfile('/user-profile'),
  editProfile('/edit-profile');

  const AppRoutes(this.route);

  final String route;
  // final String? path;

  String get name => route.replaceAll('/', '');
}

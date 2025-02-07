enum AppRoutes {
  auth('/auth'),
  home('/home'),
  search('/search'),
  favorite('/favorite'),
  notification('/notification'),
  userProfile('/user-profile');

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}

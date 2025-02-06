enum AppRoutes {
  auth('/auth');

  const AppRoutes(this.route, {this.path});

  final String route;
  final String? path;

  String get name => route.replaceAll('/', '');
}

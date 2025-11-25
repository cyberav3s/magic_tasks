// ignore_for_file: sort_constructors_first

enum RoutePath {
  initial('/'),
  home('/home'),
  taskDetails('/details'),
  auth('/auth');

  final String path;
  const RoutePath(this.path);
}

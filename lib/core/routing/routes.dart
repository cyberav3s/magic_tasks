// ignore_for_file: unused_element

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:magic_tasks/core/routing/route_path.dart';
import 'package:magic_tasks/features/task/view/pages/details_page.dart';
import 'package:magic_tasks/features/task/view/pages/tasks_page.dart';

final _routerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

Widget _sharedAxisTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SharedAxisTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    transitionType: SharedAxisTransitionType.horizontal,
    child: child,
  );
}

Widget _sharedScaleTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SharedAxisTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    transitionType: SharedAxisTransitionType.scaled,
    child: child,
  );
}

final router = GoRouter(
  navigatorKey: _routerNavigatorKey,
  initialLocation: RoutePath.initial.path,
  routes: [
    GoRoute(
      parentNavigatorKey: _routerNavigatorKey,
      path: RoutePath.initial.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const TasksPage()),
    ),
    GoRoute(
      parentNavigatorKey: _routerNavigatorKey,
      path: RoutePath.taskDetails.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DetailsPage(),
        transitionsBuilder: _sharedAxisTransition,
      ),
    ),
  ],
);
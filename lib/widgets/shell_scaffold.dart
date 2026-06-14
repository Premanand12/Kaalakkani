import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/localization.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  const ShellScaffold({super.key, required this.child});

  static const _tabs = [
    (path: '/',          icon: Icons.wb_sunny_outlined,    activeIcon: Icons.wb_sunny),
    (path: '/month',     icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month),
    (path: '/rasipalan', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome),
    (path: '/muhurtham', icon: Icons.event_available_outlined, activeIcon: Icons.event_available),
    (path: '/more',      icon: Icons.grid_view_outlined,   activeIcon: Icons.grid_view),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path) &&
          (_tabs[i].path == '/' ? location == '/' : true)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    
    final tabLabels = [
      AppLocale.s(context, 'tab_today'),
      AppLocale.s(context, 'tab_month'),
      AppLocale.s(context, 'tab_rasipalan'),
      AppLocale.s(context, 'tab_muhurtham'),
      AppLocale.s(context, 'tab_more'),
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: idx,
          onTap: (i) => context.go(_tabs[i].path),
          items: List.generate(_tabs.length, (i) => BottomNavigationBarItem(
            icon: Icon(_tabs[i].icon),
            activeIcon: Icon(_tabs[i].activeIcon),
            label: tabLabels[i],
          )),
        ),
      ),
    );
  }
}

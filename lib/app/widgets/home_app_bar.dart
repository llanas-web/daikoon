import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Tappable(
            child: Assets.images.daikoon.svg(),
            onTap: () => context.go('/'),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
    );
  }
}

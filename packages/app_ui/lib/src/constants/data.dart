// ignore_for_file: public_member_api_docs
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

/// Navigation bar items
List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String searchLabel,
  required String favoriteLabel,
  required String notificationLabel,
  required String userProfileLabel,
  required bool hasNotification,
}) =>
    <NavBarItem>[
      NavBarItem(icon: Assets.icons.home, label: homeLabel),
      NavBarItem(icon: Assets.icons.search, label: searchLabel),
      NavBarItem(icon: Assets.icons.heart, label: favoriteLabel),
      NavBarItem(
        icon: hasNotification
            ? Assets.icons.notificationActif
            : Assets.icons.notification,
        label: notificationLabel,
      ),
      NavBarItem(icon: Assets.icons.profile, label: userProfileLabel),
    ];

class NavBarItem {
  NavBarItem({
    required this.icon,
    this.label,
  });

  final String? label;
  final SvgGenImage icon;

  String? get tooltip => label;
}

class GradientColor {
  const GradientColor({required this.hex, this.opacity});

  final String hex;
  final double? opacity;
}

enum PremiumGradient {
  fl0(
    colors: [
      GradientColor(hex: '842CD7'),
      GradientColor(hex: '21F5F1', opacity: .8),
    ],
    stops: [0, 1],
  ),
  telegram(
    colors: [
      GradientColor(hex: '6C93FF'),
      GradientColor(hex: '976FFF'),
      GradientColor(hex: 'DF69D1'),
    ],
    stops: [0, .5, 1],
  );

  const PremiumGradient({
    required this.colors,
    required this.stops,
  });

  final List<GradientColor> colors;
  final List<double> stops;
}

List<String> get commentEmojies =>
    ['🩷', '🙌', '🔥', '👏🏻', '😢', '😍', '😮', '😂'];

List<ModalOption> createMediaModalOptions({
  required String reelLabel,
  required String postLabel,
  required String storyLabel,
  required BuildContext context,
  required void Function(String route, {Object? extra}) goTo,
  required bool enableStory,
  ValueSetter<String>? onStoryCreated,
}) =>
    <ModalOption>[
      ModalOption(
        name: reelLabel,
        iconData: Icons.video_collection_outlined,
        onTap: () => goTo('create-post', extra: true),
      ),
      ModalOption(
        name: postLabel,
        iconData: Icons.outbox_outlined,
        onTap: () => goTo('create-post'),
      ),
      if (enableStory)
        ModalOption(
          name: storyLabel,
          iconData: Icons.cameraswitch_outlined,
          onTap: () => goTo('create-stories', extra: onStoryCreated),
        ),
    ];

List<ModalOption> followerModalOptions({
  required String unfollowLabel,
  required VoidCallback onUnfollowTap,
}) =>
    <ModalOption>[ModalOption(name: unfollowLabel, onTap: onUnfollowTap)];

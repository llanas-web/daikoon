import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:storage/storage.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileParameters extends StatelessWidget {
  const UserProfileParameters({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
        notificationsRepository: context.read<NotificationsRepository>(),
        storage: context.read<Storage>(),
      ),
      child: const UserProfileParametersView(),
    );
  }
}

class UserProfileParametersView extends StatelessWidget {
  const UserProfileParametersView({super.key});

  @override
  Widget build(BuildContext context) {
    final isNotifEnabled = ValueNotifier<bool>(false);
    final userProfileBloc = context.read<UserProfileBloc>();

    Future<void> toggleNotification({required bool value}) async {
      if (value) {
        userProfileBloc.add(
          const UserProfileNotificationEnableRequested(),
        );
      } else {
        userProfileBloc.add(
          const UserProfileNotificationDisableRequested(),
        );
      }
      isNotifEnabled.value = value;
    }

    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          context.l10n.userProfileTileInformationLabel,
          style: UITextStyle.navTitle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: context.reversedAdaptiveColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xlg),
        child: AppConstrainedScrollView(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder<bool>(
                valueListenable: isNotifEnabled,
                builder: (context, value, child) {
                  return SwitchListTile(
                    value: value,
                    onChanged: (newValue) =>
                        toggleNotification(value: newValue),
                    title: const Text('Enable notifications'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

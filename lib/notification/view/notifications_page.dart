import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/app/bloc/app_bloc.dart';
import 'package:daikoon/notification/notification.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(
        notificationsRepository: context.read<NotificationsRepository>(),
      ),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final notifications = context.read<NotificationsCubit>();
    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bluryBackground.provider(),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            BetterStreamBuilder<List<Notification>>(
              initialData: const <Notification>[],
              stream: notifications.fetchNotifications(userId: user.id),
              builder: (context, notifications) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: NotificationItem(
                                notification: notifications[index],
                              ),
                            ),
                          ],
                        ),
                        const Gap.v(AppSpacing.md),
                      ],
                    ),
                    itemCount: notifications.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileDaikoins extends StatelessWidget {
  const UserProfileDaikoins({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
      )..add(
          const UserProfileDaikoinsRequested(),
        ),
      child: const UserProfileDaikoinsView(),
    );
  }
}

class UserProfileDaikoinsView extends StatefulWidget {
  const UserProfileDaikoinsView({super.key});

  @override
  State<UserProfileDaikoinsView> createState() =>
      _UserProfileDaikoinsViewState();
}

class _UserProfileDaikoinsViewState extends State<UserProfileDaikoinsView> {
  @override
  Widget build(BuildContext context) {
    final daikoins =
        context.select((UserProfileBloc bloc) => bloc.state.daikoins);
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(context.l10n.userProfileTileInformationLabel),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: context.reversedAdaptiveColor,
      ),
      body: Center(child: Text('Daikoins $daikoins')),
    );
  }
}

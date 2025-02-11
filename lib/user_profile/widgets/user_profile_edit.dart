import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/bloc/app_bloc.dart';
import 'package:daikoon/app/routes/app_routes.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileEdit extends StatelessWidget {
  const UserProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const UserProfileEditView(),
    );
  }
}

class UserProfileEditView extends StatefulWidget {
  const UserProfileEditView({super.key});

  @override
  State<UserProfileEditView> createState() => _UserProfileEditViewState();
}

class _UserProfileEditViewState extends State<UserProfileEditView> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
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
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xlg),
        child: AppConstrainedScrollView(
          withScrollBar: true,
          child: Column(
            children: <Widget>[
              ProfileInfoInput(
                value: user.fullName,
                label: 'Full Name',
                description: 'Your full name',
                infoType: ProfileEditInfoType.fullName,
                textController: _fullNameController,
              ),
              ProfileInfoInput(
                value: user.username,
                label: context.l10n.usernameText,
                description: 'username',
                infoType: ProfileEditInfoType.username,
                textController: _usernameController,
              ),
              const Gap.v(AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xlg,
                      ),
                      child: UserProfileEditSaveButton(
                        onPressed: () {
                          context.read<UserProfileBloc>().add(
                                UserProfileUpdateRequested(
                                  fullName: _fullNameController.text.isNotEmpty
                                      ? _fullNameController.text
                                      : null,
                                  username: _usernameController.text.isNotEmpty
                                      ? _usernameController.text
                                      : null,
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ].spacerBetween(height: AppSpacing.md),
          ),
        ),
      ),
    );
  }
}

class ProfileInfoInput extends StatefulWidget {
  const ProfileInfoInput({
    required this.value,
    required this.label,
    this.infoType,
    this.description,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.inputType = TextInputType.name,
    this.textController,
    super.key,
  });

  final String? value;
  final String? description;
  final String label;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueSetter<String>? onChanged;
  final ValueSetter<String?>? onFieldSubmitted;
  final TextInputType inputType;
  final TextEditingController? textController;
  final ProfileEditInfoType? infoType;

  @override
  State<ProfileInfoInput> createState() => _ProfileInfoInputState();
}

class _ProfileInfoInputState extends State<ProfileInfoInput> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = (widget.textController?..text = widget.value ?? '') ??
        TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ProfileInfoInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != null) {
      _textController.text = widget.value!;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField.underlineBorder(
      textController: _textController,
      focusNode: _focusNode,
      filled: false,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.done,
      textInputType: widget.readOnly ? null : widget.inputType,
      autofillHints: const [AutofillHints.nickname],
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLength: widget.readOnly
          ? null
          : widget.infoType == ProfileEditInfoType.fullName
              ? 40
              : 16,
      onTap: !widget.readOnly
          ? null
          : () => context.pushNamed(
                AppRoutes.editProfile.name,
                pathParameters: {'label': widget.label},
                queryParameters: {
                  'title': widget.label,
                  'value': widget.value,
                  'description': widget.description,
                },
                extra: widget.infoType,
              ),
      labelText: widget.label,
      labelStyle: context.bodyLarge?.apply(color: AppColors.grey),
      contentPadding: EdgeInsets.zero,
      onChanged: widget.onChanged,
      floatingLabelBehaviour: FloatingLabelBehavior.auto,
    );
  }
}

enum ProfileEditInfoType { username, fullName, bio }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../cubits/profile_cubit.dart';
import '../widgets/personal_details_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/profile_header.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => GetIt.I<ProfileCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  static const int _maxAvatarBytes = 5 * 1024 * 1024;
  static const Set<String> _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _avatarErrorMessage(AppLocalizations l10n, String code) =>
      switch (code) {
        'avatar.too.large' => l10n.avatarTooLarge,
        'avatar.invalid.type' => l10n.avatarInvalidType,
        'avatar.file.missing' => l10n.avatarFileMissing,
        'user.not.found' => l10n.avatarUserNotFound,
        'network.error' => l10n.errNetwork,
        'server.error' => l10n.errServer,
        _ => l10n.avatarGeneric,
      };

  Future<void> _pickAndUpload(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    final l10n = AppLocalizations.of(context);
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null) return;

    final extension = file.name.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(extension)) {
      if (context.mounted) {
        _showSnack(context, _avatarErrorMessage(l10n, 'avatar.invalid.type'));
      }
      return;
    }

    final bytes = await file.readAsBytes();
    if (bytes.lengthInBytes > _maxAvatarBytes) {
      if (context.mounted) {
        _showSnack(context, _avatarErrorMessage(l10n, 'avatar.too.large'));
      }
      return;
    }

    await cubit.uploadAvatar(bytes, file.name);
  }

  Future<void> _openEdit(BuildContext context, UserProfile profile) async {
    final cubit = context.read<ProfileCubit>();
    await context.push(EditProfilePage.routeName, extra: profile);
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: const AppBrandLogo(brandName: 'Itersapiens'),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final profile = switch (state) {
                ProfileLoaded(:final profile) => profile,
                ProfileAvatarError(:final profile) => profile,
                _ => null,
              };
              return IconButton(
                icon: Icon(Icons.edit_outlined, color: cs.primary),
                tooltip: l10n.editProfileTooltip,
                onPressed: profile == null
                    ? null
                    : () => _openEdit(context, profile),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (_, current) => current is ProfileAvatarError,
        listener: (context, state) {
          if (state is ProfileAvatarError) {
            _showSnack(context, _avatarErrorMessage(l10n, state.code));
          }
        },
        builder: (context, state) {
          final profile = switch (state) {
            ProfileLoaded(:final profile) => profile,
            ProfileAvatarError(:final profile) => profile,
            _ => null,
          };
          final uploading = state is ProfileLoaded && state.avatarUploading;

          if (profile != null) {
            return _ProfileContent(
              profile: profile,
              avatarUploading: uploading,
              onEditPhoto: () => _pickAndUpload(context),
              onSignOut: () => context.read<ProfileCubit>().signOut(),
            );
          }

          if (state is ProfileFailureState) {
            return _ProfileError(
              code: state.code,
              onRetry: () => context.read<ProfileCubit>().load(),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.avatarUploading,
    required this.onEditPhoto,
    required this.onSignOut,
  });

  final UserProfile profile;
  final bool avatarUploading;
  final VoidCallback onEditPhoto;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(
                fullName: profile.fullName,
                email: profile.email,
                imageUrl: profile.imageUrl,
                isUploading: avatarUploading,
                onEditPhoto: onEditPhoto,
              ),
              const SizedBox(height: AppSpacing.xxl),
              _SectionHeader(
                icon: Icons.person_outline,
                title: l10n.sectionPersonalDetails,
              ),
              AppSpacing.gapLg,
              PersonalDetailsCard(profile: profile),
              const SizedBox(height: AppSpacing.xxl),
              _SectionHeader(
                icon: Icons.settings_outlined,
                title: l10n.sectionPreferences,
              ),
              AppSpacing.gapLg,
              PreferencesCard(onSignOut: onSignOut),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 22, color: cs.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 20,
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.code, required this.onRetry});

  final String code;
  final VoidCallback onRetry;

  String _message(AppLocalizations l10n) => switch (code) {
        'network.error' => l10n.errNetwork,
        'server.error' => l10n.errServer,
        'unauthorized' => l10n.errUnauthorized,
        _ => l10n.errProfileLoad,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            AppSpacing.gapLg,
            Text(
              _message(l10n),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.gapXl,
            AppPrimaryButton(
              label: l10n.retry,
              expanded: true,
              trailingIcon: null,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

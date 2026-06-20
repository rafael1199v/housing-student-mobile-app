import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:housing_design_system/housing_design_system.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  bool get _cameraSupported =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSnackAction(
    BuildContext context,
    String message,
    String actionLabel,
    VoidCallback onAction,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(label: actionLabel, onPressed: onAction),
        ),
      );
  }

  String _avatarErrorMessage(AppLocalizations l10n, String code) =>
      switch (code) {
        'avatar.too.large' => l10n.avatarTooLarge,
        'avatar.invalid.type' => l10n.avatarInvalidType,
        'avatar.file.missing' => l10n.avatarFileMissing,
        'avatar.camera.unavailable' => l10n.avatarCameraUnavailable,
        'user.not.found' => l10n.avatarUserNotFound,
        'network.error' => l10n.errNetwork,
        'server.error' => l10n.errServer,
        _ => l10n.avatarGeneric,
      };

  Future<void> _onEditPhoto(BuildContext context) async {
    if (!_cameraSupported) {
      await _pickAndUpload(context, ImageSource.gallery);
      return;
    }
    final source = await _AvatarSourceSheet.show(context);
    if (source != null && context.mounted) {
      await _pickAndUpload(context, source);
    }
  }

  Future<bool> _ensureCameraPermission(BuildContext context) async {
    if (kIsWeb) return true;
    final l10n = AppLocalizations.of(context);
    final status = await Permission.camera.request();
    if (status.isGranted || status.isLimited) return true;
    if (!context.mounted) return false;
    if (status.isPermanentlyDenied || status.isRestricted) {
      _showSnackAction(
        context,
        l10n.avatarCameraPermissionDenied,
        l10n.openSettings,
        openAppSettings,
      );
    } else {
      _showSnack(context, l10n.avatarCameraPermissionDenied);
    }
    return false;
  }

  Future<void> _pickAndUpload(BuildContext context, ImageSource source) async {
    final cubit = context.read<ProfileCubit>();
    final l10n = AppLocalizations.of(context);

    if (source == ImageSource.camera) {
      final allowed = await _ensureCameraPermission(context);
      if (!allowed || !context.mounted) return;
    }

    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
      );
    } on PlatformException {
      if (context.mounted) {
        _showSnack(context, _avatarErrorMessage(l10n, 'avatar.camera.unavailable'));
      }
      return;
    }
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
              onEditPhoto: () => _onEditPhoto(context),
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

class _AvatarSourceSheet extends StatelessWidget {
  const _AvatarSourceSheet();

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadii.lgValue)),
      ),
      builder: (_) => const _AvatarSourceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final media = MediaQuery.of(context);
    final bottomInset = media.padding.bottom;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Text(
                  l10n.avatarSourceTitle,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontSize: 20),
                ),
              ),
              _SourceTile(
                icon: Icons.photo_camera_outlined,
                label: l10n.avatarTakePhoto,
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              _SourceTile(
                icon: Icons.photo_library_outlined,
                label: l10n.avatarChooseFromGallery,
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              AppSpacing.gapSm,
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.mdValue),
      ),
      leading: Icon(icon, color: cs.primary),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      onTap: onTap,
    );
  }
}

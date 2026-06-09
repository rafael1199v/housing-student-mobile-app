import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:householder_design_system/householder_design_system.dart';

import '../../domain/entities/user_profile.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/personal_details_card.dart';
import '../widgets/preferences_card.dart';
import '../widgets/profile_header.dart';

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

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  Future<void> _openEdit(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    await context.push('/profile/edit');
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const BrandLogo(brandName: 'Sanctuary Housing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            tooltip: 'Edit profile',
            onPressed: () => _openEdit(context),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileLoaded(:final profile) => _ProfileContent(
              profile: profile,
              onComingSoon: (feature) => _comingSoon(context, feature),
              onSignOut: () => context.read<ProfileCubit>().signOut(),
            ),
            ProfileFailureState(:final code) => _ProfileError(
              code: code,
              onRetry: () => context.read<ProfileCubit>().load(),
            ),
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.onComingSoon,
    required this.onSignOut,
  });

  final UserProfile profile;
  final ValueChanged<String> onComingSoon;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.xl,
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
                onEdit: () => onComingSoon('Editing your photo'),
              ),
              AppSpacing.gapXL,
              const _SectionHeader(
                icon: Icons.person_outline,
                title: 'Personal Details',
              ),
              AppSpacing.gapM,
              PersonalDetailsCard(profile: profile),
              AppSpacing.gapXL,
              const _SectionHeader(
                icon: Icons.settings_outlined,
                title: 'Preferences',
              ),
              AppSpacing.gapM,
              PreferencesCard(onComingSoon: onComingSoon, onSignOut: onSignOut),
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
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 20,
            color: AppColors.primary,
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

  String get _message => switch (code) {
    'network.error' => 'No connection. Check your network and try again.',
    'server.error' => 'Something went wrong on our side. Please try again.',
    'unauthorized' => 'Your session expired. Please sign in again.',
    _ => 'We could not load your profile. Please try again.',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 56,
              color: AppColors.textHint,
            ),
            AppSpacing.gapM,
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppSpacing.gapL,
            PrimaryButton(
              label: 'Retry',
              trailingIcon: null,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

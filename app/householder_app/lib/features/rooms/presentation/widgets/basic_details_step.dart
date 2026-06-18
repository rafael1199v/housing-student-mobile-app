import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

import '../../../../core/core.dart';
import '../cubits/create_room_cubit.dart';
import 'location_map.dart';
import 'photos_picker.dart';

/// Step 1: basic details, photos and location.
class BasicDetailsStep extends StatefulWidget {
  const BasicDetailsStep({super.key});

  @override
  State<BasicDetailsStep> createState() => _BasicDetailsStepState();
}

class _BasicDetailsStepState extends State<BasicDetailsStep> {
  late final CreateRoomCubit _cubit = context.read<CreateRoomCubit>();
  late final TextEditingController _name =
      TextEditingController(text: _cubit.state.name);
  late final TextEditingController _description =
      TextEditingController(text: _cubit.state.description);
  late final TextEditingController _price =
      TextEditingController(text: _cubit.state.price);

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRoomCubit, CreateRoomState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final showErrors = state.showStepErrors;
        final priceValue = state.priceValue;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.basicDetails,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 18),
                  ),
                  AppSpacing.gapXl,
                  AppTextField(
                    label: l10n.roomTitle,
                    hintText: l10n.hintRoomTitle,
                    uppercaseLabel: false,
                    controller: _name,
                    onChanged: _cubit.updateName,
                    errorText: showErrors && state.name.trim().isEmpty
                        ? l10n.validationTitleRequired
                        : null,
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: l10n.descriptionLabel,
                    hintText: l10n.hintDescription,
                    uppercaseLabel: false,
                    controller: _description,
                    maxLines: 4,
                    onChanged: _cubit.updateDescription,
                    errorText: showErrors && state.description.trim().isEmpty
                        ? l10n.validationDescriptionRequired
                        : null,
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: l10n.pricePerMonth,
                    hintText: l10n.hintPrice,
                    prefixIcon: Icons.attach_money,
                    uppercaseLabel: false,
                    controller: _price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _cubit.updatePrice,
                    errorText: showErrors && (priceValue == null || priceValue <= 0)
                        ? l10n.validationPriceInvalid
                        : null,
                  ),
                  AppSpacing.gapXl,
                  AppFieldLabel(text: l10n.initialStatus, uppercase: false),
                  const SizedBox(height: AppSpacing.sm),
                  AppSegmentedToggle(
                    labels: [l10n.roomStatusAvailable, l10n.statusNotAvailable],
                    selectedIndex: state.statusId == 1 ? 0 : 1,
                    onChanged: (i) => _cubit.updateStatus(i == 0 ? 1 : 2),
                  ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: PhotosPicker(
                images: state.images,
                onAdd: _cubit.addImages,
                onRemove: _cubit.removeImage,
                existingImages: state.existingImages,
                onRemoveExisting: _cubit.removeExistingImage,
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.location,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 18),
                  ),
                  AppSpacing.gapLg,
                  LocationMap(
                    latitude: state.latitude,
                    longitude: state.longitude,
                    onTap: _cubit.setLocation,
                    onUseCurrentLocation: _cubit.useCurrentLocation,
                  ),
                  AppSpacing.gapMd,
                  _LocationSummary(state: state),
                  if (showErrors && !state.hasLocation) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.locationHelp,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocationSummary extends StatelessWidget {
  const _LocationSummary({required this.state});

  final CreateRoomState state;

  @override
  Widget build(BuildContext context) {
    if (!state.hasLocation) {
      return Text(
        AppLocalizations.of(context).noLocationSelected,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    final coords =
        '${state.latitude!.toStringAsFixed(5)}, ${state.longitude!.toStringAsFixed(5)}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined,
            size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            state.address ?? coords,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

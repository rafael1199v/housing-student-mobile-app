import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housing_design_system/housing_design_system.dart';

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
                    'Basic Details',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 18),
                  ),
                  AppSpacing.gapXl,
                  AppTextField(
                    label: 'Room Title',
                    hintText: 'e.g. Spacious Master Bedroom',
                    uppercaseLabel: false,
                    controller: _name,
                    onChanged: _cubit.updateName,
                    errorText: showErrors && state.name.trim().isEmpty
                        ? 'Title is required.'
                        : null,
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: 'Description',
                    hintText: 'Describe the room and amenities…',
                    uppercaseLabel: false,
                    controller: _description,
                    maxLines: 4,
                    onChanged: _cubit.updateDescription,
                    errorText: showErrors && state.description.trim().isEmpty
                        ? 'Description is required.'
                        : null,
                  ),
                  AppSpacing.gapLg,
                  AppTextField(
                    label: 'Price per Month',
                    hintText: '0.00',
                    prefixIcon: Icons.attach_money,
                    uppercaseLabel: false,
                    controller: _price,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _cubit.updatePrice,
                    errorText: showErrors && (priceValue == null || priceValue <= 0)
                        ? 'Enter a price greater than 0.'
                        : null,
                  ),
                  AppSpacing.gapXl,
                  const AppFieldLabel(text: 'Initial Status', uppercase: false),
                  const SizedBox(height: AppSpacing.sm),
                  AppSegmentedToggle(
                    labels: const ['Available', 'Not Available'],
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
              ),
            ),
            AppSpacing.gapXl,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
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
                      'Tap the map or use your current location.',
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
        'No location selected yet.',
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

import 'package:flutter/material.dart';
import 'package:householder_design_system/householder_design_system.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/room_image.dart';

class PhotosPicker extends StatelessWidget {
  const PhotosPicker({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
    this.maxImages = 5,
  });

  final List<RoomImage> images;
  final void Function(List<RoomImage> added) onAdd;
  final void Function(int index) onRemove;
  final int maxImages;

  Future<void> _pick(BuildContext context) async {
    final remaining = maxImages - images.length;
    if (remaining <= 0) return;
    final picked = await ImagePicker().pickMultiImage();
    if (picked.isEmpty) return;
    final selected = picked.take(remaining);
    final result = <RoomImage>[];
    for (final file in selected) {
      result.add(
        RoomImage(bytes: await file.readAsBytes(), filename: file.name),
      );
    }
    if (result.isNotEmpty) onAdd(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photos',
              style:
                  Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18),
            ),
            Text(
              '${images.length} / $maxImages Added',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        AppSpacing.gapM,
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.s,
          crossAxisSpacing: AppSpacing.s,
          children: [
            if (images.length < maxImages) _UploadTile(onTap: () => _pick(context)),
            for (var i = 0; i < images.length; i++)
              _PreviewTile(image: images[i], onRemove: () => onRemove(i)),
          ],
        ),
        AppSpacing.gapXS,
        Text(
          'Recommended size: 1200×800px or larger.',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusM),
      child: DottedBorderBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate_outlined,
                color: AppColors.primary),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Upload Image',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({required this.image, required this.onRemove});

  final RoomImage image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
          child: Image.memory(image.bytes, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: child,
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({
    super.key,
    this.onImageSelected,
    this.size = 96,
    this.label = 'Upload Photo',
    this.enabled = true,
  });
  
  final void Function(XFile file, Uint8List bytes)? onImageSelected;
  final double size;
  final String label;
  final bool enabled;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _preview;

  Future<void> _pick() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _preview = bytes);
    widget.onImageSelected?.call(file, bytes);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.enabled ? _pick : null,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceContainerHighest,
              border: Border.all(color: colors.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: _preview == null
                ? Icon(
                    Icons.add_a_photo_outlined,
                    size: widget.size * 0.32,
                    color: colors.onSurfaceVariant,
                  )
                : Image.memory(_preview!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

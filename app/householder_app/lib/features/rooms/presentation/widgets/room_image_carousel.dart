import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:housing_design_system/housing_design_system.dart';

class RoomImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final VoidCallback onEdit;

  const RoomImageCarousel({
    super.key,
    required this.imageUrls,
    required this.onEdit,
  });

  @override
  State<RoomImageCarousel> createState() => _RoomImageCarouselState();
}

class _RoomImageCarouselState extends State<RoomImageCarousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;
    final showArrows = urls.length > 1 && !Breakpoints.isCompact(context);
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          if (urls.isEmpty)
            const _ImagePlaceholder()
          else
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: PageView.builder(
                controller: _controller,
                itemCount: urls.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => Image.network(
                  urls[i],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const _ImagePlaceholder(loading: true),
                  errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                ),
              ),
            ),
          if (showArrows) ...[
            Positioned(
              top: 0,
              bottom: 0,
              left: AppSpacing.lg,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_left,
                  onTap: _page == 0 ? null : () => _goTo(_page - 1),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: AppSpacing.lg,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_right,
                  onTap: _page == urls.length - 1
                      ? null
                      : () => _goTo(_page + 1),
                ),
              ),
            ),
          ],
          if (urls.length > 1)
            Positioned(
              bottom: AppSpacing.lg,
              left: 0,
              right: 0,
              child: _Dots(count: urls.length, active: _page),
            ),
          Positioned(
            top: AppSpacing.md,
            right: AppSpacing.lg,
            child: _EditButton(onTap: widget.onEdit),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLowest,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            size: 24,
            color: onTap == null
                ? cs.onSurface.withValues(alpha: 0.3)
                : cs.primary,
          ),
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLowest,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(Icons.edit_outlined, size: 20, color: cs.primary),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            height: 8,
            width: i == active ? 20 : 8,
            decoration: BoxDecoration(
              color: i == active
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadii.pillValue),
            ),
          ),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.loading = false});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.surfaceContainerLow,
      child: Center(
        child: loading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Icon(Icons.image_outlined, size: 48, color: cs.outline),
      ),
    );
  }
}

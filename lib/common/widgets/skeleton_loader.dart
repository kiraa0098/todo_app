import 'dart:math';

import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final int rows;
  final int columns;
  final double minBoxHeight;
  final double maxBoxHeight;
  final double minBoxWidth;
  final double maxBoxWidth;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double coverageHeightPercent;

  const SkeletonLoader({
    super.key,
    this.rows = 3,
    this.columns = 2,
    this.minBoxHeight = 40.0,
    this.maxBoxHeight = 80.0,
    this.minBoxWidth = 80.0,
    this.maxBoxWidth = 160.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    this.coverageHeightPercent = 1,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmerAnimation;
  late final List<_SkeletonBoxConfig> _boxesConfig;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(_controller);
    final rand = Random(DateTime.now().millisecondsSinceEpoch);
    _boxesConfig = List.generate(widget.rows * widget.columns, (i) {
      final height =
          widget.minBoxHeight +
          (widget.maxBoxHeight - widget.minBoxHeight) * rand.nextDouble();
      final width =
          widget.minBoxWidth +
          (widget.maxBoxWidth - widget.minBoxWidth) * rand.nextDouble();
      return _SkeletonBoxConfig(height, width);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;
    return LayoutBuilder(
      builder: (context, constraints) {
        double parentHeight = constraints.maxHeight;
        final screenHeight = MediaQuery.of(context).size.height;

        if (parentHeight < screenHeight * 0.8) {
          parentHeight = screenHeight;
        }
        final maxHeight = parentHeight * widget.coverageHeightPercent;
        return Padding(
          padding: widget.padding,
          child: SizedBox(
            height: maxHeight,
            width: constraints.maxWidth,
            child: AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(widget.rows * widget.columns, (i) {
                    final config = _boxesConfig[i];
                    return Container(
                      width: config.width,
                      height: config.height,
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [baseColor, highlightColor, baseColor],
                          stops: const [0.1, 0.5, 0.9],
                          transform: _SlidingGradientTransform(
                            _shimmerAnimation.value,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SkeletonBoxConfig {
  final double height;
  final double width;
  _SkeletonBoxConfig(this.height, this.width);
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

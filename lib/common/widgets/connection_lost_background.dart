import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConnectionLostBackground extends StatelessWidget {
  final double? width;
  final double? height;

  const ConnectionLostBackground({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Connection Lost',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 12),
            Text(
              'It looks like you’re offline. Please check your internet connection and try again.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SvgPicture.asset(
              'assets/svg/background/connection_lost.svg',
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SuccessToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final duration = const Duration(seconds: 2);
    final fadeDuration = const Duration(milliseconds: 350);
    final controller = AnimationController(
      vsync: Navigator.of(context),
      duration: fadeDuration,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: FadeTransition(
              opacity: animation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    controller.forward();
    Future.delayed(duration, () async {
      await controller.reverse();
      overlayEntry.remove();
      controller.dispose();
    });
  }
}

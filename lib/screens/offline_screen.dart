import 'package:flutter/material.dart';

class OfflineScreen extends StatefulWidget {
  static const String routeName = '/offline';
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 0.06,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neon = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 56, color: neon),
              const SizedBox(height: 12),
              const Text('No internet connection. Please try again.'),
              const SizedBox(height: 16),
              GestureDetector(
                onTapDown: (_) => _controller.forward(),
                onTapCancel: () => _controller.reverse(),
                onTapUp: (_) => _controller.reverse(),
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final scale = 1 - _controller.value;
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(
                            (neon.r * 255.0).round(),
                            (neon.g * 255.0).round(),
                            (neon.b * 255.0).round(),
                            0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromRGBO(
                              (neon.r * 255.0).round(),
                              (neon.g * 255.0).round(),
                              (neon.b * 255.0).round(),
                              0.5,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(
                                (neon.r * 255.0).round(),
                                (neon.g * 255.0).round(),
                                (neon.b * 255.0).round(),
                                0.3,
                              ),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh_rounded, color: neon),
                            const SizedBox(width: 8),
                            const Text('Retry'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

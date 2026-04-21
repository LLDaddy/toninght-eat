import 'package:flutter/material.dart';

class RitualTarotCard extends StatelessWidget {
  const RitualTarotCard({
    super.key,
    required this.width,
    required this.height,
    required this.tilt,
    this.front = false,
  });

  final double width;
  final double height;
  final double tilt;
  final bool front;

  @override
  Widget build(BuildContext context) {
    final radius = front ? 13.0 : 11.0;
    return Transform.rotate(
      angle: tilt,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: front ? const Color(0xC3140703) : const Color(0xA4150803),
              blurRadius: front ? 22 : 14,
              offset: front ? const Offset(0, 9) : const Offset(0, 5),
            ),
            BoxShadow(
              color: front ? const Color(0x82F4C06A) : const Color(0x66F4C06A),
              blurRadius: front ? 12 : 8,
              spreadRadius: -3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1F4DA6), Color(0xFF123777), Color(0xFF0E2D67)],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color(0xFFE9C67E),
              width: front ? 1.9 : 1.6,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius - 0.8),
                      border: Border.all(
                        color: const Color(0x8CD59E4E),
                        width: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius - 2),
                      border: Border.all(
                        color: const Color(0xFFC08D3A),
                        width: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius - 5),
                      border: Border.all(
                        color: const Color(0x4DE9C67E),
                        width: 0.7,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius - 4),
                      border: Border.all(
                        color: const Color(0x66E9C67E),
                        width: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(top: 8, left: 8, child: _CornerMotif()),
              const Positioned(
                top: 8,
                right: 8,
                child: _CornerMotif(reverseX: true),
              ),
              const Positioned(
                bottom: 8,
                left: 8,
                child: _CornerMotif(reverseY: true),
              ),
              const Positioned(
                bottom: 8,
                right: 8,
                child: _CornerMotif(reverseX: true, reverseY: true),
              ),
              Positioned(
                top: 7,
                left: 20,
                child: Container(
                  width: 6,
                  height: 1.1,
                  color: const Color(0xAACF9B4C),
                ),
              ),
              Positioned(
                top: 7,
                right: 20,
                child: Container(
                  width: 6,
                  height: 1.1,
                  color: const Color(0xAACF9B4C),
                ),
              ),
              Positioned(
                bottom: 7,
                left: 20,
                child: Container(
                  width: 6,
                  height: 1.1,
                  color: const Color(0xAACF9B4C),
                ),
              ),
              Positioned(
                bottom: 7,
                right: 20,
                child: Container(
                  width: 6,
                  height: 1.1,
                  color: const Color(0xAACF9B4C),
                ),
              ),
              Positioned(
                top: 17,
                left: width * 0.31,
                right: width * 0.31,
                child: Container(height: 1.2, color: const Color(0x6CEBCF96)),
              ),
              Positioned(
                bottom: 17,
                left: width * 0.31,
                right: width * 0.31,
                child: Container(height: 1.2, color: const Color(0x6CEBCF96)),
              ),
              Align(
                child: Container(
                  width: front ? 31 : 25,
                  height: front ? 31 : 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFFE8C782),
                        Color(0xFFC48A34),
                        Color(0xFF8B581E),
                      ],
                    ),
                    border:
                        Border.all(color: const Color(0xFFF6E3BC), width: 0.8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x8A2F1406),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(3.2),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xAA6F451F),
                                width: 0.9,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.diamond,
                        size: 10,
                        color: Color(0xFF2D1A0E),
                      ),
                      const Positioned(
                        top: 4,
                        child: Icon(Icons.circle,
                            size: 3, color: Color(0xFF3A2610)),
                      ),
                      const Positioned(
                        bottom: 4,
                        child: Icon(Icons.circle,
                            size: 3, color: Color(0xFF3A2610)),
                      ),
                      const Positioned(
                        left: 4,
                        child: Icon(Icons.circle,
                            size: 3, color: Color(0xFF3A2610)),
                      ),
                      const Positioned(
                        right: 4,
                        child: Icon(Icons.circle,
                            size: 3, color: Color(0xFF3A2610)),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: width * 0.5 - 2,
                top: height * 0.5 - 16,
                child:
                    const Icon(Icons.circle, size: 4, color: Color(0xAACF9B4C)),
              ),
              Positioned(
                left: width * 0.5 - 2,
                top: height * 0.5 + 12,
                child:
                    const Icon(Icons.circle, size: 4, color: Color(0xAACF9B4C)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerMotif extends StatelessWidget {
  const _CornerMotif({
    this.reverseX = false,
    this.reverseY = false,
  });

  final bool reverseX;
  final bool reverseY;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: reverseX ? -1 : 1,
      scaleY: reverseY ? -1 : 1,
      child: SizedBox(
        width: 18,
        height: 18,
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              top: 0,
              child: Icon(
                Icons.auto_awesome,
                size: 10,
                color: Color(0xFFE8C87F),
              ),
            ),
            Positioned(
              left: 8,
              top: 3,
              child: Container(
                width: 6,
                height: 1.1,
                color: const Color(0xAACF9B4C),
              ),
            ),
            Positioned(
              left: 4,
              top: 9,
              child: Container(
                width: 1.1,
                height: 6,
                color: const Color(0xAACF9B4C),
              ),
            ),
            const Positioned(
              left: 10,
              top: 10,
              child: Icon(
                Icons.circle,
                size: 3,
                color: Color(0xAACF9B4C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

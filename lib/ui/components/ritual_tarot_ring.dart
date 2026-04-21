import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'ritual_tarot_card.dart';

class RitualTarotRing extends StatelessWidget {
  const RitualTarotRing({
    super.key,
    this.wiggle = 0,
    this.scale = 1,
    this.glowOpacity = 0,
  });

  final double wiggle;
  final double scale;
  final double glowOpacity;

  @override
  Widget build(BuildContext context) {
    const center = Offset(166, 166);
    const backSize = Size(88, 128);
    const frontSize = Size(116, 167);
    const backAngles = <double>[-168, -138, -108, -78, -48, -18, 12];

    return Transform.rotate(
      angle: wiggle,
      child: Transform.scale(
        scale: scale,
        child: SizedBox(
          width: 332,
          height: 332,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              if (glowOpacity > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: glowOpacity,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 0.9,
                            colors: <Color>[
                              Color(0x8AF6B24A),
                              Color(0x30E68E2A),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ...backAngles.map((deg) {
                final rad = deg * math.pi / 180;
                final x = center.dx + math.cos(rad) * 120 - backSize.width / 2;
                final y = center.dy + math.sin(rad) * 78 - backSize.height / 2;
                return Positioned(
                  left: x,
                  top: y,
                  child: RitualTarotCard(
                    width: backSize.width,
                    height: backSize.height,
                    tilt: ((deg + 90) / 180) * 0.66,
                  ),
                );
              }),
              Positioned(
                left: 36,
                top: 178,
                child: RitualTarotCard(
                  width: frontSize.width,
                  height: frontSize.height,
                  tilt: -0.5,
                  front: true,
                ),
              ),
              Positioned(
                left: 112,
                top: 190,
                child: RitualTarotCard(
                  width: frontSize.width,
                  height: frontSize.height,
                  tilt: 0,
                  front: true,
                ),
              ),
              Positioned(
                left: 188,
                top: 178,
                child: RitualTarotCard(
                  width: frontSize.width,
                  height: frontSize.height,
                  tilt: 0.5,
                  front: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

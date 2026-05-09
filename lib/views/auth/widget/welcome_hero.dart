import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: constraints.maxWidth,
            height: 400,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Circle
                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner Circle (Containing Text)
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.lexend(
                            fontSize: 24,
                            height: 1.3,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff176bac),
                          ),
                          children: const [
                            TextSpan(text: 'Optigo\n'),
                            TextSpan(text: 'Mọi thứ trong tầm tay\n'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Register or log in to embark on your green journey.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icons around the circle
                _buildPositionedIcon(
                  icon: Icons.directions_car,
                  color: Colors.teal,
                  angle: -pi / 2, // Top
                  radius: 160,
                  size: 32,
                ),
                _buildPositionedIcon(
                  icon: Icons.location_on,
                  color: Colors.lightBlue,
                  angle: -3 * pi / 4, // Top Left
                  radius: 120,
                  size: 28,
                ),
                _buildPositionedIcon(
                  icon: Icons.local_shipping,
                  color: Colors.orange,
                  angle: 0, // Right
                  radius: 120,
                  size: 32,
                ),
                _buildPositionedIcon(
                  icon: Icons.calendar_month,
                  color: Colors.blue,
                  angle: 3 * pi / 4, // Bottom Left
                  radius: 160,
                  size: 26,
                ),
                _buildPositionedIcon(
                  icon: Icons.card_giftcard,
                  color: Colors.lightBlueAccent,
                  angle: pi / 2, // Bottom
                  radius: 120,
                  size: 28,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPositionedIcon({
    required IconData icon,
    required Color color,
    required double angle,
    required double radius,
    required double size,
  }) {
    // Basic polar to cartesian coordinates calculation
    final dx = radius * cos(angle);
    final dy = radius * sin(angle);

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LoadingSpinner extends StatefulWidget {
  @override
  _LoadingSpinnerState createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 70.0,
        height: 70.0,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Transform.translate(
                    offset: Offset(
                      0.0,
                      20.0 *
                          (1.0 -
                              (_animationController.value - (i * 0.33)).abs()),
                    ),
                    child: Dot(
                      color: _getDotColor(i), // Get color based on dot index
                      radius: 10.0,
                      delay: i * 200,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color _getDotColor(int index) {
    // Return different colors based on dot index
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.amber;
      case 2:
        return Colors.red.shade700;
      default:
        return Colors.white;
    }
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double radius;
  final int delay;

  const Dot(
      {Key? key,
      required this.color,
      required this.radius,
      required this.delay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0 - (delay / 600.0),
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

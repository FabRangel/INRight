import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/historyItem.dart';

class AnimatedHistoryItem extends StatelessWidget {
  final HistoryItem item;
  final int index;

  const AnimatedHistoryItem({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Opacity(
          opacity: 1 - offset.dy * 5,
          child: Transform.translate(
            offset: Offset(0, offset.dy * 50),
            child: child,
          ),
        );
      },
      child: item,
    );
  }
}

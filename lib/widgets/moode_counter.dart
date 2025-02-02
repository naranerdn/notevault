import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';

class MoodCountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodProvider>(
      builder: (context, moodProvider, child) {
        final moodCounts = moodProvider.moodCounts;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: moodCounts.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(children: [
                Image.asset(
                  'assets/${entry.key}',
                  width: 25,
                  height: 25,
                ),
                Text(entry.value.toString())
              ]),
            );
            ;
          }).toList(),
        );
      },
    );
  }
}

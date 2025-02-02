import 'package:flutter/material.dart';
import 'package:notevault/models/Mood.dart';
import 'package:notevault/providers/mood_provider.dart';
import 'package:notevault/screens/home_screen.dart';
import 'package:notevault/widgets/moode_counter.dart';
import 'package:provider/provider.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool moodChanged = false;
  @override
  void initState() {
    super.initState();
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    moodProvider.fetchMoods();
  }

  final List<String> moodEmojis = [
    'angry.png',
    'lucky.png',
    'blessed.png',
    'loved.png',
    'sick.png',
    'laughed.png'
  ];

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.3,
              image: AssetImage('assets/bg_pattern_1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.2),
        ),
        Padding(
          padding: EdgeInsets.only(top: 60.0, left: 30, right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Энэ сарын',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('таны mood ❤️',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              SizedBox(
                height: 120,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "December",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.1),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days in a week
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 31, // 31 days in December
                  itemBuilder: (context, index) {
                    final day = index + 1;

                    // Check if there is a mood for this day
                    Mood? moodForDay = moodProvider.moods.isNotEmpty
                        ? moodProvider.moods.lastWhere(
                            (mood) => mood.date.day == day,
                            orElse: () => Mood(date: DateTime.now(), mood: ''),
                          )
                        : null;

                    return GestureDetector(
                      onTap: () {
                        !moodChanged
                            ? setState(() {
                                _showMoodDialog(context, day);
                              })
                            : {print('abo asd')};
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        child: Center(
                          child: Container(
                            decoration: moodForDay != null &&
                                    moodForDay.mood.isNotEmpty
                                ? BoxDecoration(
                                    color: Color(0xFFFDD2EE),
                                    borderRadius: BorderRadius.circular(100),
                                  )
                                : null,
                            alignment: Alignment.center,
                            child: moodForDay != null &&
                                    moodForDay.mood.isNotEmpty
                                ? Image.asset(
                                    'assets/${moodForDay.mood}',
                                    width: 30,
                                    height: 30,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 30,
                                      );
                                    },
                                  )
                                : Text(
                                    '$day',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              MoodCountWidget(),
              SizedBox(height: 100)
            ],
          ),
        ),
      ]),
    );
  }

  void _showMoodDialog(BuildContext context, int selectedDay) {
    final moodProvider =
        Provider.of<MoodProvider>(context, listen: false); // Use listen: false
    showDialog(
      context: context,
      builder: (ctx) => Stack(children: [
        AlertDialog(
          title: Text(
            'Mood',
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: moodEmojis.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Mood newMood = Mood(
                        date: DateTime(2024, 12, selectedDay),
                        mood: moodEmojis[index]);
                    moodProvider.addMood(newMood); // No need to listen
                    setState(() {
                      moodChanged = true;
                    });
                    Navigator.of(ctx).pop(true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade500.withOpacity(0.3),
                            width: 2),
                        borderRadius: BorderRadius.circular(100)),
                    width: 10,
                    height: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Image.asset(
                        'assets/${moodEmojis[index]}',
                        width: 10,
                        height: 10,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.error,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 120,
          child: SizedBox(
            height: 200,
            child: Image.asset(
              'assets/yellow_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ]),
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:notevault/screens/mood_screen.dart';
import 'package:notevault/screens/note_detail_screen.dart';
import 'package:notevault/screens/pin_code_change_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// import '../providers/notes_provider.dart';
import '../models/note.dart';
import './to_do_screen.dart';
import './mood_screen.dart';
import 'package:notevault/providers/notes_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _contentController = TextEditingController();
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreenContent(),
    ToDoScreen(),
    MoodScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: '',
          ),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_pattern_1.png'),
              opacity: 0.3,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.2),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text('to your comfort place ❤️',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PinCodeChangeScreen()),
                        );
                      },
                      child: const Icon(Icons.settings, color: Colors.black54)),
                ],
              ),
            ),
            // DottedBorder(
            //     child: Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: TextField(
            //     onEditingComplete: () {
            //       if (_contentController.text.isNotEmpty) {
            //         final newNote = Note(
            //             content: _contentController.text,
            //             mood: "Happy",
            //             timestamp: DateTime.now());

            //         notesProvider.addNote(newNote);
            //         _contentController.clear();
            //       }
            //     },
            //     controller: _contentController,
            //     decoration: InputDecoration(
            //       hintText: 'Тэмдэглэл бичих...',
            //       filled: true,
            //       fillColor: Colors.white,
            //       prefixIcon: const Icon(Icons.add),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide.none,
            //       ),
            //     ),
            //   ),
            // )),
            InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteDetailScreen()),
                )
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: DottedBorder(
                    dashPattern: [6, 3],
                    strokeWidth: 2,
                    color: Colors.grey.shade500,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.15), // Shadow color with opacity
                            blurRadius: 8, // Blur effect
                            spreadRadius: 2, // How much the shadow spreads
                            offset:
                                Offset(0, 5), // Position of the shadow (x, y)
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 18, bottom: 18, right: 20, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Тэмдэглэл бичих...",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.grey.shade500,
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: notesProvider.notes.length,
                itemBuilder: (context, index) {
                  final note = notesProvider.notes[index];
                  return InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: note)),
                      )
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 14, bottom: 14, right: 20, left: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF33808C),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 250,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    note.content,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  DateFormat.MMMd().format(note.timestamp),
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            // Text(note.mood, style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

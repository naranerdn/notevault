import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:notevault/screens/mood_screen.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import './to_do_screen.dart';
import './mood_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notevault/providers/notes_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  NoteDetailScreen({this.note});
  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial content in the controller
    _contentController.text = widget.note?.content ?? "";
  }

  void _saveNewNote(NotesProvider notesProvider) {
    if (_contentController.text.isNotEmpty) {
      final newNote = Note(
          content: _contentController.text,
          mood: "Happy",
          timestamp: DateTime.now());

      notesProvider.addNote(newNote);
      _contentController.clear();
      Navigator.pop(context);
    }
  }

  void _updateNote(BuildContext context, Note? note, String newContent) {
    Note newNote = Note(
        id: note?.id,
        content: newContent,
        mood: note!.mood,
        timestamp: note.timestamp);
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.updateNote(newNote);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_pattern_1.png'),
                opacity: 0.2,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(
                                  context); // Pops the current route and goes back
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Буцах',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          widget.note != null
                              ? _updateNote(
                                  context, widget.note, _contentController.text)
                              : _saveNewNote(notesProvider);
                        },
                        child: const Text("Хадгалах",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Wrap TextFormField with Expanded to make it fill the remaining space
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20), // Optional padding at the bottom
                      child: Container(
                        child: TextFormField(
                          controller: _contentController,
                          maxLines: null, // Allow multiline input
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder:
                                InputBorder.none, // Removes the default border
                            focusedBorder: InputBorder.none,
                            hintText: 'Write your note...',
                            contentPadding: EdgeInsets.all(
                                10), // Optional padding inside the field
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3E7C78),
        onPressed: () {
          notesProvider.deleteNoteById(widget.note?.id);
          Navigator.pop(context);
        },
        shape: const CircleBorder(),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    );
  }
}

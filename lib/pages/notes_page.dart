import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/models/note_database.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _textController = TextEditingController();

  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _textController,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context.read<NoteDatabase>().addNote(_textController.text);
                    _textController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('create'),
                )
              ],
            ));
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void update(Note note) {
    _textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit Note'),
              content: TextField(
                controller: _textController,
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      context
                          .read<NoteDatabase>()
                          .updateNote(note.id, _textController.text);
                      _textController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('save')),
              ],
            ));
  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Notes',
                style: GoogleFonts.dmSerifText(
                    textStyle: TextStyle(
                        fontSize: 48,
                        color: Theme.of(context).colorScheme.inversePrimary))),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return ListTile(
                    title: Text(note.text),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              update(note);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteNote(note.id);
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

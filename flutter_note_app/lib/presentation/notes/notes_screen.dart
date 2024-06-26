import 'package:flutter/material.dart';
import 'package:flutter_note_app/presentation/add_edit_note/add_edit_note_screen.dart';
import 'package:flutter_note_app/presentation/notes/components/note_item.dart';
import 'package:flutter_note_app/presentation/notes/notes_event.dart';
import 'package:flutter_note_app/presentation/notes/notes_view_model.dart';
import 'package:provider/provider.dart';

import 'components/order_section.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Note',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.onEvent(const NotesEvent.toggleOrderSection());
            },
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
          )
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isSaved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
          );

          if ((isSaved != null) && isSaved) {
            viewModel.onEvent(const NotesEvent.loadNotes());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isOrderSectionVisible
                  ? OrderSection(
                noteOrder: state.noteOrder,
                onOrderChanged: (noteOrder) {
                  viewModel.onEvent(NotesEvent.changeOrder(noteOrder));
                },
              )
                  : Container(),
            ),
            ...state.notes
                .map(
                  (note) => GestureDetector(
                onTap: () async {
                  bool? isSaved = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditNoteScreen(
                        note: note,
                      ),
                    ),
                  );

                  if (isSaved != null && isSaved) {
                    viewModel.onEvent(const NotesEvent.loadNotes());
                  }
                },
                child: NoteItem(
                  note: note,
                  onDeleteTap: () {
                    viewModel.onEvent(NotesEvent.deleteNote(note));

                    final snackBar = SnackBar(
                      content: const Text('노트가 삭제되었습니다'),
                      action: SnackBarAction(
                        label: '취소',
                        onPressed: () {
                          viewModel.onEvent(const NotesEvent.restoreNote());
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ),
            )
                .toList(),
          ],
        ),
      ),
    );
  }
}

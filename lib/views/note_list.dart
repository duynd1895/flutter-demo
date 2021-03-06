import 'package:call_api/models/api_response.dart';
import 'package:call_api/models/note_for_listing.dart';
import 'package:call_api/services/note_service.dart';
import 'package:call_api/views/note_delete.dart';
import 'package:call_api/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteService get service => GetIt.I<NoteService>();
  APIResponse<List<NoteForListing>> _apiResponse;

  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('List of notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteModify()));
        },
        child: Icon(Icons.add),
      ),
      body: _isLoading ? CircularProgressIndicator() : ListView.separated(
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.green,),
        itemBuilder: (_, index) {
          return Dismissible(
            key: ValueKey(_apiResponse.data[index].noteId),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
            },
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context,
                builder: (_) => NoteDelete()
              );
              print('Hello from DUYNV  $result');
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 16.0),
              child: Align(
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerLeft,
              ),
            ),
            child: ListTile(
              title: Text(
                _apiResponse.data[index].noteTitle,
                style: TextStyle(
                  color: Colors.blueAccent
                )
              ),
              subtitle: Text('Last edited on ${formatDateTime(_apiResponse.data[index].lastEditDateTime)}'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteModify(noteId: _apiResponse.data[index].noteId)));
              },
            ),
          );
        },
        itemCount: _apiResponse.data.length,

      )
    );
  }
}

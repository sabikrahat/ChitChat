import 'package:chitchat/pages/edit_profile.dart';
import 'package:chitchat/pages/tag_change.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.0,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.0,
              child: ListTile(
                leading: Icon(Icons.archive_rounded),
                title: Text("Edit Tags"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagChange(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

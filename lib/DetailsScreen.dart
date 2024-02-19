// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UserDetailsProvider.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userDetailsProvider = Provider.of<UserDetailsProvider>(context);
    Map<String, dynamic>? userDetails = userDetailsProvider.userDetails;
    List<dynamic>? userProjects = userDetailsProvider.userProjects;
    String? userEmail = userDetailsProvider.userEmail;
    Future<void> _launchURL() async {
      final String url =
          'https://github.com/${userDetailsProvider.userDetails?['login']}';
      try {
        await launch(url);
      } catch (e) {
        print('Error launching URL: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 5,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10, bottom: 10),
              child: Text(
                'User Details',
                style: TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 50,
                ),
              ),
            ),
          ],
        ),
      ),
      body: userDetails != null
          ? Container(
              color: Color.fromARGB(255, 163, 162, 162),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userDetails['avatar_url']),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Username: ${userDetails['login']}',
                      style: TextStyle(
                        fontFamily: 'Agbalumo',
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Description: ${userDetails['bio'] ?? "No bio available"}',
                      style: TextStyle(
                        fontFamily: 'Agbalumo',
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Projects:',
                      style: TextStyle(
                        fontFamily: 'Agbalumo',
                        fontSize: 20,
                      ),
                    ),
                    if (userProjects != null)
                      Expanded(
                        child: ListView.builder(
                          itemCount: userProjects.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                userProjects[index]['name'],
                                style: TextStyle(fontFamily: 'Agbalumo'),
                              ),
                            );
                          },
                        ),
                      ),
                    FloatingActionButton(
                      child: Icon(Icons.launch_rounded),
                      backgroundColor: Colors.black,
                      onPressed: () {
                        _launchURL();
                        print("FloatingActionButton pressed");
                      },
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

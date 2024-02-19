// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'DetailsScreen.dart';
import 'UserDetailsProvider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool loading = false;
  TextEditingController tx = TextEditingController(text: '');
  var data;
  void showUserNotFoundError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User not found'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> fetchdata(String user) async {
    setState(() {
      loading = true;
    });
    final result =
        await http.get(Uri.parse("https://api.github.com/users/$user"));
    if (result.statusCode == 200) {
      setState(() {
        data = jsonDecode(result.body);
        loading = false;
      });
    } else if (result.statusCode == 404) {
      loading = false;
      showUserNotFoundError();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Git Discover',
                style: TextStyle(
                  fontFamily: 'Agbalumo',
                  fontSize: 50,
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('images/logo.jpg'),
              radius: 30,
            )
          ],
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 163, 162, 162),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: TextField(
                cursorColor: Colors.white,
                controller: tx,
                decoration: InputDecoration(
                  hintText: 'Search',
                  focusColor: Colors.white,
                  iconColor: Colors.white,
                  hoverColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 30,
                    color: Color.fromARGB(173, 255, 255, 255),
                  ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 20),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        tx.clear();
                      });
                    },
                  ),
                ),
                onSubmitted: (String value) {
                  if (value.isNotEmpty) {
                    fetchdata(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: data != null ? 1 : 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<UserDetailsProvider>(context,
                                    listen: false)
                                .setUserDetails(data);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              data['login'],
                              style: TextStyle(
                                fontFamily: 'Agbalumo',
                                fontSize: 20,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data['avatar_url']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

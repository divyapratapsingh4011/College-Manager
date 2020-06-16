import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final dynamic data;
  final String user;
  Profile(this.data, this.user);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            child: ClipRRect(
              child: Image.network(
                data['image_url'],
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Text(
            'Name: ${data['name']}',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Phone Number: ${data['phone number']}',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Email: ${data['email']}',
            style: TextStyle(fontSize: 20),
          ),
          if (user == "User.student")
            Text(
              'Stream: ${data['stream']}',
              style: TextStyle(fontSize: 20),
            ),
          if (user == "User.student")
            Text(
              'Registration No.: ${data['registration no.']}',
              style: TextStyle(fontSize: 20),
            )
        ],
      ),
    );
  }
}

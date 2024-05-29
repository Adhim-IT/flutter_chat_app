import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_profile.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  final Function onTap;
  final Function onProfileTap;

  const ChatTile({
    Key? key,
    required this.userProfile,
    required this.onTap,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap();
      },
      dense: false,
      leading: GestureDetector(
        onTap: () {
          onProfileTap();
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            userProfile.pfpURL!,
          ),
        ),
      ),
      title: Text(userProfile.name!),
    );
  }
}

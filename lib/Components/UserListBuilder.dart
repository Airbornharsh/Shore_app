import 'package:flutter/cupertino.dart';
import 'package:shore_app/Components/Search/UserItem.dart';
import 'package:shore_app/models.dart';

class UserListBuilder extends StatelessWidget {
  const UserListBuilder({
    Key? key,
    required List<UnsignUserModel> users,
  })  : _users = users,
        super(key: key);

  final List<UnsignUserModel> _users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (ctx, i) {
        return UserItem(
          user: _users[i],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shore_app/Components/Search/UserItem.dart';
import 'package:shore_app/models.dart';
import 'package:shore_app/provider/AppSetting.dart';

class UserListBuilder extends StatefulWidget {
  Function addMoreUser;
  UserListBuilder(
      {Key? key,
      required List<UnsignUserModel> users,
      required this.addMoreUser})
      : _users = users,
        super(key: key);

  final List<UnsignUserModel> _users;

  @override
  State<UserListBuilder> createState() => _UserListBuilderState();
}

class _UserListBuilderState extends State<UserListBuilder> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller.addListener(() async {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (!isTop) {
          await widget.addMoreUser();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Provider.of<AppSetting>(context).getdarkMode
              ? Colors.grey.shade700
              : Colors.white),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget._users.length,
              controller: _controller,
              itemBuilder: (ctx, i) {
                return UserItem(
                  user: widget._users[i],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

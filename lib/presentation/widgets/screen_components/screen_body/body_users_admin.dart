import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';

class BodyUsersAdmin extends StatefulWidget {
  final List<UserEntity>? users;

  const BodyUsersAdmin({
    super.key,
    this.users,
  });

  @override
  State<BodyUsersAdmin> createState() => _BodyUsersAdminState();
}

class _BodyUsersAdminState extends State<BodyUsersAdmin> {
  List<UserEntity> _filteredUsers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final sourceUsers =
        widget.users ?? context.read<LoginBloc>().state.users ?? [];
    _filteredUsers = List.from(sourceUsers);
  }

  @override
  void didUpdateWidget(covariant BodyUsersAdmin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.users != oldWidget.users && !_isSearching) {
      final sourceUsers =
          widget.users ?? context.read<LoginBloc>().state.users ?? [];
      _filteredUsers = List.from(sourceUsers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allUsers =
        widget.users ?? context.read<LoginBloc>().state.users ?? [];
    final displayUsers = _isSearching ? _filteredUsers : allUsers;

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _isSearching = value.trim().isNotEmpty;
                  _filteredUsers = allUsers
                      .where(
                        (user) => user.name
                            .toLowerCase()
                            .contains(value.toLowerCase()),
                      )
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.username,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: displayUsers.length,
                itemBuilder: (context, index) {
                  final user = displayUsers[index];
                  return CardUser(user: user);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

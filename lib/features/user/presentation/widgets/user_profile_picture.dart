import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/user/domain/bloc/user_bloc.dart';

class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

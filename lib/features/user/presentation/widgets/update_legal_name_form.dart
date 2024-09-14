import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moniman/features/user/domain/bloc/user_bloc.dart';

class UpdateLegalNameForm extends StatelessWidget {
  final String actionLabel;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  UpdateLegalNameForm({super.key, this.actionLabel = 'Save'});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Update Legal Name'),
        const SizedBox(height: 16),
        TextField(
          autofocus: true,
          controller: firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
          ),
        ),
        const Expanded(child: SizedBox()),
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return FilledButton(
                onPressed: () {
                  context.read<UserBloc>().add(
                        UpdateUserEvent(
                          state.user.copyWith(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                          ),
                        ),
                      );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(actionLabel),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}

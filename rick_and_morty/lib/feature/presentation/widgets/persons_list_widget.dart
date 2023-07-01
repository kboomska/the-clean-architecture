import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:rick_and_morty/feature/presentation/bloc/person_list_cubit/person_list_state.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_card_widget.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';

class PersonsList extends StatelessWidget {
  const PersonsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonListCubit, PersonState>(
      builder: (context, state) {
        List<PersonEntity> persons = [];

        if (state is PersonLoading && state.isFirstFetch) {
          return _loadingIndicator();
        } else if (state is PersonLoaded) {
          persons = state.personsList;
        } else if (state is PersonError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: persons.length,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[400],
            );
          },
          itemBuilder: (context, index) {
            return PersonCard(person: persons[index]);
          },
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

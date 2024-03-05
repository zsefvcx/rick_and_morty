import 'package:flutter/material.dart';
import 'package:rick_and_morty/common/app_colors.dart';
import 'package:rick_and_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_and_morty/feature/presentation/widgets/person_cache_image.dart';

class PersonDetailPage extends StatelessWidget {
  final PersonEntity person;

  const PersonDetailPage({
    required this.person,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              width: 24,
            ),
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            PersonCacheImage(
              width: 260,
              height: 260,
              imageUrl: person.image,
            ),
            const SizedBox(
              width: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: person.status == 'Alive' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  person.status,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            _BuildText(
              text: 'Gender:',
              value: person.gender,
            ),
            _BuildText(
              text: 'Numder of episodes:',
              value: person.episode.length.toString(),
            ),
            _BuildText(
              text: 'Species:',
              value: person.species,
            ),
            _BuildText(
              text: 'Last known location:',
              value: person.location.name,
            ),
            _BuildText(
              text: 'Origin:',
              value: person.origin.name,
            ),
            _BuildText(
              text: 'Was ceated:',
              value: person.created.toIso8601String(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildText extends StatelessWidget {
  final String text;
  final String value;

  const _BuildText({required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: AppColors.grayColor,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

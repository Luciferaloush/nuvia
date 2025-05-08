import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuvia/core/extensions/navigation_extensions.dart';

import 'cubit/topic_cubit.dart';

class TopicsSelectionScreen extends StatefulWidget {
  const TopicsSelectionScreen({super.key});

  @override
  State<TopicsSelectionScreen> createState() => _TopicsSelectionScreenState();
}

class _TopicsSelectionScreenState extends State<TopicsSelectionScreen> {
  final List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicCubit()..getTopic(context),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select Your Topics'),
              actions: [
                if (selectedTopics.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (selectedTopics.length > 5) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You can select up to 5 topics only'),
                          ),
                        );
                        return;
                      }
                      context.read<TopicCubit>().selectTopics(selectedTopics, context);
                    },
                  ),
              ],
            ),
            body: BlocConsumer<TopicCubit, TopicState>(
              listener: (context, state) {
                if (state is TopicSelectionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Topics selected successfully!'),
                    ),
                  );

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/profileScreen',
                        (route) => false,
                  );

                } else if (state is TopicSelectionError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is TopicLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopicError) {
                  return Center(child: Text(state.error));
                } else if (state is TopicLoaded) {
                  final topics = context.read<TopicCubit>().topics.topics;
                  return Column(
                    children: [
                      if (selectedTopics.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Selected: ${selectedTopics.length}/5',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: topics!.length,
                          itemBuilder: (context, index) {
                            final topic = topics[index];
                            final isSelected = selectedTopics.contains(topic);
                            return CheckboxListTile(
                              title: Text(
                                topic,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    if (selectedTopics.length < 5) {
                                      selectedTopics.add(topic);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'You can select up to 5 topics only'),
                                        ),
                                      );
                                    }
                                  } else {
                                    selectedTopics.remove(topic);
                                  }
                                });
                              },
                              secondary: isSelected
                                  ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                                  : const Icon(Icons.radio_button_unchecked),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}
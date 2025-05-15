import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modle/auth/user.dart';
import 'cubit/followers_cubit.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<User> filteredFollowers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void filterFollowers(String query, List<User> following) {
    setState(() {
      filteredFollowers = following.where((follower) {
        return follower.firstname
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            follower.lastname
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowersCubit()..following(context),
      child: BlocConsumer<FollowersCubit, FollowersState>(
        listener: (context, state) {
          if (state is FollowersLoaded) {
            final cubit = FollowersCubit.get(context);
            filterFollowers(searchController.text, cubit.userFollowers);
          }
        },
        builder: (context, state) {
          final cubit = FollowersCubit.get(context);
          if (state is FollowersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FollowersError) {
            return Center(child: Text(state.error));
          }

          final followersToShow = filteredFollowers.isNotEmpty
              ? filteredFollowers
              : cubit.userFollowers;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Following'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (query) =>
                        filterFollowers(query, cubit.userFollowers),
                    decoration: InputDecoration(
                      hintText: 'Search followers...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: followersToShow.length,
                    itemBuilder: (context, index) {
                      final following = followersToShow[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            'https://picsum.photos/200',
                          ),
                        ),
                        title: Text(
                            "${following.firstname} ${following.lastname}"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .bottomSheetTheme
                                .backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Show Profile',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

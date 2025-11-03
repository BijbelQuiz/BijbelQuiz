import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import 'main_navigation_screen.dart';

import 'package:bijbelquiz/l10n/strings_nl.dart' as strings;

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(strings.AppStrings.selectProfile),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.profiles.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: () => _showAddProfileDialog(context),
                child: const Text(strings.AppStrings.createNewProfile),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.profiles.length,
            itemBuilder: (context, index) {
              final profile = provider.profiles[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(profile.name.substring(0, 1)),
                ),
                title: Text(profile.name),
                onTap: () async {
                  await provider.setActiveProfile(profile.id);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const MainNavigationScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProfileDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(strings.AppStrings.createProfile),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: strings.AppStrings.profileName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final profile = UserProfile(name: name);
                  Provider.of<ProfileProvider>(context, listen: false)
                      .addProfile(profile);
                  Navigator.of(context).pop();
                }
              },
              child: Text(strings.AppStrings.create),
            ),
          ],
        );
      },
    );
  }
}

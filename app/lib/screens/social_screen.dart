import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/strings_nl.dart' as strings;
import '../services/database_service.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<Map<String, dynamic>> _searchResults = [];
  bool _userExists = false;
  Set<String> _followingIds = {};

  @override
  void initState() {
    super.initState();
    _checkUserExists();
    _loadFollowingIds();
  }

  Future<void> _loadFollowingIds() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final clerkId = Clerk.instance.currentUser?.id;
    if (clerkId == null) return;

    final user = await dbService.getUser(clerkId);
    if (user == null) return;

    final following = await dbService.getFollowing(user['id']);
    setState(() {
      _followingIds = following.map((e) => e['id'] as String).toSet();
    });
  }

  Future<void> _checkUserExists() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final clerkId = Clerk.instance.currentUser?.id;
    if (clerkId == null) return;

    final user = await dbService.getUser(clerkId);
    if (user == null) {
      // User does not exist, so create them
      final username = Clerk.instance.currentUser?.username ?? 'user${Clerk.instance.currentUser?.id}';
      await dbService.createUser(clerkId, username);
      setState(() => _userExists = true);
    } else {
      setState(() => _userExists = true);
    }
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final results = await dbService.searchUsers(query);
    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.group_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.social,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ClerkAuthBuilder(
          signedInBuilder: (context, authState) {
            return _buildLoggedInUI(context);
          },
          signedOutBuilder: (context, authState) {
            return const Center(child: ClerkAuthentication());
          },
        ),
      ),
    );
  }

  Widget _buildLoggedInUI(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSettingsCard(context),
        const SizedBox(height: 24),
        _buildSearchBar(),
        const SizedBox(height: 24),
        _searchResults.isNotEmpty
            ? _buildSearchResults()
            : _buildFollowersSection(),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Username'),
              onTap: () => _showEditUsernameDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Edit Email'),
              onTap: () => _showEditEmailDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () => _launchClerkAccountPage(),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Manage 2FA'),
              onTap: () => _launchClerkAccountPage(),
            ),
            const SizedBox(height: 16),
            const Center(child: ClerkUserButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: _searchUsers,
      decoration: InputDecoration(
        hintText: 'Search for users...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildFollowersSection() {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final clerkId = Clerk.instance.currentUser?.id;
    if (clerkId == null) return const Center(child: Text('Not logged in.'));

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: dbService.getMutualFollowersStream(clerkId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final mutuals = snapshot.data ?? [];
        if (mutuals.isEmpty) {
          return const Center(
            child: Text('You have no mutual followers yet.'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mutual Followers',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            ...mutuals.map((user) => ListTile(
                  title: Text(user['username']),
                  trailing: Text('${user['stars'] ?? 0} stars'),
                )),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Results',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Divider(),
        ..._searchResults.map((user) {
          final isFollowing = _followingIds.contains(user['id']);
          return ListTile(
            title: Text(user['username']),
            trailing: ElevatedButton(
              onPressed: () async {
                final dbService = Provider.of<DatabaseService>(context, listen: false);
                final clerkId = Clerk.instance.currentUser?.id;
                if (clerkId == null) return;

                final currentUser = await dbService.getUser(clerkId);
                if (currentUser == null) return;

                if (isFollowing) {
                  await dbService.unfollowUser(currentUser['id'], user['id']);
                } else {
                  await dbService.followUser(currentUser['id'], user['id']);
                }
                _loadFollowingIds();
              },
              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
            ),
          );
        }),
      ],
    );
  }

  void _launchClerkAccountPage() {
    // This will redirect to the Clerk hosted account page.
    // IMPORTANT: You need to configure the Frontend API URL in your Clerk dashboard
    // and set it in your .env file.
    final clerkFrontendApi = dotenv.env['CLERK_FRONTEND_API'];
    if (clerkFrontendApi != null) {
      launchUrl(Uri.parse('$clerkFrontendApi/.clerk/user'));
    }
  }

  void _showEditUsernameDialog(BuildContext context) {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final clerkId = Clerk.instance.currentUser?.id;
    if (clerkId == null) return;

    final TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: TextField(
            controller: usernameController,
            decoration: const InputDecoration(hintText: 'New username'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await dbService.updateUsername(clerkId, usernameController.text);
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailDialog(BuildContext context) {
    _launchClerkAccountPage();
  }
}
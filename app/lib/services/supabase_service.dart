import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_service.dart';

class SupabaseService extends DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;
  Map<String, dynamic>? _currentUser;

  Future<String?> _getUserId(String clerkId) async {
    if (_currentUser == null || _currentUser!['clerk_id'] != clerkId) {
      _currentUser = await getUser(clerkId);
    }
    return _currentUser?['id'];
  }

  @override
  Future<void> createUser(String clerkId, String username) async {
    final response = await _client.from('users').insert([
      {'clerk_id': clerkId, 'username': username}
    ]);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<Map<String, dynamic>?> getUser(String clerkId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('clerk_id', clerkId)
        .single();
    return response.data;
  }

  @override
  Future<void> updateUsername(String clerkId, String newUsername) async {
    final response = await _client
        .from('users')
        .update({'username': newUsername})
        .eq('clerk_id', clerkId);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final response = await _client
        .from('users')
        .select()
        .ilike('username', '%$query%');
    return response.data ?? [];
  }

  @override
  Future<Map<String, dynamic>?> getUserStats(String clerkId) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return null;
    final response = await _client
        .from('user_stats')
        .select()
        .eq('user_id', userId)
        .single();
    return response.data;
  }

  @override
  Future<void> updateUserStats(String clerkId, Map<String, dynamic> stats) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return;
    final response = await _client
        .from('user_stats')
        .update(stats)
        .eq('user_id', userId);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPurchasedItems(String clerkId) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return [];
    final response = await _client
        .from('purchased_items')
        .select()
        .eq('user_id', userId);
    return response.data ?? [];
  }

  @override
  Future<void> addPurchasedItem(String clerkId, String itemSku) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return;
    final response = await _client
        .from('purchased_items')
        .insert({'user_id': userId, 'item_sku': itemSku});
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserProgress(String clerkId) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return [];
    final response = await _client
        .from('user_progress')
        .select()
        .eq('user_id', userId);
    return response.data ?? [];
  }

  @override
  Future<void> updateUserProgress(String clerkId, String lessonId, double progress) async {
    final userId = await _getUserId(clerkId);
    if (userId == null) return;
    final response = await _client.from('user_progress').upsert({
      'user_id': userId,
      'lesson_id': lessonId,
      'progress': progress,
    });
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<void> followUser(String followerId, String followingId) async {
    final response = await _client
        .from('follows')
        .insert({'follower_id': followerId, 'following_id': followingId});
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<void> unfollowUser(String followerId, String followingId) async {
    final response = await _client
        .from('follows')
        .delete()
        .eq('follower_id', followerId)
        .eq('following_id', followingId);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    final response = await _client
        .from('follows')
        .select('users!inner(*), user_stats!inner(*)')
        .eq('following_id', userId);
    return response.data
            ?.map((e) => {...e['users'], ...e['user_stats']})
            .toList() ??
        [];
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowing(String userId) async {
    final response = await _client
        .from('follows')
        .select('users!inner(*), user_stats!inner(*)')
        .eq('follower_id', userId);
    return response.data
            ?.map((e) => {...e['users'], ...e['user_stats']})
            .toList() ??
        [];
  }

  @override
  Future<List<Map<String, dynamic>>> getMutualFollowers(String userId) async {
    final followers = await getFollowers(userId);
    final following = await getFollowing(userId);
    final followerIds = followers.map((e) => e['id']).toSet();
    final mutuals = following.where((e) => followerIds.contains(e['id'])).toList();
    return mutuals;
  }

  @override
  Stream<List<Map<String, dynamic>>> getFollowingStream(String userId) {
    return _client
        .from('follows:follower_id=eq.$userId')
        .stream(primaryKey: ['follower_id', 'following_id']).map((event) {
      return getFollowing(userId);
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> getMutualFollowersStream(String userId) {
    return _client
        .from('follows:follower_id=eq.$userId,following_id=eq.$userId')
        .stream(primaryKey: ['follower_id', 'following_id']).asyncMap((event) {
      return getMutualFollowers(userId);
    });
  }
}

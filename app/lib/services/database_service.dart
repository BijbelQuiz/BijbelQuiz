abstract class DatabaseService {
  // Methods for user data
  Future<void> createUser(String clerkId, String username);
  Future<Map<String, dynamic>?> getUser(String clerkId);
  Future<void> updateUsername(String clerkId, String newUsername);
  Future<List<Map<String, dynamic>>> searchUsers(String query);

  // Methods for user stats
  Future<Map<String, dynamic>?> getUserStats(String clerkId);
  Future<void> updateUserStats(String clerkId, Map<String, dynamic> stats);

  // Methods for purchased items
  Future<List<Map<String, dynamic>>> getPurchasedItems(String clerkId);
  Future<void> addPurchasedItem(String clerkId, String itemSku);

  // Methods for user progress
  Future<List<Map<String, dynamic>>> getUserProgress(String clerkId);
  Future<void> updateUserProgress(String clerkId, String lessonId, double progress);

  // Methods for social features
  Future<void> followUser(String followerId, String followingId);
  Future<void> unfollowUser(String followerId, String followingId);
  Future<List<Map<String, dynamic>>> getFollowers(String userId);
  Future<List<Map<String, dynamic>>> getFollowing(String userId);
  Stream<List<Map<String, dynamic>>> getFollowingStream(String userId);
  Future<List<Map<String, dynamic>>> getMutualFollowers(String userId);
  Stream<List<Map<String, dynamic>>> getMutualFollowersStream(String userId);
}

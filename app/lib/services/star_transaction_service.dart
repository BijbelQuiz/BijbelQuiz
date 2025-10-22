import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/logger.dart';
import '../providers/game_stats_provider.dart';
import '../providers/lesson_progress_provider.dart';

/// Represents a star transaction record
class StarTransaction {
  final String id;
  final DateTime timestamp;
  final String type; // 'earned', 'spent', 'lesson_reward', 'refund', etc.
  final int amount;
  final String reason;
  final String? lessonId;
  final Map<String, dynamic>? metadata;

  StarTransaction({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.amount,
    required this.reason,
    this.lessonId,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'amount': amount,
      'reason': reason,
      'lessonId': lessonId,
      'metadata': metadata,
    };
  }

  factory StarTransaction.fromJson(Map<String, dynamic> json) {
    return StarTransaction(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
      amount: json['amount'],
      reason: json['reason'],
      lessonId: json['lessonId'],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Centralized service for managing all star transactions
class StarTransactionService {
  static const String _transactionsKey = 'star_transactions';
  static const String _totalEarnedKey = 'stars_total_earned';
  static const String _totalSpentKey = 'stars_total_spent';

  static StarTransactionService? _instance;
  static StarTransactionService get instance => _instance ??= StarTransactionService._internal();

  SharedPreferences? _prefs;
  final List<StarTransaction> _transactions = [];
  int _totalEarned = 0;
  int _totalSpent = 0;

  // Dependencies - will be injected
  GameStatsProvider? _gameStatsProvider;

  StarTransactionService._internal();

  /// Initialize the service with required dependencies
  Future<void> initialize({
    required GameStatsProvider gameStatsProvider,
    required LessonProgressProvider lessonProgressProvider,
  }) async {
    _gameStatsProvider = gameStatsProvider;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadTransactionHistory();
      AppLogger.info('StarTransactionService initialized with ${_transactions.length} transactions');
    } catch (e) {
      AppLogger.error('Failed to initialize StarTransactionService: $e');
      throw Exception('Failed to initialize star transaction service: $e');
    }
  }

  /// Load transaction history from persistent storage
  Future<void> _loadTransactionHistory() async {
    try {
      final rawTransactions = _prefs?.getStringList(_transactionsKey) ?? [];
      _transactions.clear();

      for (final raw in rawTransactions) {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          _transactions.add(StarTransaction.fromJson(json));
        } catch (e) {
          AppLogger.warning('Failed to parse transaction: $raw, error: $e');
        }
      }

      // Sort by timestamp (newest first)
      _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Calculate totals
      _totalEarned = _prefs?.getInt(_totalEarnedKey) ?? 0;
      _totalSpent = _prefs?.getInt(_totalSpentKey) ?? 0;

      AppLogger.info('Loaded ${_transactions.length} star transactions');
    } catch (e) {
      AppLogger.error('Error loading transaction history: $e');
    }
  }

  /// Save transaction to persistent storage
  Future<void> _saveTransaction(StarTransaction transaction) async {
    try {
      _transactions.insert(0, transaction); // Add to beginning for newest first

      // Keep only last 1000 transactions to prevent storage bloat
      if (_transactions.length > 1000) {
        _transactions.removeRange(1000, _transactions.length);
      }

      final rawTransactions = _transactions.map((t) => jsonEncode(t.toJson())).toList();
      await _prefs?.setStringList(_transactionsKey, rawTransactions);

      // Update totals
      if (transaction.amount > 0) {
        _totalEarned += transaction.amount;
        await _prefs?.setInt(_totalEarnedKey, _totalEarned);
      } else if (transaction.amount < 0) {
        _totalSpent += transaction.amount.abs();
        await _prefs?.setInt(_totalSpentKey, _totalSpent);
      }

      AppLogger.info('Saved star transaction: ${transaction.type} ${transaction.amount} stars - ${transaction.reason}');
    } catch (e) {
      AppLogger.error('Error saving transaction: $e');
    }
  }

  /// Get current star balance from GameStatsProvider
  int get currentBalance => _gameStatsProvider?.score ?? 0;

  /// Get total stars earned
  int get totalEarned => _totalEarned;

  /// Get total stars spent
  int get totalSpent => _totalSpent;

  /// Get transaction history
  List<StarTransaction> get transactions => List.unmodifiable(_transactions);

  /// Get recent transactions (last N transactions)
  List<StarTransaction> getRecentTransactions({int count = 10}) {
    return _transactions.take(count).toList();
  }

  /// Get transactions by type
  List<StarTransaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  /// Get transactions for a specific lesson
  List<StarTransaction> getTransactionsForLesson(String lessonId) {
    return _transactions.where((t) => t.lessonId == lessonId).toList();
  }

  /// Add stars to the user's balance
  Future<bool> addStars({
    required int amount,
    required String reason,
    String? lessonId,
    Map<String, dynamic>? metadata,
  }) async {
    if (amount <= 0) {
      AppLogger.warning('Attempted to add non-positive amount: $amount');
      return false;
    }

    try {
      // Update game stats provider
      final success = await _gameStatsProvider?.addStars(amount) ?? false;
      if (!success) {
        AppLogger.error('Failed to add stars to game stats provider');
        return false;
      }

      // Record transaction
      final transaction = StarTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        type: 'earned',
        amount: amount,
        reason: reason,
        lessonId: lessonId,
        metadata: metadata,
      );

      await _saveTransaction(transaction);

      AppLogger.info('Added $amount stars: $reason');
      return true;
    } catch (e) {
      AppLogger.error('Error adding stars: $e');
      return false;
    }
  }

  /// Spend stars from the user's balance
  Future<bool> spendStars({
    required int amount,
    required String reason,
    String? lessonId,
    Map<String, dynamic>? metadata,
  }) async {
    if (amount <= 0) {
      AppLogger.warning('Attempted to spend non-positive amount: $amount');
      return false;
    }

    if (currentBalance < amount) {
      AppLogger.warning('Insufficient stars: have $currentBalance, need $amount');
      return false;
    }

    try {
      // Update game stats provider
      final success = await _gameStatsProvider?.spendStars(amount) ?? false;
      if (!success) {
        AppLogger.error('Failed to spend stars from game stats provider');
        return false;
      }

      // Record transaction
      final transaction = StarTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        type: 'spent',
        amount: -amount, // Negative for spending
        reason: reason,
        lessonId: lessonId,
        metadata: metadata,
      );

      await _saveTransaction(transaction);

      AppLogger.info('Spent $amount stars: $reason');
      return true;
    } catch (e) {
      AppLogger.error('Error spending stars: $e');
      return false;
    }
  }

  /// Award stars for lesson completion
  Future<bool> awardLessonStars({
    required String lessonId,
    required int stars,
    required String reason,
    Map<String, dynamic>? metadata,
  }) async {
    if (stars < 0 || stars > 3) {
      AppLogger.warning('Invalid lesson stars amount: $stars (must be 0-3)');
      return false;
    }

    try {
      // Update lesson progress provider
      // Note: This is a simplified approach - in practice, you'd need to integrate
      // with the lesson completion logic to properly calculate and award stars

      // Record transaction
      final transaction = StarTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        type: 'lesson_reward',
        amount: stars,
        reason: reason,
        lessonId: lessonId,
        metadata: metadata,
      );

      await _saveTransaction(transaction);

      AppLogger.info('Awarded $stars lesson stars for $lessonId: $reason');
      return true;
    } catch (e) {
      AppLogger.error('Error awarding lesson stars: $e');
      return false;
    }
  }

  /// Refund stars (add stars with refund reason)
  Future<bool> refundStars({
    required int amount,
    required String reason,
    String? originalTransactionId,
    Map<String, dynamic>? metadata,
  }) async {
    return await addStars(
      amount: amount,
      reason: 'Refund: $reason',
      metadata: {
        ...metadata ?? {},
        'originalTransactionId': originalTransactionId,
        'refunded': true,
      },
    );
  }

  /// Get transaction statistics
  Map<String, dynamic> getTransactionStats() {
    final now = DateTime.now();
    final last24h = now.subtract(Duration(hours: 24));
    final last7d = now.subtract(Duration(days: 7));
    final last30d = now.subtract(Duration(days: 30));

    return {
      'totalTransactions': _transactions.length,
      'currentBalance': currentBalance,
      'totalEarned': _totalEarned,
      'totalSpent': _totalSpent,
      'netTotal': _totalEarned - _totalSpent,
      'transactionsLast24h': _transactions.where((t) => t.timestamp.isAfter(last24h)).length,
      'transactionsLast7d': _transactions.where((t) => t.timestamp.isAfter(last7d)).length,
      'transactionsLast30d': _transactions.where((t) => t.timestamp.isAfter(last30d)).length,
      'averageTransactionAmount': _transactions.isEmpty ? 0 : _transactions.map((t) => t.amount.abs()).reduce((a, b) => a + b) / _transactions.length,
    };
  }

  /// Export all transaction data
  Map<String, dynamic> exportData() {
    return {
      'currentBalance': currentBalance,
      'totalEarned': _totalEarned,
      'totalSpent': _totalSpent,
      'transactions': _transactions.map((t) => t.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Import transaction data (for backup/restore)
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      // This would be a complex operation requiring careful merging
      // For now, we'll just log that import was requested
      AppLogger.info('Transaction data import requested - implement based on specific requirements');
    } catch (e) {
      AppLogger.error('Error importing transaction data: $e');
    }
  }

  /// Clear all transaction history (for testing or reset)
  Future<void> clearHistory() async {
    try {
      _transactions.clear();
      _totalEarned = 0;
      _totalSpent = 0;

      await _prefs?.remove(_transactionsKey);
      await _prefs?.remove(_totalEarnedKey);
      await _prefs?.remove(_totalSpentKey);

      AppLogger.info('Star transaction history cleared');
    } catch (e) {
      AppLogger.error('Error clearing transaction history: $e');
    }
  }
}
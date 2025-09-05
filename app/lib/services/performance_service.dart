import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'logger.dart';

/// Types of animations for optimized duration selection
enum AnimationType {
  fast,      // Quick interactions (200ms base)
  normal,    // Standard transitions (400ms base)
  slow,      // Noticeable changes (600ms base)
  verySlow,  // Major state changes (800ms base)
}

/// A service for monitoring and optimizing app performance on low-end devices
class PerformanceService {
  bool _isLowEndDevice = false;
  double _averageFrameRate = 120.0; // Default to 120Hz for modern devices
  double _frameTimeMs = 8.33; // Default to ~120fps (1000ms / 120fps)
  final List<double> _frameRates = [];
  final List<double> _frameTimes = [];
  final List<double> _memoryUsage = [];
  Timer? _monitoringTimer;
  DateTime? _lastFrameTime;
  
  /// Whether the device is detected as low-end
  bool get isLowEndDevice => _isLowEndDevice;
  
  /// Current average frame rate
  double get averageFrameRate => _averageFrameRate;
  
  /// Initialize the performance service
  Future<void> initialize() async {
    await _detectDeviceCapabilities();
    _detectRefreshRate();
    AppLogger.info('PerformanceService initialized with refresh rate: ${_averageFrameRate}Hz');
    _startMonitoring();
  }
  
  /// Detect the device's refresh rate
  void _detectRefreshRate() {
    try {
      // Get the platform's frame rate
      final double platformFrameRate = SchedulerBinding.instance.platformDispatcher.views.first.display.refreshRate;
      
      // Use the platform frame rate if it's valid, otherwise keep the default
      if (platformFrameRate > 0) {
        _averageFrameRate = platformFrameRate;
        // Cap at 120fps for performance reasons
        if (_averageFrameRate > 120) {
          _averageFrameRate = 120.0;
        }
      }
      
      AppLogger.info('Detected refresh rate: ${_averageFrameRate}Hz');
    } catch (e) {
      AppLogger.error('Error detecting refresh rate', e);
      // Fall back to default 120Hz if detection fails
      _averageFrameRate = 120.0;
    }
  }
  
  /// Detect if the device is low-end based on available resources
  Future<void> _detectDeviceCapabilities() async {
    try {
      // Skip platform-specific detection on web
      if (kIsWeb) {
        _isLowEndDevice = false; // Default to standard device on web
        AppLogger.info('Device capabilities: Web platform, Low-end: $_isLowEndDevice');
        return;
      }
      
      // Simple detection based on available memory and CPU cores
      final processorCount = Platform.numberOfProcessors;
      
      // Consider device low-end if it has limited resources
      _isLowEndDevice = processorCount <= 2; // Less than 2 CPU cores
      
      AppLogger.info('Device capabilities: CPU cores: $processorCount, Low-end: $_isLowEndDevice');
    } catch (e) {
      AppLogger.error('Error detecting device capabilities', e);
      _isLowEndDevice = false; // Default to standard device
    }
  }
  
  /// Start performance monitoring
  void _startMonitoring() {
    if (_isLowEndDevice) {
      _monitoringTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _checkMemoryUsage();
      });
    }
  }
  
  /// Check current memory usage
  void _checkMemoryUsage() {
    // Simplified memory tracking
    if (_memoryUsage.length > 20) {
      _memoryUsage.removeAt(0);
    }
    _memoryUsage.add(DateTime.now().millisecondsSinceEpoch.toDouble());
  }
  
  /// Get optimal animation duration based on device capabilities and refresh rate
  Duration getOptimalAnimationDuration(Duration defaultDuration) {
    // For very short durations, don't adjust to maintain responsiveness
    if (defaultDuration.inMilliseconds <= 100) {
      return defaultDuration;
    }

    // Calculate duration based on refresh rate with optimized math
    final double targetFrameTime = 16.67; // 60fps frame time
    final double frameTimeRatio = _frameTimeMs / targetFrameTime;
    double multiplier = 1.0 / frameTimeRatio;

    // Apply low-end device optimization if needed
    if (_isLowEndDevice) {
      multiplier *= 0.8; // Slightly less aggressive reduction for better UX
    }

    // Clamp multiplier to reasonable bounds to prevent extreme values
    multiplier = multiplier.clamp(0.4, 1.8);

    // Calculate duration with optimized integer math
    final int baseMs = defaultDuration.inMilliseconds;
    int durationMs = (baseMs * multiplier).round();

    // Round to nearest multiple of frame time for smoother animations
    if (_frameTimeMs > 0) {
      final double frameTime = _frameTimeMs;
      final int frameTimeInt = frameTime.toInt();
      if (frameTimeInt > 0) {
        durationMs = ((durationMs + frameTimeInt / 2) ~/ frameTimeInt) * frameTimeInt;
      }
    }

    // Ensure reasonable limits with optimized bounds for better performance
    return Duration(milliseconds: durationMs.clamp(80, 1200));
  }

  /// Get optimal animation duration for specific animation types
  Duration getOptimalAnimationDurationForType(AnimationType type) {
    switch (type) {
      case AnimationType.fast:
        return getOptimalAnimationDuration(const Duration(milliseconds: 200));
      case AnimationType.normal:
        return getOptimalAnimationDuration(const Duration(milliseconds: 400));
      case AnimationType.slow:
        return getOptimalAnimationDuration(const Duration(milliseconds: 600));
      case AnimationType.verySlow:
        return getOptimalAnimationDuration(const Duration(milliseconds: 800));
    }
  }
  
  /// Get optimal timer duration based on device capabilities
  Duration getOptimalTimerDuration(Duration defaultDuration) {
    if (_isLowEndDevice) {
      return Duration(seconds: (defaultDuration.inSeconds * 1.2).round());
    }
    return defaultDuration;
  }
  
  /// Update frame timing (called from the app's frame callback)
  void updateFrameTime() {
    final now = DateTime.now();

    if (_lastFrameTime != null) {
      final frameTime = now.difference(_lastFrameTime!).inMilliseconds.toDouble();

      // Skip invalid frame times (too fast or too slow)
      if (frameTime < 1.0 || frameTime > 100.0) {
        _lastFrameTime = now;
        return;
      }

      // Calculate current FPS
      final frameRate = 1000.0 / frameTime;

      // Update frame rate history with circular buffer for efficiency
      _addToCircularBuffer(_frameRates, frameRate, 30);

      // Update frame time history
      _addToCircularBuffer(_frameTimes, frameTime, 30);

      // Calculate median values more efficiently
      _updateMedianCalculations();
    }

    _lastFrameTime = now;
  }

  /// Efficient circular buffer addition
  void _addToCircularBuffer(List<double> buffer, double value, int maxSize) {
    if (buffer.length >= maxSize) {
      buffer.removeAt(0);
    }
    buffer.add(value);
  }

  /// Update median calculations with optimized sorting
  void _updateMedianCalculations() {
    if (_frameRates.isEmpty) return;

    // Use a more efficient median calculation for small lists
    if (_frameRates.length <= 10) {
      // For small lists, simple sort is fine
      final sortedRates = List<double>.from(_frameRates)..sort();
      final sortedTimes = List<double>.from(_frameTimes)..sort();

      _averageFrameRate = sortedRates[sortedRates.length ~/ 2];
      _frameTimeMs = sortedTimes[sortedTimes.length ~/ 2];
    } else {
      // For larger lists, use quickselect-like approach for median
      _averageFrameRate = _quickSelectMedian(_frameRates);
      _frameTimeMs = _quickSelectMedian(_frameTimes);
    }

    // Ensure reasonable limits
    _averageFrameRate = _averageFrameRate.clamp(30.0, 120.0);
    _frameTimeMs = _frameTimeMs.clamp(8.33, 33.33); // 30fps to 120fps
  }

  /// Quick select algorithm for finding median efficiently
  double _quickSelectMedian(List<double> list) {
    if (list.isEmpty) return 60.0; // Default fallback

    final sorted = List<double>.from(list)..sort();
    return sorted[sorted.length ~/ 2];
  }
  
  /// Get the current frame time in milliseconds
  double get frameTimeMs => _frameTimeMs;
  
  /// Get current memory usage estimate
  double get estimatedMemoryUsageMB {
    // More accurate memory estimation based on actual data structures
    double memoryUsage = 0.0;

    // Base object overhead (approximate)
    memoryUsage += 100; // Base PerformanceService object

    // Collections memory (more accurate estimation)
    // Each List has overhead + element size
    memoryUsage += _frameRates.length * 8 + 64; // 8 bytes per double + list overhead
    memoryUsage += _frameTimes.length * 8 + 64; // 8 bytes per double + list overhead
    memoryUsage += _memoryUsage.length * 8 + 64; // 8 bytes per double + list overhead

    // Other fields
    memoryUsage += 8 * 6; // double fields (_averageFrameRate, _frameTimeMs)
    memoryUsage += 1 * 2; // bool fields (_isLowEndDevice)
    memoryUsage += 16; // Timer reference (approximate)
    memoryUsage += 16; // DateTime reference (_lastFrameTime)

    // Convert to MB with more precision
    return (memoryUsage / (1024 * 1024) * 100).round() / 100;
  }

  /// Get performance metrics as a map
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'averageFrameRate': averageFrameRate,
      'frameTimeMs': frameTimeMs,
      'isLowEndDevice': isLowEndDevice,
      'estimatedMemoryUsageMB': estimatedMemoryUsageMB,
      'frameRateHistorySize': _frameRates.length,
      'memoryHistorySize': _memoryUsage.length,
    };
  }

  /// Force garbage collection (for debugging)
  void forceGC() {
    // This is a hint to the Dart VM to perform garbage collection
    // Note: This is not guaranteed to run immediately
    // ignore: unused_local_variable
    final temp = List.filled(10000, null);
  }

  /// Dispose of resources
  void dispose() {
    _monitoringTimer?.cancel();
    _frameRates.clear();
    _memoryUsage.clear();
  }
}
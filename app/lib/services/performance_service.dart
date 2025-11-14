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

/// A lightweight service for optimizing app performance with event-driven monitoring
class PerformanceService {
  static const int _maxSamples = 10; // Reduced from 30 for efficiency
  static const int _lowFrameRateThreshold = 45; // FPS below which we consider performance issues
  static const int _highFrameTimeThreshold = 22; // ms - frame time above which we have issues
  
  bool _isLowEndDevice = false;
  double _averageFrameRate = 60.0; // Simplified to 60fps default
  double _frameTimeMs = 16.67; // Default to 60fps
  bool _monitoringEnabled = false;
  bool _performanceIssueDetected = false;
  
  // Simple circular buffers for basic averages
  final List<double> _frameRateSamples = [];
  final List<double> _frameTimeSamples = [];
  DateTime? _lastFrameTime;
  Timer? _monitoringTimer;
  
  /// Whether the device is detected as low-end
  bool get isLowEndDevice => _isLowEndDevice;
  
  /// Current average frame rate
  double get averageFrameRate => _averageFrameRate;
  
  /// Initialize the performance service
  Future<void> initialize() async {
    await _detectDeviceCapabilities();
    _detectRefreshRate();
    AppLogger.info('PerformanceService initialized with refresh rate: ${_averageFrameRate}Hz');
    // Don't start monitoring immediately - only when needed
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
      // Fall back to default 60Hz if detection fails
      _averageFrameRate = 60.0;
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
  
  /// Enable monitoring only when performance issues are detected
  void _enableMonitoring() {
    if (!_monitoringEnabled) {
      _monitoringEnabled = true;
      _startConditionalMonitoring();
      AppLogger.info('Performance monitoring enabled due to performance issues');
    }
  }
  
  /// Disable monitoring to save resources
  void _disableMonitoring() {
    if (_monitoringEnabled) {
      _monitoringEnabled = false;
      _monitoringTimer?.cancel();
      AppLogger.info('Performance monitoring disabled');
    }
  }
  
  /// Start conditional monitoring timer
  void _startConditionalMonitoring() {
    if (_monitoringTimer != null) return;
    
    _monitoringTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_performanceIssueDetected) {
        _checkPerformanceHealth();
      } else {
        timer.cancel();
        _monitoringTimer = null;
      }
    });
  }
  
  /// Check performance health (lightweight operation)
  void _checkPerformanceHealth() {
    // Simple check - if we've been having issues, see if they've resolved
    if (_frameRateSamples.isNotEmpty) {
      final recentAvgFrameRate = _calculateSimpleAverage(_frameRateSamples);
      if (recentAvgFrameRate > _lowFrameRateThreshold + 10) {
        // Performance seems to have improved
        _performanceIssueDetected = false;
        _disableMonitoring();
        AppLogger.info('Performance improved, disabling intensive monitoring');
      }
    }
  }
  
  /// Calculate simple average of a list of values
  double _calculateSimpleAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    double sum = 0.0;
    for (final value in values) {
      sum += value;
    }
    return sum / values.length;
  }
  
  /// Add value to circular buffer with max size
  void _addToCircularBuffer(List<double> buffer, double value, int maxSize) {
    buffer.add(value);
    if (buffer.length > maxSize) {
      buffer.removeAt(0);
    }
  }
  
  /// Check for performance issues and enable monitoring if needed
  void _checkPerformanceIssues(double frameRate, double frameTime) {
    // Check if we should enable monitoring based on current performance
    if (!_monitoringEnabled && (
        frameRate < _lowFrameRateThreshold || 
        frameTime > _highFrameTimeThreshold)) {
      _performanceIssueDetected = true;
      _enableMonitoring();
      AppLogger.warning('Performance issues detected, enabling monitoring. FPS: $frameRate, Frame time: ${frameTime}ms');
    }
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
  
  /// Update frame timing (event-driven, only when performance issues detected)
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

      // Only collect data if monitoring is enabled (event-driven)
      if (_monitoringEnabled) {
        // Update frame rate history with circular buffer for efficiency
        _addToCircularBuffer(_frameRateSamples, frameRate, _maxSamples);

        // Update frame time history
        _addToCircularBuffer(_frameTimeSamples, frameTime, _maxSamples);

        // Calculate simple averages instead of complex median calculations
        _updateSimpleAverages();

        // Continue checking for performance issues
        _checkPerformanceIssues(frameRate, frameTime);
      }
    }

    _lastFrameTime = now;
  }
  
  /// Update simple averages instead of complex median calculations
  void _updateSimpleAverages() {
    if (_frameRateSamples.isEmpty) return;

    // Use simple averages instead of complex median calculations
    _averageFrameRate = _calculateSimpleAverage(_frameRateSamples);
    _frameTimeMs = _calculateSimpleAverage(_frameTimeSamples);

    // Ensure reasonable limits
    _averageFrameRate = _averageFrameRate.clamp(30.0, 120.0);
    _frameTimeMs = _frameTimeMs.clamp(8.33, 33.33); // 30fps to 120fps
  }
  
  /// Get the current frame time in milliseconds
  double get frameTimeMs => _frameTimeMs;
  
  /// Get current memory usage estimate (simplified)
  double get estimatedMemoryUsageMB {
    // Simplified memory estimation - no complex calculations
    double memoryUsage = 0.0;

    // Base object overhead (approximate)
    memoryUsage += 100; // Base PerformanceService object

    // Collections memory (simplified estimation)
    memoryUsage += _frameRateSamples.length * 8 + 64; // 8 bytes per double + list overhead
    memoryUsage += _frameTimeSamples.length * 8 + 64; // 8 bytes per double + list overhead

    // Other fields (simplified)
    memoryUsage += 8 * 4; // double fields
    memoryUsage += 1 * 2; // bool fields
    memoryUsage += 16; // Timer reference (approximate)
    memoryUsage += 16; // DateTime reference

    // Convert to MB with simple calculation
    return (memoryUsage / (1024 * 1024) * 100).round() / 100;
  }

  /// Get performance metrics as a map
  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'averageFrameRate': averageFrameRate,
      'frameTimeMs': frameTimeMs,
      'isLowEndDevice': isLowEndDevice,
      'estimatedMemoryUsageMB': estimatedMemoryUsageMB,
      'monitoringEnabled': _monitoringEnabled,
      'performanceIssueDetected': _performanceIssueDetected,
      'frameRateHistorySize': _frameRateSamples.length,
      'frameTimeHistorySize': _frameTimeSamples.length,
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
    _frameRateSamples.clear();
    _frameTimeSamples.clear();
  }
}
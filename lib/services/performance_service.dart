import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';
import 'logger.dart';

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
    if (defaultDuration.inMilliseconds <= 150) {
      return defaultDuration;
    }
    
    // Calculate duration based on refresh rate
    final double frameTimeRatio = _frameTimeMs / 16.67; // 60fps frame time
    double multiplier = 1.0 / frameTimeRatio;
    
    // Apply low-end device optimization if needed
    if (_isLowEndDevice) {
      multiplier *= 0.7; // Reduce duration further for low-end devices
    }
    
    // Calculate duration, ensuring it's a multiple of frame time for smoothness
    int durationMs = (defaultDuration.inMilliseconds * multiplier).round();
    
    // Round to nearest multiple of frame time for smoother animations
    if (_frameTimeMs > 0) {
      final double frameTime = _frameTimeMs;
      durationMs = (durationMs / frameTime).round() * frameTime.toInt();
    }
    
    // Ensure reasonable limits
    return Duration(milliseconds: durationMs.clamp(100, 2000)); // Clamp between 100ms and 2s
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
      
      // Calculate current FPS
      final frameRate = 1000.0 / frameTime;
      
      // Update frame rate history
      _frameRates.add(frameRate);
      if (_frameRates.length > 30) { // Keep more samples for better averaging
        _frameRates.removeAt(0);
      }
      
      // Update frame time history
      _frameTimes.add(frameTime);
      if (_frameTimes.length > 30) {
        _frameTimes.removeAt(0);
      }
      
      // Calculate average frame rate (using median for better stability)
      if (_frameRates.isNotEmpty) {
        final sortedRates = List<double>.from(_frameRates)..sort();
        _averageFrameRate = sortedRates[sortedRates.length ~/ 2];
        
        // Calculate average frame time (using median)
        final sortedTimes = List<double>.from(_frameTimes)..sort();
        _frameTimeMs = sortedTimes[sortedTimes.length ~/ 2];
        
        // Ensure reasonable limits
        _averageFrameRate = _averageFrameRate.clamp(30.0, 120.0);
        _frameTimeMs = _frameTimeMs.clamp(8.33, 33.33); // 30fps to 120fps
      }
    }
    
    _lastFrameTime = now;
  }
  
  /// Get the current frame time in milliseconds
  double get frameTimeMs => _frameTimeMs;
  
  /// Dispose of resources
  void dispose() {
    _monitoringTimer?.cancel();
    _frameRates.clear();
    _memoryUsage.clear();
  }
} 
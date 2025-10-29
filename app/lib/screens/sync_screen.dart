import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/game_stats_provider.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/logger.dart';
import '../l10n/strings_nl.dart' as strings;

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _currentCode;
  List<String>? _devicesInRoom;
  bool _isLoadingDevices = false;
  String? _currentDeviceId;

  @override
  void initState() {
    super.initState();
    _setupSyncListeners();
    _getCurrentDeviceId();
    _loadDevicesInRoom();
  }

  void _setupSyncListeners() {
    final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
    final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    gameStatsProvider.setupSyncListener();
  }

  Future<void> _getCurrentDeviceId() async {
    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final deviceId = await gameStatsProvider.getCurrentDeviceId();
      setState(() {
        _currentDeviceId = deviceId;
      });
    } catch (e) {
      AppLogger.error('Error getting current device ID', e);
    }
  }

  Future<void> _removeDevice(String deviceId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.AppStrings.removeDevice),
        content: Text(strings.AppStrings.removeDeviceConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(strings.AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(strings.AppStrings.remove),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoadingDevices = true;
      });

      try {
        final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
        final success = await gameStatsProvider.removeDevice(deviceId);

        if (success) {
          AppLogger.info('Successfully removed device: $deviceId');
          // Reload the device list
          await _loadDevicesInRoom();
        } else {
          AppLogger.error('Failed to remove device: $deviceId');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to remove device'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } catch (e) {
        AppLogger.error('Error removing device: $deviceId', e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing device: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingDevices = false;
          });
        }
      }
    }
  }

  Future<void> _loadDevicesInRoom() async {
    if (!Provider.of<GameStatsProvider>(context, listen: false).syncService.isInRoom) {
      setState(() {
        _devicesInRoom = null;
      });
      return;
    }

    setState(() {
      _isLoadingDevices = true;
    });

    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final devices = await gameStatsProvider.getDevicesInRoom();
      setState(() {
        _devicesInRoom = devices;
      });
    } catch (e) {
      AppLogger.error('Error loading devices in room', e);
    } finally {
      setState(() {
        _isLoadingDevices = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload devices when the screen is rebuilt
    _loadDevicesInRoom();
  }

  @override
  void didUpdateWidget(SyncScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload devices when the widget updates
    _loadDevicesInRoom();
  }

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _error = strings.AppStrings.pleaseEnterUserId;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      final success = await gameStatsProvider.joinSyncRoom(code);

      if (success) {
        setState(() {
          _currentCode = code;
        });
        AppLogger.info('Successfully joined sync room: $code');
        Navigator.of(context).pop(true); // Return success
      } else {
        setState(() {
          _error = strings.AppStrings.failedToConnectToUser;
        });
      }
    } catch (e) {
      setState(() {
        _error = '${strings.AppStrings.errorGeneric}${e.toString()}';
      });
      AppLogger.error('Error joining sync room', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _leaveRoom() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      await gameStatsProvider.leaveSyncRoom();

      AppLogger.info('Left sync room');
      Navigator.of(context).pop(false); // Return left
    } catch (e) {
      setState(() {
        _error = '${strings.AppStrings.errorLeavingSyncRoom}${e.toString()}';
      });
      AppLogger.error('Error leaving sync room', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generateSyncCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future<void> _startRoom() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final code = _generateSyncCode();
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      final success = await gameStatsProvider.joinSyncRoom(code);

      if (success) {
        setState(() {
          _currentCode = code;
        });
        AppLogger.info('Successfully started sync room: $code');
        Navigator.of(context).pop(true); // Return success
      } else {
        setState(() {
          _error = strings.AppStrings.failedToCreateUserId;
        });
      }
    } catch (e) {
      setState(() {
        _error = '${strings.AppStrings.errorGeneric}${e.toString()}';
      });
      AppLogger.error('Error starting sync room', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameStatsProvider = Provider.of<GameStatsProvider>(context);
    final isInRoom = gameStatsProvider.syncService.isInRoom;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.userId),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    Icon(
                      Icons.sync_rounded,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.AppStrings.userId,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isInRoom 
                        ? strings.AppStrings.currentlyConnectedToUser 
                        : strings.AppStrings.userIdDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Error message
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Main content
              if (!isInRoom)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Join section
                      Text(
                        strings.AppStrings.enterUserId,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: strings.AppStrings.userIdCode,
                          hintText: 'ABC123',
                          prefixIcon: const Icon(Icons.person_rounded),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _joinRoom,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  strings.AppStrings.connectToUser,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                      
                      // Divider with OR
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              strings.AppStrings.of,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Create section
                      Text(
                        strings.AppStrings.createUserId,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        strings.AppStrings.createUserIdDescription,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _startRoom,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                )
                              : Text(
                                  strings.AppStrings.createUserIdButton,
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Currently in room view
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              strings.AppStrings.yourUserId,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                gameStatsProvider.syncService.currentRoomId ?? strings.AppStrings.unknownError,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Devices in room section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.devices_other_rounded,
                                  size: 24,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  strings.AppStrings.connectedDevices,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _isLoadingDevices
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : _devicesInRoom != null && _devicesInRoom!.isNotEmpty
                                    ? ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _devicesInRoom!.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final device = _devicesInRoom![index];
                                          final isCurrentDevice = _currentDeviceId != null && device == _currentDeviceId;
                                          
                                          return ListTile(
                                            leading: Icon(
                                              Icons.phone_android,
                                              color: isCurrentDevice 
                                                  ? colorScheme.primary 
                                                  : colorScheme.onSurfaceVariant,
                                            ),
                                            title: Text(
                                              isCurrentDevice 
                                                  ? '${strings.AppStrings.thisDevice} ($device)' 
                                                  : device,
                                              style: TextStyle(
                                                fontWeight: isCurrentDevice 
                                                    ? FontWeight.bold 
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                            trailing: isCurrentDevice
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: colorScheme.primary,
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: colorScheme.error,
                                                    ),
                                                    onPressed: () => _removeDevice(device),
                                                  ),
                                          );
                                        },
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          strings.AppStrings.noDevicesConnected,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _leaveRoom,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(color: colorScheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.link_off_rounded,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      strings.AppStrings.leaveUserId,
                                      style: TextStyle(
                                        color: colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
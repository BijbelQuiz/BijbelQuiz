import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/local_api_service.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LocalApiScreen extends StatefulWidget {
  const LocalApiScreen({super.key});

  @override
  State<LocalApiScreen> createState() => _LocalApiScreenState();
}

class _LocalApiScreenState extends State<LocalApiScreen> {
  final _portController = TextEditingController();
  final _newKeyNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final apiService = LocalApiService.instance;
    await apiService.loadSettings();
    if (!mounted) return;
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _portController.text = settings.localApiPort.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _portController.dispose();
    _newKeyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.localApi)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.localApiNotAvailableWeb,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final settings = Provider.of<SettingsProvider>(context);
    final apiService = LocalApiService.instance;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.localApi),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showApiDocumentation(context),
            tooltip: AppLocalizations.of(context)!.localApiDocumentation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildServerStatusCard(
                      context, settings, apiService, colorScheme),
                  const SizedBox(height: 16),
                  _buildApiKeysSection(context, apiService, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildServerStatusCard(
    BuildContext context,
    SettingsProvider settings,
    LocalApiService apiService,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dns, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.localApiServerStatus,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.localApiEnable,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        AppLocalizations.of(context)!.localApiEnableDesc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: apiService.isRunning,
                  onChanged: _isLoading
                      ? null
                      : (value) async {
                          setState(() => _isLoading = true);
                          try {
                            if (value) {
                              await apiService.startServer();
                            } else {
                              await apiService.stopServer();
                            }
                            await settings.setLocalApiEnabled(value);
                          } catch (e) {
                            if (context.mounted) {
                              final loc = AppLocalizations.of(context)!;
                              showTopSnackBar(
                                context,
                                '${loc.error}: $e',
                                style: TopSnackBarStyle.error,
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  activeThumbColor: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  apiService.isRunning ? Icons.check_circle : Icons.cancel,
                  color:
                      apiService.isRunning ? Colors.green : colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  apiService.isRunning
                      ? AppLocalizations.of(context)!
                          .localApiRunningOnPort(apiService.port)
                      : AppLocalizations.of(context)!.localApiStopped,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              enabled: !apiService.isRunning,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.localApiPort,
                border: const OutlineInputBorder(),
                helperText: apiService.isRunning
                    ? AppLocalizations.of(context)!.localApiStopToChangePort
                    : AppLocalizations.of(context)!.localApiPortRange,
              ),
              onSubmitted: (value) async {
                final port = int.tryParse(value);
                if (port != null && port >= 1024 && port <= 65535) {
                  await settings.setLocalApiPort(port);
                  await apiService.setPort(port);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeysSection(
    BuildContext context,
    LocalApiService apiService,
    ColorScheme colorScheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.key, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.localApiKeys,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showAddKeyDialog(context, apiService),
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.localApiAddKey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (apiService.apiKeys.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.key_off,
                          size: 48,
                          color: colorScheme.onSurface.withValues(alpha: 0.3)),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.localApiNoKeys,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apiService.apiKeys.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final key = apiService.apiKeys[index];
                  return _buildApiKeyTile(
                      context, apiService, key, colorScheme);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyTile(
    BuildContext context,
    LocalApiService apiService,
    ApiKey key,
    ColorScheme colorScheme,
  ) {
    return ListTile(
      leading: Icon(
        key.isEnabled ? Icons.key : Icons.key_off,
        color: key.isEnabled
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      title: Row(
        children: [
          Expanded(child: Text(key.name)),
          if (!key.isEnabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                AppLocalizations.of(context)!.disabled,
                style: TextStyle(
                    fontSize: 10, color: colorScheme.onErrorContainer),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          SelectableText(
            key.key,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.localApiCreated}: ${_formatDate(key.createdAt)}',
                style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
              if (key.requestCount > 0) ...[
                const SizedBox(width: 12),
                Text(
                  '${AppLocalizations.of(context)!.localApiRequests}: ${key.requestCount}',
                  style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ],
          ),
          if (key.lastUsedAt != null)
            Text(
              '${AppLocalizations.of(context)!.localApiLastUsed}: ${_formatDate(key.lastUsedAt!)}',
              style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
        ],
      ),
      isThreeLine: key.lastUsedAt != null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: key.key));
              if (context.mounted) {
                showTopSnackBar(
                  context,
                  AppLocalizations.of(context)!.localApiKeyCopied,
                  style: TopSnackBarStyle.success,
                );
              }
            },
            tooltip: AppLocalizations.of(context)!.copy,
          ),
          PopupMenuButton<String>(
            onSelected: (value) =>
                _handleKeyAction(context, apiService, key, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 20),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.localApiRenameKey),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: Row(
                  children: [
                    Icon(
                        key.isEnabled ? Icons.visibility_off : Icons.visibility,
                        size: 20),
                    const SizedBox(width: 8),
                    Text(key.isEnabled
                        ? AppLocalizations.of(context)!.localApiDisableKey
                        : AppLocalizations.of(context)!.localApiEnableKey),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'regenerate',
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 20),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.localApiRegenerateKey),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: colorScheme.error),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.localApiDeleteKey,
                        style: TextStyle(color: colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleKeyAction(
    BuildContext context,
    LocalApiService apiService,
    ApiKey key,
    String action,
  ) async {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, apiService, key);
        break;
      case 'toggle':
        await apiService.updateApiKey(key.id, isEnabled: !key.isEnabled);
        setState(() {});
        break;
      case 'regenerate':
        _showConfirmDialog(
          context,
          AppLocalizations.of(context)!.localApiRegenerateKey,
          AppLocalizations.of(context)!.localApiRegenerateKeyConfirm,
          () async {
            await apiService.regenerateKey(key.id);
            setState(() {});
          },
        );
        break;
      case 'delete':
        _showConfirmDialog(
          context,
          AppLocalizations.of(context)!.localApiDeleteKey,
          AppLocalizations.of(context)!.localApiDeleteKeyConfirm,
          () async {
            await apiService.deleteApiKey(key.id);
            setState(() {});
          },
        );
        break;
    }
  }

  void _showAddKeyDialog(BuildContext context, LocalApiService apiService) {
    _newKeyNameController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.localApiAddKey),
        content: TextField(
          controller: _newKeyNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.localApiKeyName,
            hintText: AppLocalizations.of(context)!.localApiKeyNameHint,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _newKeyNameController.text.trim();
              if (name.isEmpty) return;
              await apiService.createApiKey(name: name);
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text(AppLocalizations.of(context)!.localApiCreateKey),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(
      BuildContext context, LocalApiService apiService, ApiKey key) {
    _newKeyNameController.text = key.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.localApiRenameKey),
        content: TextField(
          controller: _newKeyNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.localApiKeyName,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _newKeyNameController.text.trim();
              if (name.isEmpty) return;
              await apiService.updateApiKey(key.id, name: name);
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
    Future<void> Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  void _showApiDocumentation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.localApiDocumentation),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.localApiEndpoints,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildEndpointDoc(context, 'GET', '/v1/health',
                  AppLocalizations.of(context)!.localApiHealthEndpoint),
              _buildEndpointDoc(context, 'GET', '/v1/questions',
                  AppLocalizations.of(context)!.localApiQuestionsEndpoint),
              _buildEndpointDoc(context, 'GET', '/v1/progress',
                  AppLocalizations.of(context)!.localApiProgressEndpoint),
              _buildEndpointDoc(context, 'GET', '/v1/stats',
                  AppLocalizations.of(context)!.localApiStatsEndpoint),
              _buildEndpointDoc(context, 'GET', '/v1/stars/balance',
                  AppLocalizations.of(context)!.localApiStarsBalanceEndpoint),
              _buildEndpointDoc(context, 'POST', '/v1/stars/add',
                  AppLocalizations.of(context)!.localApiStarsAddEndpoint),
              _buildEndpointDoc(context, 'POST', '/v1/stars/spend',
                  AppLocalizations.of(context)!.localApiStarsSpendEndpoint),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.localApiAuthHeader,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  'Authorization: Bearer YOUR_API_KEY\nX-API-Key: YOUR_API_KEY',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointDoc(
      BuildContext context, String method, String path, String description) {
    final methodColor = method == 'GET' ? Colors.green : Colors.blue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: methodColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(method,
                style: TextStyle(fontSize: 11, color: methodColor)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(path,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                Text(description,
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes < 1) {
          return AppLocalizations.of(context)!.justNow;
        }
        return '${diff.inMinutes}${AppLocalizations.of(context)!.minutesAgo}';
      }
      return '${diff.inHours}${AppLocalizations.of(context)!.hoursAgo}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}${AppLocalizations.of(context)!.daysAgo}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

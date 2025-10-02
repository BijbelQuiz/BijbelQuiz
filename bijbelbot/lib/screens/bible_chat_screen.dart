import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bible_chat_message.dart';
import '../models/bible_chat_conversation.dart';
import '../services/bible_bot_service.dart';
import '../services/connection_service.dart';
import '../services/logger.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../providers/bible_chat_provider.dart';
import '../services/gemini_service.dart';
import '../services/bible_bot_service.dart';

/// Main chat interface screen for Bible bot functionality.
///
/// This screen provides a complete chat interface with:
/// - Message list with scrollable view
/// - Integration with BibleBotService
/// - Loading states and error handling
/// - Conversation management
class BibleChatScreen extends StatefulWidget {
  /// The conversation to display/manage
  final BibleChatConversation conversation;

  /// Callback when the conversation is updated
  final Function(BibleChatConversation)? onConversationUpdated;

  /// Callback when user wants to go back
  final VoidCallback? onBackPressed;

  const BibleChatScreen({
    super.key,
    required this.conversation,
    this.onConversationUpdated,
    this.onBackPressed,
  });

  @override
  State<BibleChatScreen> createState() => _BibleChatScreenState();
}

class _BibleChatScreenState extends State<BibleChatScreen>
    with WidgetsBindingObserver {
  final BibleBotService _bibleBotService = BibleBotService.instance;
  final ConnectionService _connectionService = ConnectionService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  BibleChatProvider? _chatProvider;
  List<BibleChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectionService();
    _initializeChat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = Provider.of<BibleChatProvider>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionService.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeConnectionService() async {
    try {
      await _connectionService.initialize();
      setState(() {
        _isOnline = _connectionService.isConnected;
      });

      // Listen for connectivity changes
      _connectionService.checkConnection().then((_) {
        if (mounted) {
          setState(() {
            _isOnline = _connectionService.isConnected;
            if (!_isOnline && _errorMessage == null) {
              _errorMessage = 'Geen internetverbinding. Controleer uw netwerk en probeer opnieuw.';
            } else if (_isOnline && _errorMessage?.contains('Geen internetverbinding') == true) {
              _errorMessage = null;
            }
          });
        }
      });
    } catch (e) {
      AppLogger.error('Failed to initialize connection service', e);
    }
  }

  Future<void> _retryLastAction() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_isOnline) {
      setState(() {
        _errorMessage = 'Geen internetverbinding. Controleer uw netwerk en probeer opnieuw.';
      });
      return;
    }

    // Retry the last message if there was one
    final lastUserMessage = _messages.lastWhere(
      (message) => message.sender == MessageSender.user,
      orElse: () => _messages.isNotEmpty ? _messages.last : BibleChatMessage(
        id: '',
        content: '',
        sender: MessageSender.user,
        type: MessageType.text,
        timestamp: DateTime.now(),
      ),
    );

    if (lastUserMessage.content.isNotEmpty) {
      await _sendMessage(lastUserMessage.content);
    } else {
      // If no message to retry, just refresh the conversation
      await _refreshConversation();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshConversation();
    }
  }

  Future<void> _initializeChat() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Initialize BibleBot service if needed
      if (!_bibleBotService.isInitialized) {
        await _bibleBotService.initialize();
      }

      // Load conversation messages
      await _loadConversationMessages();

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });

      // Scroll to bottom after initialization
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollToBottom();
        }
      });
    } catch (e) {
      AppLogger.error('Failed to initialize Bible chat', e);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Kon chat niet initialiseren: ${e.toString()}';
      });
    }
  }

  Future<void> _loadConversationMessages() async {
    try {
      if (_chatProvider == null) {
        AppLogger.warning('Chat provider not available');
        setState(() {
          _messages = [];
        });
        return;
      }

      // Load messages from the provider
      final messages = _chatProvider!.getConversationMessages(widget.conversation.id);
      setState(() {
        _messages = messages;
      });

      AppLogger.info('Loaded ${messages.length} messages for conversation ${widget.conversation.id}');
    } catch (e) {
      AppLogger.error('Failed to load conversation messages', e);
      setState(() {
        _messages = [];
      });
      throw e;
    }
  }

  Future<void> _refreshConversation() async {
    if (widget.conversation.id.isEmpty) return;

    try {
      await _loadConversationMessages();
    } catch (e) {
      AppLogger.error('Failed to refresh conversation', e);
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty || _isLoading || _chatProvider == null) return;

    try {
      // Add user message through provider
      final userMessage = await _chatProvider!.addMessage(
        conversationId: widget.conversation.id,
        content: message.trim(),
        sender: MessageSender.user,
        type: MessageType.question,
      );

      setState(() {
        _messages.add(userMessage);
        _isLoading = true;
        _errorMessage = null;
      });

      // Clear input field
      _messageController.clear();

      // Scroll to bottom to show user message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

      // Send question to BibleBot service
      final response = await _bibleBotService.askQuestion(
        question: message,
        questionType: 'general_question',
        conversationId: widget.conversation.id,
      );

      // Create bot response message
      final botMessage = await _chatProvider!.addMessage(
        conversationId: widget.conversation.id,
        content: response.answer,
        sender: MessageSender.bot,
        type: MessageType.explanation,
        bibleReferences: response.references.map((ref) =>
          '${ref.book} ${ref.chapter}:${ref.verse}${ref.endVerse != null ? '-${ref.endVerse}' : ''}'
        ).toList(),
      );

      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });

      // Update conversation
      _updateConversation();

      // Scroll to bottom to show bot response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });

    } catch (e) {
      AppLogger.error('Failed to send message', e);

      // Create error message through provider
      final errorMessage = await _chatProvider!.addMessage(
        conversationId: widget.conversation.id,
        content: 'Sorry, er is een fout opgetreden bij het verwerken van uw vraag. Probeer opnieuw.',
        sender: MessageSender.bot,
        type: MessageType.text,
      );

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
        _errorMessage = e.toString();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _updateConversation() {
    if (_chatProvider == null) return;

    final updatedConversation = widget.conversation.withNewMessage(
      _messages.last.id,
    );

    // Update conversation through provider
    _chatProvider!.updateConversation(updatedConversation);

    widget.onConversationUpdated?.call(updatedConversation);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  Future<void> _showNewConversationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nieuwe Conversatie'),
          content: const Text(
            'Weet je zeker dat je een nieuwe conversatie wilt starten? De huidige conversatie wordt gewist.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Nieuwe Conversatie'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _startNewConversation();
    }
  }

  Future<void> _startNewConversation() async {
    if (_chatProvider == null) return;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Create a new conversation
      final newConversation = await _chatProvider!.createConversation(
        title: 'Nieuwe conversatie',
      );

      // Set as active conversation
      await _chatProvider!.setActiveConversation(newConversation.id);

      // Clear current messages
      setState(() {
        _messages.clear();
        _isLoading = false;
      });

      // Update the conversation through the callback
      widget.onConversationUpdated?.call(newConversation);

      AppLogger.info('Started new conversation: ${newConversation.id}');

      // Scroll to top to show empty state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });

    } catch (e) {
      AppLogger.error('Failed to start new conversation', e);
      setState(() {
        _isLoading = false;
        _errorMessage = 'Kon nieuwe conversatie niet starten: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: widget.onBackPressed != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBackPressed,
            )
          : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BijbelBot',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Stel me een vraag over de Bijbel',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          // New conversation button
          IconButton(
            onPressed: _showNewConversationDialog,
            icon: const Icon(Icons.add_comment),
            tooltip: 'Nieuwe Conversatie',
          ),
        ],
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      body: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            // Chat berichten gebied
            Expanded(
              child: _isInitialized ? _buildChatMessages() : _buildLoadingView(),
            ),

            // Foutmelding indien aanwezig
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                color: colorScheme.errorContainer,
                child: Row(
                  children: [
                    Icon(
                      _isOnline ? Icons.error_outline : Icons.wifi_off,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    if (_isOnline) ...[
                      IconButton(
                        onPressed: _retryLastAction,
                        icon: Icon(
                          Icons.refresh,
                          color: colorScheme.onErrorContainer,
                        ),
                        tooltip: 'Opnieuw',
                      ),
                      const SizedBox(width: 8),
                    ],
                    IconButton(
                      onPressed: () => setState(() => _errorMessage = null),
                      icon: Icon(
                        Icons.close,
                        color: colorScheme.onErrorContainer,
                      ),
                      tooltip: 'Sluiten',
                    ),
                  ],
                ),
              ),

            // Chat invoerveld
            ChatInputField(
              controller: _messageController,
              onSendMessage: _sendMessage,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Bijbel Chat initialiseren...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    if (_messages.isEmpty) {
      return _buildEmptyChat();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ChatMessageBubble(
            message: message,
            isError: message.type == MessageType.text &&
                     message.content.contains('Sorry, I encountered an error'),
            onBibleReferenceTap: (reference) {
              // Handle Bible reference tap - could navigate to Bible view
              AppLogger.info('Bible reference tapped: $reference');
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.outline.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 24),
          Text(
            'Start een gesprek',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Stel me een vraag over de Bijbel',
            style: TextStyle(
              color: Color(0x99000000), // 0.6 alpha for onSurface
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Sample questions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                _buildSampleQuestion('Wat zegt de Bijbel over vergeving?'),
                const SizedBox(height: 12),
                _buildSampleQuestion('Leg de gelijkenis van de verloren zoon uit'),
                const SizedBox(height: 12),
                _buildSampleQuestion('Wat is de betekenis van Johannes 3:16?'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleQuestion(String question) {
    return InkWell(
      onTap: () => _sendMessage(question),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha((0.3 * 255).round()),
          ),
        ),
        child: Text(
          question,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
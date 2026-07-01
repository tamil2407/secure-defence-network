import 'dart:async'; 
 
import 'package:flutter/material.dart'; 
 
import '../models/app_models.dart'; 
import '../services/app_demo_data.dart'; 
import '../services/app_dialogs.dart'; 
import '../services/device_share_service.dart'; 
 
class SecureChatScreen extends StatefulWidget { 
  const SecureChatScreen({super.key}); 
 
  @override 
  State<SecureChatScreen> createState() => _SecureChatScreenState(); 
} 
 
class _SecureChatScreenState extends State<SecureChatScreen> { 
  final AppDemoData _repo = AppDemoData.instance; 
  final TextEditingController _searchController = TextEditingController(); 
  final TextEditingController _messageController = TextEditingController(); 
  final ScrollController _scrollController = ScrollController(); 
 
  String _searchText = ''; 
  String? _activeThreadId; 
  bool _didReadRouteArgs = false; 
 
  bool _isRecordingVoice = false; 
  int _recordingSeconds = 0; 
  Timer? _recordingTimer; 
  String? _playingAudioMessageId; 
 
  @override 
  void initState() { 
    super.initState(); 
    _messageController.addListener(_handleTextChanged); 
  } 
 
  @override 
  void dispose() { 
    _recordingTimer?.cancel(); 
    _searchController.dispose(); 
    _messageController.removeListener(_handleTextChanged); 
    _messageController.dispose(); 
    _scrollController.dispose(); 
    super.dispose(); 
  } 
 
  void _handleTextChanged() { 
    if (mounted) {
      setState(() {}); 
    }
  } 
 
  void _readRouteArgumentsOnce() { 
    if (_didReadRouteArgs) return; 
    _didReadRouteArgs = true; 
 
    final args = ModalRoute.of(context)?.settings.arguments; 
    if (args is Map<String, dynamic>) { 
      final phone = args['phone']?.toString(); 
      final name = args['name']?.toString(); 
 
      if (phone != null) { 
        final contact = _repo.findContactByPhone(phone); 
        final thread = contact != null 
            ? _repo.createOrGetPersonalThread(contact) 
            : _repo.findPersonalThreadByPhone(phone); 
 
        if (thread != null) { 
          _activeThreadId = thread.id; 
        } else if (name != null) { 
          final newContact = PhoneContact( 
            id: 'temp_${DateTime.now().millisecondsSinceEpoch}', 
            name: name, 
            phoneNumber: phone, 
            rank: 'Officer', 
            unit: 'Secure Network', 
            status: 'Connected', 
            isOnline: true, 
          ); 
          final newThread = _repo.createOrGetPersonalThread(newContact); 
          _activeThreadId = newThread.id; 
        } 
      } 
    } 
  } 
 
  List<ChatThread> get _threads { 
    final items = _repo.personalThreads; 
    if (_searchText.trim().isEmpty) return items; 
    final query = _searchText.toLowerCase(); 
    return items.where((thread) { 
      return thread.title.toLowerCase().contains(query) || 
          thread.phoneNumber.toLowerCase().contains(query) || 
          thread.lastMessagePreview.toLowerCase().contains(query); 
    }).toList(); 
  } 
 
  ChatThread? get _activeThread => 
      _activeThreadId == null ? null : _repo.findThreadById(_activeThreadId!); 
 
  String _formatTime(DateTime? dateTime) { 
    if (dateTime == null) return ''; 
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; 
    final minute = dateTime.minute.toString().padLeft(2, '0'); 
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM'; 
    return '$hour:$minute $suffix'; 
  } 
 
  String _formatAudioDuration(int seconds) { 
    final min = (seconds ~/ 60).toString().padLeft(2, '0'); 
    final sec = (seconds % 60).toString().padLeft(2, '0'); 
    return '$min:$sec'; 
  } 
 
  String _statusText(AppMessage message) { 
    if (message.isRead) return 'Read'; 
    if (message.isDelivered) return 'Delivered'; 
    if (message.isSent) return 'Sent'; 
    return 'Sending'; 
  } 
 
  Future<void> _sendText() async { 
    final text = _messageController.text.trim(); 
    final thread = _activeThread; 
    if (thread == null || text.isEmpty) return; 
 
    _repo.sendTextMessage(threadId: thread.id, text: text); 
    _messageController.clear(); 
 
    setState(() {}); 
    _scrollToBottom(); 
  } 
 
  void _startVoiceRecording(VoidCallback onTick) { 
    if (_isRecordingVoice) return; 
 
    setState(() { 
      _isRecordingVoice = true; 
      _recordingSeconds = 0; 
    }); 
 
    _recordingTimer?.cancel(); 
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      if (!mounted) return; 
      setState(() { 
        _recordingSeconds++; 
      }); 
      onTick(); 
    }); 
  } 
 
  void _cancelVoiceRecording() { 
    _recordingTimer?.cancel(); 
    setState(() { 
      _isRecordingVoice = false; 
      _recordingSeconds = 0; 
    }); 
  } 
 
  void _sendVoiceRecording() { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    _recordingTimer?.cancel(); 
 
    final duration = _recordingSeconds <= 0 ? 1 : _recordingSeconds; 
    _repo.sendAudioMessage(threadId: thread.id, durationSeconds: duration); 
 
    setState(() { 
      _isRecordingVoice = false; 
      _recordingSeconds = 0; 
    }); 
 
    _scrollToBottom(); 
    AppDialogs.showSnack(context, 'Voice message sent.'); 
  } 
 
  Future<void> _openVoiceRecorderSheet() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    StateSetter? modalStateSetter; 
 
    _startVoiceRecording(() {
      if (modalStateSetter != null) {
        modalStateSetter!(() {});
      }
    }); 
    
    await showModalBottomSheet<void>( 
      context: context, 
      isDismissible: false, 
      enableDrag: false, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return StatefulBuilder( 
          builder: (context, modalSetState) { 
            modalStateSetter = modalSetState; 
 
            return SafeArea( 
              child: Padding( 
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), 
                child: Column( 
                  mainAxisSize: MainAxisSize.min, 
                  children: [ 
                    const Icon(Icons.mic, size: 42), 
                    const SizedBox(height: 12), 
                    const Text( 
                      'Recording Voice Message', 
                      style: TextStyle( 
                        fontSize: 18, 
                        fontWeight: FontWeight.w700, 
                      ), 
                    ), 
                    const SizedBox(height: 10), 
                    Text( 
                      _formatAudioDuration(_recordingSeconds), 
                      style: const TextStyle( 
                        fontSize: 26, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                    const SizedBox(height: 18), 
                    Row( 
                      children: [ 
                        Expanded( 
                          child: OutlinedButton.icon( 
                            onPressed: () { 
                              _cancelVoiceRecording(); 
                              Navigator.pop(context); 
                            }, 
                            icon: const Icon(Icons.close), 
                            label: const Text('Cancel'), 
                          ), 
                        ), 
                        const SizedBox(width: 12), 
                        Expanded( 
                          child: FilledButton.icon( 
                            onPressed: () { 
                              _sendVoiceRecording(); 
                              Navigator.pop(context); 
                            }, 
                            icon: const Icon(Icons.send), 
                            label: const Text('Send'), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ], 
                ), 
              ), 
            ); 
          }, 
        ); 
      }, 
    ); 
  } 
 
  void _togglePlayAudio(String messageId) { 
    setState(() { 
      if (_playingAudioMessageId == messageId) { 
        _playingAudioMessageId = null; 
      } else { 
        _playingAudioMessageId = messageId; 
      } 
    }); 
  } 
 
  void _scrollToBottom() { 
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      if (!_scrollController.hasClients) return; 
      _scrollController.animateTo( 
        _scrollController.position.maxScrollExtent + 200, 
        duration: const Duration(milliseconds: 250), 
        curve: Curves.easeOut, 
      ); 
    }); 
  } 
 
  Future<void> _sendGalleryImage() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    try { 
      final file = await DeviceShareService.pickImageFromGallery(); 
      if (file == null) return; 
 
      final confirm = await AppDialogs.confirmAttachmentSend( 
        context, 
        itemLabel: 'image', 
      ); 
      if (!confirm) return; 
 
      _repo.sendImageMessage(threadId: thread.id, path: file.path); 
      if (!mounted) return; 
      setState(() {}); 
      _scrollToBottom(); 
      AppDialogs.showSnack(context, 'Image sent securely.'); 
    } catch (_) { 
      if (!mounted) return; 
      AppDialogs.showSnack(context, 'Unable to pick image.'); 
    } 
  } 
 
  Future<void> _sendCameraImage() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    try { 
      final file = await DeviceShareService.pickImageFromCamera(); 
      if (file == null) return; 
 
      final confirm = await AppDialogs.confirmAttachmentSend( 
        context, 
        itemLabel: 'camera photo', 
      ); 
      if (!confirm) return; 
 
      _repo.sendImageMessage(threadId: thread.id, path: file.path); 
      if (!mounted) return; 
      setState(() {}); 
      _scrollToBottom(); 
      AppDialogs.showSnack(context, 'Camera image sent.'); 
    } catch (_) { 
      if (!mounted) return; 
      AppDialogs.showSnack(context, 'Unable to open camera.'); 
    } 
  } 
 
  Future<void> _sendDocument() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    try { 
      final file = await DeviceShareService.pickDocument(); 
      if (file == null) return; 
 
      final confirm = await AppDialogs.confirmAttachmentSend( 
        context, 
        itemLabel: 'document', 
      ); 
      if (!confirm) return; 
 
      _repo.sendDocumentMessage( 
        threadId: thread.id, 
        path: file.path ?? '', 
        fileName: file.name, 
      ); 
      if (!mounted) return; 
      setState(() {}); 
      _scrollToBottom(); 
      AppDialogs.showSnack(context, 'Document sent securely.'); 
    } catch (_) { 
      if (!mounted) return; 
      AppDialogs.showSnack(context, 'Unable to pick document.'); 
    } 
  } 
 
  Future<void> _sendLocation() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    try { 
      final data = await DeviceShareService.getCurrentLocation(); 
      if (data == null) return; 
 
      final confirm = await AppDialogs.confirmAttachmentSend( 
        context, 
        itemLabel: 'location', 
      ); 
      if (!confirm) return; 
 
      _repo.sendLocationMessage(threadId: thread.id, data: data); 
      if (!mounted) return; 
      setState(() {}); 
      _scrollToBottom(); 
      AppDialogs.showSnack(context, 'Location shared.'); 
    } catch (e) { 
      if (!mounted) return; 
      AppDialogs.showSnack( 
        context, 
        e.toString().replaceFirst('Exception: ', ''), 
      ); 
    } 
  } 
 
  Future<void> _openAttachmentSheet() async { 
    final theme = Theme.of(context); 
 
    await showModalBottomSheet<void>( 
      context: context, 
      backgroundColor: theme.colorScheme.surface, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), 
            child: Wrap( 
              runSpacing: 14, 
              children: [ 
                Center( 
                  child: Container( 
                    width: 48, 
                    height: 4, 
                    decoration: BoxDecoration( 
                      color: theme.colorScheme.outlineVariant, 
                      borderRadius: BorderRadius.circular(20), 
                    ), 
                  ), 
                ), 
                const SizedBox(height: 4), 
                Text( 
                  'Secure Attachment Options', 
                  style: theme.textTheme.titleMedium?.copyWith( 
                    fontWeight: FontWeight.w700, 
                  ), 
                ), 
                _attachmentTile( 
                  context, 
                  icon: Icons.photo_library_outlined, 
                  title: 'Gallery Image', 
                  subtitle: 'Pick image from gallery', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _sendGalleryImage(); 
                  }, 
                ), 
                _attachmentTile( 
                  context, 
                  icon: Icons.camera_alt_outlined, 
                  title: 'Camera', 
                  subtitle: 'Capture image and send', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _sendCameraImage(); 
                  }, 
                ), 
                _attachmentTile( 
                  context, 
                  icon: Icons.insert_drive_file_outlined, 
                  title: 'Document', 
                  subtitle: 'Send file securely', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _sendDocument(); 
                  }, 
                ), 
                _attachmentTile( 
                  context, 
                  icon: Icons.location_on_outlined, 
                  title: 'Location', 
                  subtitle: 'Share current coordinates', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _sendLocation(); 
                  }, 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _attachmentTile( 
    BuildContext context, { 
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap, 
  }) { 
    final theme = Theme.of(context); 
    return ListTile( 
      onTap: onTap, 
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(16), 
      ), 
      tileColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35), 
      leading: CircleAvatar( 
        backgroundColor: theme.colorScheme.primary.withOpacity(0.14), 
        child: Icon(icon, color: theme.colorScheme.primary), 
      ), 
      title: Text(title), 
      subtitle: Text(subtitle), 
    ); 
  } 
 
  Future<void> _deleteMessage(AppMessage message) async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    final yes = await AppDialogs.confirmDeleteMessage(context); 
    if (!yes) return; 
 
    _repo.deleteMessage(threadId: thread.id, messageId: message.id); 
    if (!mounted) return; 
    setState(() {}); 
    AppDialogs.showSnack(context, 'Message deleted.'); 
  } 
 
  Future<void> _clearChat() async { 
    final thread = _activeThread; 
    if (thread == null) return; 
 
    final yes = await AppDialogs.confirmClearChat( 
      context, 
      title: thread.title, 
    ); 
    if (!yes) return; 
 
    _repo.clearThread(thread.id); 
    if (!mounted) return; 
    setState(() {}); 
    AppDialogs.showSnack(context, 'Chat cleared.'); 
  } 
 
  void _openThreadMenu(ChatThread thread) async { 
    final theme = Theme.of(context); 
 
    await showModalBottomSheet<void>( 
      context: context, 
      backgroundColor: theme.colorScheme.surface, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), 
            child: Wrap( 
              runSpacing: 12, 
              children: [ 
                Center( 
                  child: Text( 
                    thread.title, 
                    style: theme.textTheme.titleMedium?.copyWith( 
                      fontWeight: FontWeight.w700, 
                    ), 
                  ), 
                ), 
                _sheetAction( 
                  context, 
                  icon: thread.isPinned ? Icons.push_pin : Icons.push_pin_outlined, 
                  title: thread.isPinned ? 'Unpin chat' : 'Pin chat', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _repo.toggleThreadPin(thread.id); 
                    setState(() {}); 
                  }, 
                ), 
                _sheetAction( 
                  context, 
                  icon: thread.isMuted ? Icons.volume_up : Icons.volume_off_outlined, 
                  title: thread.isMuted ? 'Unmute chat' : 'Mute chat', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _repo.toggleThreadMute(thread.id); 
                    setState(() {}); 
                  }, 
                ), 
                _sheetAction( 
                  context, 
                  icon: Icons.delete_sweep_outlined, 
                  title: 'Clear chat', 
                  onTap: () { 
                    Navigator.pop(context); 
                    _clearChat(); 
                  }, 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _sheetAction( 
    BuildContext context, { 
    required IconData icon, 
    required String title, 
    required VoidCallback onTap, 
  }) { 
    final theme = Theme.of(context); 
    return ListTile( 
      onTap: onTap, 
      tileColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      leading: Icon(icon), 
      title: Text(title), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    _readRouteArgumentsOnce(); 
 
    final theme = Theme.of(context); 
    final activeThread = _activeThread; 
 
    return Scaffold( 
      body: DecoratedBox( 
        decoration: BoxDecoration( 
          gradient: LinearGradient( 
            colors: [ 
              theme.colorScheme.surface, 
              theme.colorScheme.primary.withOpacity(0.08), 
              theme.colorScheme.surface, 
            ], 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
          ), 
        ), 
        child: SafeArea( 
          child: activeThread == null 
              ? _buildThreadList(theme) 
              : _buildConversation(theme, activeThread), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildThreadList(ThemeData theme) { 
    final threads = _threads; 
 
    return Column( 
      children: [ 
        Padding( 
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10), 
          child: Row( 
            children: [ 
              Expanded( 
                child: Text( 
                  'Secure Chat', 
                  style: theme.textTheme.headlineSmall?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
              ), 
              IconButton( 
                onPressed: () => Navigator.pushNamed(context, '/contacts'), 
                icon: const Icon(Icons.person_add_alt_1_outlined), 
                tooltip: 'Open contacts', 
              ), 
            ], 
          ), 
        ), 
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 18), 
          child: Container( 
            decoration: BoxDecoration( 
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35), 
              borderRadius: BorderRadius.circular(18), 
            ), 
            child: TextField( 
              controller: _searchController, 
              onChanged: (value) => setState(() => _searchText = value), 
              decoration: const InputDecoration( 
                hintText: 'Search conversations...', 
                prefixIcon: Icon(Icons.search), 
                border: InputBorder.none, 
                contentPadding: EdgeInsets.symmetric(vertical: 12), 
              ), 
            ), 
          ), 
        ), 
        Expanded( 
          child: threads.isEmpty 
              ? const Center(child: Text('No active conversations found.')) 
              : ListView.builder( 
                  itemCount: threads.length, 
                  padding: const EdgeInsets.all(12), 
                  itemBuilder: (context, index) { 
                    final thread = threads[index]; 
                    return Card( 
                      elevation: 0, 
                      margin: const EdgeInsets.symmetric(vertical: 4), 
                      color: thread.id == _activeThreadId 
                          ? theme.colorScheme.primaryContainer.withOpacity(0.4) 
                          : Colors.transparent, 
                      child: ListTile( 
                        onLongPress: () => _openThreadMenu(thread), 
                        onTap: () => setState(() => _activeThreadId = thread.id), 
                        leading: Badge( 
                          isLabelVisible: thread.unreadCount > 0, 
                          label: Text(thread.unreadCount.toString()), 
                          child: CircleAvatar( 
                            child: Text(thread.title.substring(0, 1).toUpperCase()), 
                          ), 
                        ), 
                        title: Row( 
                          children: [ 
                            Text(thread.title, style: const TextStyle(fontWeight: FontWeight.bold)), 
                            if (thread.isPinned) const Padding( 
                              padding: EdgeInsets.only(left: 4.0), 
                              child: Icon(Icons.push_pin, size: 12), 
                            ) 
                          ], 
                        ), 
                        subtitle: Text( 
                          thread.lastMessagePreview, 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                        ), 
                        trailing: Column( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.end, 
                          children: [ 
                            Text( 
                              _formatTime(thread.lastMessageTime), 
                              style: theme.textTheme.bodySmall, 
                            ), 
                            if (thread.isMuted) const Icon(Icons.volume_off, size: 14), 
                          ], 
                        ), 
                      ), 
                    ); 
                  }, 
                ), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildConversation(ThemeData theme, ChatThread thread) { 
    final isTextEmpty = _messageController.text.trim().isEmpty; 
 
    return Column( 
      children: [ 
        AppBar( 
          leading: IconButton( 
            icon: const Icon(Icons.arrow_back), 
            onPressed: () => setState(() => _activeThreadId = null), 
          ), 
          title: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              Text(thread.title, style: const TextStyle(fontSize: 16)), 
              Text(thread.phoneNumber, style: const TextStyle(fontSize: 12)), 
            ], 
          ), 
          actions: [ 
            IconButton( 
              icon: const Icon(Icons.delete_outline), 
              onPressed: _clearChat, 
            ) 
          ], 
        ), 
        Expanded( 
          child: ListView.builder( 
            controller: _scrollController, 
            padding: const EdgeInsets.all(16), 
            itemCount: thread.messages.length, 
            itemBuilder: (context, index) { 
              final message = thread.messages[index]; 
              final isMe = message.isMe; 
              return Align( 
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, 
                child: GestureDetector( 
                  onLongPress: () => _deleteMessage(message), 
                  child: Container( 
                    margin: const EdgeInsets.symmetric(vertical: 4), 
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), 
                    decoration: BoxDecoration( 
                      color: isMe ? theme.colorScheme.primary : theme.colorScheme.surfaceContainer, 
                      borderRadius: BorderRadius.circular(16), 
                    ), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.end, 
                      mainAxisSize: MainAxisSize.min, 
                      children: [ 
                        if (message.type == MessageType.text) 
                          Text( 
                            message.content, 
                            style: TextStyle(color: isMe ? Colors.white : Colors.black), 
                          ) 
                        else if (message.type == MessageType.audio) 
                          Row( 
                            mainAxisSize: MainAxisSize.min, 
                            children: [ 
                              IconButton( 
                                icon: Icon( 
                                  _playingAudioMessageId == message.id ? Icons.pause : Icons.play_arrow, 
                                  color: isMe ? Colors.white : Colors.black, 
                                ), 
                                onPressed: () => _togglePlayAudio(message.id), 
                              ), 
                              Text( 
                                'Voice Message (${message.mediaDurationSeconds}s)', 
                                style: TextStyle(color: isMe ? Colors.white : Colors.black), 
                              ), 
                            ], 
                          ), 
                        const SizedBox(height: 4), 
                        Row( 
                          mainAxisSize: MainAxisSize.min, 
                          children: [ 
                            Text( 
                              _formatTime(message.timestamp), 
                              style: TextStyle( 
                                fontSize: 10, 
                                color: isMe ? Colors.white70 : Colors.black54, 
                              ), 
                            ), 
                            if (isMe) ...[ 
                              const SizedBox(width: 4), 
                              Text( 
                                _statusText(message), 
                                style: const TextStyle(fontSize: 10, color: Colors.white70), 
                              ), 
                            ] 
                          ], 
                        ), 
                      ], 
                    ), 
                  ), 
                ), 
              ); 
            }, 
          ), 
        ), 
        Padding( 
          padding: const EdgeInsets.all(8.0), 
          child: Row( 
            children: [ 
              IconButton( 
                icon: const Icon(Icons.attach_file), 
                onPressed: _openAttachmentSheet, 
              ), 
              Expanded( 
                child: TextField( 
                  controller: _messageController, 
                  decoration: const InputDecoration( 
                    hintText: 'Type a message securely...', 
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24))), 
                  ), 
                ), 
              ), 
              IconButton( 
                icon: Icon(isTextEmpty ? Icons.mic : Icons.send), 
                onPressed: isTextEmpty ? _openVoiceRecorderSheet : _sendText, 
              ), 
            ], 
          ), 
        ) 
      ], 
    ); 
  } 
}
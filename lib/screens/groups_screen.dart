import 'dart:io'; 
 
import 'package:flutter/material.dart'; 
 
import '../models/app_models.dart'; 
import '../services/app_demo_data.dart'; 
import '../services/app_dialogs.dart'; 
import '../services/device_share_service.dart'; 
 
class GroupsScreen extends StatefulWidget { 
  const GroupsScreen({super.key}); 
 
  @override 
  State<GroupsScreen> createState() => _GroupsScreenState(); 
} 
 
class _GroupsScreenState extends State<GroupsScreen> { 
  final AppDemoData _repo = AppDemoData.instance; 
  final TextEditingController _searchController = TextEditingController(); 
  final TextEditingController _messageController = TextEditingController(); 
 
  String _searchText = ''; 
  String? _activeGroupId; 
 
  List<ChatThread> get _groups { 
    final items = _repo.groupThreads; 
    if (_searchText.trim().isEmpty) return items; 
    final query = _searchText.toLowerCase(); 
    return items.where((group) { 
      return group.title.toLowerCase().contains(query) || 
          group.lastMessagePreview.toLowerCase().contains(query); 
    }).toList(); 
  } 
 
  ChatThread? get _activeGroup => 
      _activeGroupId == null ? null : _repo.findThreadById(_activeGroupId!); 
 
  @override 
  void dispose() { 
    _searchController.dispose(); 
    _messageController.dispose(); 
    super.dispose(); 
  } 
 
  String _timeText(DateTime? time) { 
    if (time == null) return ''; 
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12; 
    final m = time.minute.toString().padLeft(2, '0'); 
    final s = time.hour >= 12 ? 'PM' : 'AM'; 
    return '$h:$m $s'; 
  } 
 
  Future<void> _createGroup() async { 
    final nameController = TextEditingController(); 
    final selected = <String>{}; 
 
    final created = await showModalBottomSheet<bool>( 
      context: context, 
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        final theme = Theme.of(context); 
        return StatefulBuilder( 
          builder: (context, setModalState) { 
            return SafeArea( 
              child: Padding( 
                padding: EdgeInsets.fromLTRB(
                  20, 
                  18, 
                  20, 
                  MediaQuery.of(context).viewInsets.bottom + 24, 
                ), 
                child: Column( 
                  mainAxisSize: MainAxisSize.min, 
                  children: [ 
                    Text( 
                      'Create Secure Group', 
                      style: theme.textTheme.titleLarge?.copyWith( 
                        fontWeight: FontWeight.w800, 
                      ), 
                    ), 
                    const SizedBox(height: 14), 
                    TextField( 
                      controller: nameController, 
                      decoration: const InputDecoration( 
                        labelText: 'Group name', 
                        border: OutlineInputBorder(), 
                      ), 
                    ), 
                    const SizedBox(height: 14), 
                    SizedBox( 
                      height: 260, 
                      child: ListView.builder( 
                        itemCount: _repo.contacts.length, 
                        itemBuilder: (context, index) { 
                          final contact = _repo.contacts[index]; 
                          final isChecked = selected.contains(contact.phoneNumber); 
                          return CheckboxListTile( 
                            value: isChecked, 
                            onChanged: (value) { 
                              setModalState(() { 
                                if (value == true) { 
                                  selected.add(contact.phoneNumber); 
                                } else { 
                                  selected.remove(contact.phoneNumber); 
                                } 
                              }); 
                            }, 
                            title: Text(contact.name), 
                            subtitle: Text( 
                              '${contact.rank} • ${contact.phoneNumber}', 
                            ), 
                          ); 
                        }, 
                      ), 
                    ), 
                    const SizedBox(height: 10), 
                    SizedBox( 
                      width: double.infinity, 
                      child: ElevatedButton( 
                        onPressed: () { 
                          final groupName = nameController.text.trim(); 
                          if (groupName.isEmpty || selected.length < 2) { 
                            AppDialogs.showSnack( 
                              context, 
                              'Enter group name and choose at least 2 members.', 
                            ); 
                            return; 
                          } 
 
                          final members = _repo.contacts 
                              .where((c) => selected.contains(c.phoneNumber)) 
                              .toList(); 
 
                          final group = _repo.createGroup( 
                            groupName: groupName, 
                            members: members, 
                          ); 
 
                          _activeGroupId = group.id; 
                          Navigator.pop(context, true); 
                        }, 
                        child: const Text('Create Group'), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
            ); 
          }, 
        ); 
      }, 
    ); 
 
    if (created == true && mounted) { 
      setState(() {}); 
      AppDialogs.showSnack(context, 'Group created.'); 
    } 
  } 
 
  Future<void> _sendText() async { 
    final group = _activeGroup; 
    final text = _messageController.text.trim(); 
    if (group == null || text.isEmpty) return; 
 
    _repo.sendTextMessage(threadId: group.id, text: text); 
    _messageController.clear(); 
    setState(() {}); 
  } 
 
  Future<void> _sendImage() async { 
    final group = _activeGroup; 
    if (group == null) return; 
 
    final image = await DeviceShareService.pickImageFromGallery(); 
    if (image == null) return; 
 
    final confirm = await AppDialogs.confirmAttachmentSend( 
      context, 
      itemLabel: 'group image', 
    ); 
    if (!confirm) return; 
 
    _repo.sendImageMessage(threadId: group.id, path: image.path); 
    if (!mounted) return; 
    setState(() {}); 
  } 
 
  Future<void> _sendDocument() async { 
    final group = _activeGroup; 
    if (group == null) return; 
 
    final file = await DeviceShareService.pickDocument(); 
    if (file == null) return; 
 
    final confirm = await AppDialogs.confirmAttachmentSend( 
      context, 
      itemLabel: 'group document', 
    ); 
    if (!confirm) return; 
 
    _repo.sendDocumentMessage( 
      threadId: group.id, 
      path: file.path ?? '', 
      fileName: file.name, 
    ); 
    if (!mounted) return; 
    setState(() {}); 
  } 
 
  Future<void> _sendLocation() async { 
    final group = _activeGroup; 
    if (group == null) return; 
 
    try { 
      final data = await DeviceShareService.getCurrentLocation(); 
      if (data == null) return; 
 
      final confirm = await AppDialogs.confirmAttachmentSend( 
        context, 
        itemLabel: 'group location', 
      ); 
      if (!confirm) return; 
 
      _repo.sendLocationMessage(threadId: group.id, data: data); 
      if (!mounted) return; 
      setState(() {}); 
    } catch (e) { 
      if (!mounted) return; 
      AppDialogs.showSnack(context, e.toString().replaceFirst('Exception: ', '')); 
    } 
  } 
 
  Future<void> _clearGroup() async { 
    final group = _activeGroup; 
    if (group == null) return; 
 
    final yes = await AppDialogs.confirmClearChat( 
      context, 
      title: group.title, 
    ); 
    if (!yes) return; 
 
    _repo.clearThread(group.id); 
    if (!mounted) return; 
    setState(() {}); 
    AppDialogs.showSnack(context, 'Group chat cleared.'); 
  } 
 
  Future<void> _deleteMessage(AppMessage message) async { 
    final group = _activeGroup; 
    if (group == null) return; 
 
    final yes = await AppDialogs.confirmDeleteMessage(context); 
    if (!yes) return; 
 
    _repo.deleteMessage(threadId: group.id, messageId: message.id); 
    if (!mounted) return; 
    setState(() {}); 
  } 
 
  void _showGroupInfo(ChatThread group) { 
    final members = group.memberPhones 
        .map((phone) => _repo.findContactByPhone(phone)) 
        .whereType<PhoneContact>() 
        .toList(); 
 
    showModalBottomSheet<void>( 
      context: context, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        final theme = Theme.of(context); 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                Text( 
                  group.title, 
                  style: theme.textTheme.titleLarge?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
                const SizedBox(height: 8), 
                Text( 
                  '${members.length} members • Secure group channel', 
                  style: theme.textTheme.bodyMedium, 
                ), 
                const SizedBox(height: 16), 
                ...members.map( 
                  (member) => ListTile( 
                    leading: CircleAvatar(child: Text(member.initials)), 
                    title: Text(member.name), 
                    subtitle: Text('${member.rank} • ${member.phoneNumber}'), 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _attachmentButton({ 
    required IconData icon, 
    required VoidCallback onTap, 
  }) { 
    return IconButton(onPressed: onTap, icon: Icon(icon)); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    final activeGroup = _activeGroup; 
 
    return Scaffold( 
      body: DecoratedBox( 
        decoration: BoxDecoration( 
          gradient: LinearGradient( 
            colors: [ 
              theme.colorScheme.surface, 
              theme.colorScheme.primary.withOpacity(0.07), 
              theme.colorScheme.surface, 
            ], 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
          ), 
        ), 
        child: SafeArea( 
          child: activeGroup == null 
              ? _buildGroupsList(theme) 
              : _buildGroupChat(theme, activeGroup), 
        ), 
      ), 
      floatingActionButton: activeGroup == null 
          ? FloatingActionButton.extended( 
              onPressed: _createGroup, 
              icon: const Icon(Icons.group_add_outlined), 
              label: const Text('New Group'), 
            ) 
          : null, 
    ); 
  } 
 
  Widget _buildGroupsList(ThemeData theme) { 
    final groups = _groups; 
 
    return Column( 
      children: [ 
        Padding( 
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 10), 
          child: Row( 
            children: [ 
              Expanded( 
                child: Text( 
                  'Groups', 
                  style: theme.textTheme.headlineSmall?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
              ), 
              IconButton( 
                onPressed: _createGroup, 
                icon: const Icon(Icons.group_add_outlined), 
              ), 
            ], 
          ), 
        ), 
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 18), 
          child: TextField( 
            controller: _searchController, 
            onChanged: (value) => setState(() => _searchText = value), 
            decoration: InputDecoration( 
              hintText: 'Search secure groups', 
              prefixIcon: const Icon(Icons.search), 
              filled: true, 
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35), 
              border: OutlineInputBorder( 
                borderRadius: BorderRadius.circular(18), 
                borderSide: BorderSide.none, 
              ), 
            ), 
          ), 
        ), 
        const SizedBox(height: 12), 
        Expanded( 
          child: groups.isEmpty 
              ? Center( 
                  child: Text( 
                    'No groups found.', 
                    style: theme.textTheme.bodyLarge, 
                  ), 
                ) 
              : ListView.builder( 
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 20), 
                  itemCount: groups.length, 
                  itemBuilder: (context, index) { 
                    final group = groups[index]; 
                    return Card( 
                      elevation: 0, 
                      margin: const EdgeInsets.only(bottom: 10), 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(18), 
                      ), 
                      child: ListTile( 
                        onTap: () => setState(() => _activeGroupId = group.id), 
                        onLongPress: () => _showGroupInfo(group), 
                        contentPadding: const EdgeInsets.all(14), 
                        leading: const CircleAvatar( 
                          radius: 26, 
                          child: Icon(Icons.groups_2_outlined), 
                        ), 
                        title: Text( 
                          group.title, 
                          style: const TextStyle(fontWeight: FontWeight.w700), 
                        ), 
                        subtitle: Padding( 
                          padding: const EdgeInsets.only(top: 4), 
                          child: Text( 
                            group.lastMessagePreview, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                          ), 
                        ), 
                        trailing: Column( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [ 
                            Text( 
                              _timeText(group.lastMessageTime), 
                              style: theme.textTheme.bodySmall, 
                            ), 
                            const SizedBox(height: 6), 
                            Text( 
                              '${group.memberPhones.length} members', 
                              style: theme.textTheme.bodySmall, 
                            ), 
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
 
  Widget _buildGroupChat(ThemeData theme, ChatThread group) { 
    return Column( 
      children: [ 
        Container( 
          margin: const EdgeInsets.fromLTRB(14, 14, 14, 10), 
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
          decoration: BoxDecoration( 
            borderRadius: BorderRadius.circular(22), 
            color: theme.colorScheme.surface.withOpacity(0.9), 
          ), 
          child: Row( 
            children: [ 
              IconButton( 
                onPressed: () => setState(() => _activeGroupId = null), 
                icon: const Icon(Icons.arrow_back), 
              ), 
              const CircleAvatar(child: Icon(Icons.groups)), 
              const SizedBox(width: 12), 
              Expanded( 
                child: InkWell( 
                  onTap: () => _showGroupInfo(group), 
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [ 
                      Text( 
                        group.title, 
                        style: theme.textTheme.titleMedium?.copyWith( 
                          fontWeight: FontWeight.w700, 
                        ), 
                      ), 
                      Text( 
                        '${group.memberPhones.length} members', 
                        style: theme.textTheme.bodySmall, 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
              PopupMenuButton<String>( 
                onSelected: (value) { 
                  if (value == 'info') { 
                    _showGroupInfo(group); 
                  } else if (value == 'pin') { 
                    _repo.toggleThreadPin(group.id); 
                    setState(() {}); 
                  } else if (value == 'mute') { 
                    _repo.toggleThreadMute(group.id); 
                    setState(() {}); 
                  } else if (value == 'clear') { 
                    _clearGroup(); 
                  } 
                }, 
                itemBuilder: (context) => [ 
                  const PopupMenuItem(value: 'info', child: Text('Group info')), 
                  PopupMenuItem( 
                    value: 'pin', 
                    child: Text(group.isPinned ? 'Unpin group' : 'Pin group'), 
                  ), 
                  PopupMenuItem( 
                    value: 'mute', 
                    child: Text(group.isMuted ? 'Unmute group' : 'Mute group'), 
                  ), 
                  const PopupMenuItem(value: 'clear', child: Text('Clear chat')), 
                ], 
              ), 
            ], 
          ), 
        ), 
        Expanded( 
          child: group.messages.isEmpty 
              ? Center( 
                  child: Text( 
                    'No messages yet in this secure group.', 
                    style: theme.textTheme.bodyLarge, 
                  ), 
                ) 
              : ListView.builder( 
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 8), 
                  itemCount: group.messages.length, 
                  itemBuilder: (context, index) { 
                    final msg = group.messages[index]; 
                    return Align( 
                      alignment: 
                          msg.isMe ? Alignment.centerRight : Alignment.centerLeft, 
                      child: GestureDetector( 
                        onLongPress: () => _deleteMessage(msg), 
                        child: Container( 
                          constraints: const BoxConstraints(maxWidth: 310), 
                          margin: const EdgeInsets.only(bottom: 10), 
                          padding: const EdgeInsets.all(12), 
                          decoration: BoxDecoration( 
                            borderRadius: BorderRadius.circular(18), 
                            color: msg.isMe 
                                ? theme.colorScheme.primary.withOpacity(0.18) 
                                : theme.colorScheme.surfaceContainerHighest 
                                    .withOpacity(0.42), 
                          ), 
                          child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [ 
                              if (!msg.isMe) 
                                Padding( 
                                  padding: const EdgeInsets.only(bottom: 6), 
                                  child: Text( 
                                    msg.senderName, 
                                    style: theme.textTheme.bodySmall?.copyWith( 
                                      fontWeight: FontWeight.w700, 
                                      color: theme.colorScheme.primary, 
                                    ), 
                                  ), 
                                ), 
                              _messageContent(theme, msg), 
                              const SizedBox(height: 6), 
                              Text( 
                                _timeText(msg.timestamp), 
                                style: theme.textTheme.bodySmall, 
                              ), 
                            ], 
                          ), 
                        ), 
                      ), 
                    ); 
                  }, 
                ), 
        ), 
        Container( 
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), 
          color: theme.colorScheme.surface, 
          child: Row( 
            children: [ 
              _attachmentButton(icon: Icons.image_outlined, onTap: _sendImage), 
              _attachmentButton(icon: Icons.file_present_outlined, onTap: _sendDocument), 
              _attachmentButton(icon: Icons.location_on_outlined, onTap: _sendLocation), 
              Expanded( 
                child: TextField( 
                  controller: _messageController, 
                  decoration: const InputDecoration( 
                    hintText: 'Type secure message...', 
                    border: InputBorder.none, 
                  ), 
                ), 
              ), 
              IconButton( 
                icon: const Icon(Icons.send), 
                onPressed: _sendText, 
              ), 
            ], 
          ), 
        ), 
      ], 
    ); 
  } 
 
  Widget _messageContent(ThemeData theme, AppMessage msg) { 
    if (msg.type == MessageType.image) { 
      return Image.file(File(msg.contentPath ?? '')); 
    } else if (msg.type == MessageType.document) { 
      return Row( 
        mainAxisSize: MainAxisSize.min, 
        children: [ 
          const Icon(Icons.description), 
          const SizedBox(width: 6), 
          Flexible(child: Text(msg.fileName ?? 'Document')), 
        ], 
      ); 
    } else if (msg.type == MessageType.location) { 
      return const Row( 
        mainAxisSize: MainAxisSize.min, 
        children: [ 
          Icon(Icons.map), 
          SizedBox(width: 6), 
          Text('Shared Location'), 
        ], 
      ); 
    } 
    return Text(msg.text ?? ''); 
  } 
}
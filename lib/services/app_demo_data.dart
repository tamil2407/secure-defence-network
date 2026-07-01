import 'dart:math'; 
import '../models/app_models.dart'; 
 
class AppDemoData { 
  AppDemoData._internal() { 
    _seedIfNeeded(); 
  } 
 
  static final AppDemoData instance = AppDemoData._internal(); 
 
  final List<PhoneContact> _contacts = []; 
  final List<ChatThread> _threads = []; 
  final List<CallRecord> _callHistory = []; 
  final List<MeetingRecord> _meetings = []; 
 
  List<PhoneContact> get contacts => List.unmodifiable(_contacts); 
 
  List<ChatThread> get personalThreads { 
    final items = _threads.where((e) => !e.isGroup).toList(); 
    items.sort(_threadSort); 
    return items; 
  } 
 
  List<ChatThread> get groupThreads { 
    final items = _threads.where((e) => e.isGroup).toList(); 
    items.sort(_threadSort); 
    return items; 
  } 
 
  List<CallRecord> get callHistory { 
    final items = [..._callHistory]; 
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp)); 
    return items; 
  } 
 
  List<MeetingRecord> get meetings { 
    final items = [..._meetings]; 
    items.sort((a, b) => b.timestamp.compareTo(a.timestamp)); 
    return items; 
  } 
 
  List<PhoneContact> get recentContacts { 
    final orderedPhones = <String>[]; 
 
    final sortedCalls = [..._callHistory] 
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); 
 
    for (final call in sortedCalls) { 
      if (!orderedPhones.contains(call.phoneNumber)) { 
        orderedPhones.add(call.phoneNumber); 
      } 
    } 
 
    final sortedThreads = [...personalThreads] 
      ..sort((a, b) { 
        final at = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0); 
        final bt = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0); 
        return bt.compareTo(at); 
      }); 
 
    for (final thread in sortedThreads) { 
      if (!orderedPhones.contains(thread.phoneNumber)) { 
        orderedPhones.add(thread.phoneNumber); 
      } 
    } 
 
    final recent = <PhoneContact>[]; 
    for (final phone in orderedPhones) { 
      final contact = findContactByPhone(phone); 
      if (contact != null) { 
        recent.add(contact); 
      } 
    } 
 
    if (recent.isEmpty) { 
      return contacts.take(3).toList(); 
    } 
 
    return recent.take(3).toList(); 
  } 
 
  int _threadSort(ChatThread a, ChatThread b) { 
    if (a.isPinned != b.isPinned) { 
      return a.isPinned ? -1 : 1; 
    } 
    final aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0); 
    final bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0); 
    return bTime.compareTo(aTime); 
  } 
 
  void _seedIfNeeded() { 
    if (_contacts.isNotEmpty) return; 
 
    _contacts.addAll([ 
      const PhoneContact( 
        id: 'c1', 
        name: 'Arjun Rao', 
        phoneNumber: '+91 98765 40001', 
        rank: 'Captain', 
        unit: 'Northern Command', 
        status: 'Secure channel ready', 
        isOnline: true, 
        isFavorite: true, 
      ), 
      const PhoneContact( 
        id: 'c2', 
        name: 'Vikram Singh', 
        phoneNumber: '+91 98765 40002', 
        rank: 'Major', 
        unit: 'Signals Division', 
        status: 'On patrol', 
        isOnline: true, 
        isFavorite: true, 
      ), 
      const PhoneContact( 
        id: 'c3', 
        name: 'Rohan Iyer', 
        phoneNumber: '+91 98765 40003', 
        rank: 'Lieutenant', 
        unit: 'Cyber Unit', 
        status: 'In briefing', 
        isOnline: false, 
      ), 
      const PhoneContact( 
        id: 'c4', 
        name: 'Karan Dev', 
        phoneNumber: '+91 98765 40004', 
        rank: 'Colonel', 
        unit: 'Air Defence', 
        status: 'HQ secure room', 
        isOnline: false, 
      ), 
      const PhoneContact( 
        id: 'c5', 
        name: 'Sanjay Menon', 
        phoneNumber: '+91 98765 40005', 
        rank: 'Commander', 
        unit: 'Naval Link', 
        status: 'Available', 
        isOnline: true, 
      ), 
      const PhoneContact( 
        id: 'c6', 
        name: 'Meera Nair', 
        phoneNumber: '+91 98765 40006', 
        rank: 'Analyst', 
        unit: 'Intelligence', 
        status: 'Monitoring', 
        isOnline: true, 
      ), 
    ]); 
 
    _threads.addAll([ 
      ChatThread( 
        id: 't1', 
        title: 'Arjun Rao', 
        phoneNumber: '+91 98765 40001', 
        isGroup: false, 
        memberPhones: const ['+91 98765 40001'], 
        isPinned: true, 
        messages: [ 
          _incoming( 
            threadId: 't1', 
            sender: 'Arjun Rao', 
            phone: '+91 98765 40001', 
            text: 'Mission file received. Awaiting next command.', 
            time: DateTime.now().subtract(const Duration(minutes: 38)), 
          ), 
          _outgoing( 
            threadId: 't1', 
            text: 'Proceed to checkpoint delta and stay on secure channel.', 
            time: DateTime.now().subtract(const Duration(minutes: 32)), 
            isRead: true, 
          ), 
        ], 
      ), 
      ChatThread( 
        id: 't2', 
        title: 'Vikram Singh', 
        phoneNumber: '+91 98765 40002', 
        isGroup: false, 
        memberPhones: const ['+91 98765 40002'], 
        messages: [ 
          _incoming( 
            threadId: 't2', 
            sender: 'Vikram Singh', 
            phone: '+91 98765 40002', 
            text: 'Need updated coordinates for convoy reroute.', 
            time: DateTime.now().subtract(const Duration(hours: 1, minutes: 5)), 
          ), 
        ], 
      ), 
      ChatThread( 
        id: 'g1', 
        title: 'Operation Shield', 
        phoneNumber: 'GROUP-001', 
        isGroup: true, 
        memberPhones: const [ 
          '+91 98765 40001', 
          '+91 98765 40002', 
          '+91 98765 40003', 
          '+91 98765 40006', 
        ], 
        isPinned: true, 
        messages: [ 
          _incoming( 
            threadId: 'g1', 
            sender: 'Meera Nair', 
            phone: '+91 98765 40006', 
            text: 'Recon data synced to secure node.', 
            time: DateTime.now().subtract(const Duration(hours: 2)), 
          ), 
          _incoming( 
            threadId: 'g1', 
            sender: 'Vikram Singh', 
            phone: '+91 98765 40002', 
            text: 'Alpha squad in position.', 
            time: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)), 
          ), 
          _outgoing( 
            threadId: 'g1', 
            text: 'Maintain radio silence unless priority code red.', 
            time: DateTime.now().subtract(const Duration(hours: 1, minutes: 25)), 
            isRead: true, 
          ), 
        ], 
      ), 
      ChatThread( 
        id: 'g2', 
        title: 'HQ Briefing Cell', 
        phoneNumber: 'GROUP-002', 
        isGroup: true, 
        memberPhones: const [ 
          '+91 98765 40004', 
          '+91 98765 40005', 
          '+91 98765 40006', 
        ], 
        messages: [ 
          _incoming( 
            threadId: 'g2', 
            sender: 'Karan Dev', 
            phone: '+91 98765 40004', 
            text: 'Briefing pushed for 1800 hours.', 
            time: DateTime.now().subtract(const Duration(hours: 3)), 
          ), 
        ], 
      ), 
    ]); 
 
    _callHistory.addAll([ 
      CallRecord( 
        id: 'call1', 
        name: 'Arjun Rao', 
        phoneNumber: '+91 98765 40001', 
        callType: CallType.voice, 
        isOutgoing: true, 
        isMissed: false, 
        timestamp: DateTime.now().subtract(const Duration(minutes: 52)), 
      ), 
      CallRecord( 
        id: 'call2', 
        name: 'Vikram Singh', 
        phoneNumber: '+91 98765 40002', 
        callType: CallType.video, 
        isOutgoing: false, 
        isMissed: true, 
        timestamp: DateTime.now().subtract(const Duration(hours: 4)), 
      ), 
    ]); 
 
    _meetings.addAll([ 
      MeetingRecord( 
        id: 'm1', 
        title: 'Morning Secure Brief', 
        code: 'DEF-2741', 
        timestamp: DateTime.now().subtract(const Duration(hours: 5)), 
      ), 
      MeetingRecord( 
        id: 'm2', 
        title: 'Ops Review', 
        code: 'OPS-6014', 
        timestamp: DateTime.now().subtract(const Duration(days: 1)), 
      ), 
    ]); 
  } 
 
  static AppMessage _incoming({ 
    required String threadId, 
    required String sender, 
    required String phone, 
    required String text, 
    required DateTime time, 
  }) { 
    return AppMessage( 
      id: '${threadId}_${time.millisecondsSinceEpoch}_${Random().nextInt(999)}', 
      threadId: threadId, 
      senderName: sender, 
      senderPhone: phone, 
      text: text, 
      type: MessageType.text, 
      isMe: false, 
      timestamp: time, 
      isSent: true, 
      isDelivered: true, 
      isRead: true, 
    ); 
  } 
 
  static AppMessage _outgoing({ 
    required String threadId, 
    required String text, 
    required DateTime time, 
    bool isRead = false, 
  }) { 
    return AppMessage( 
      id: '${threadId}_${time.millisecondsSinceEpoch}_${Random().nextInt(999)}', 
      threadId: threadId, 
      senderName: 'You', 
      senderPhone: '+91 90000 00000', 
      text: text, 
      type: MessageType.text, 
      isMe: true, 
      timestamp: time, 
      isSent: true, 
      isDelivered: true, 
      isRead: isRead, 
    ); 
  } 
 
  PhoneContact? findContactByPhone(String phone) { 
    try { 
      return _contacts.firstWhere((c) => c.phoneNumber == phone); 
    } catch (_) { 
      return null; 
    } 
  } 
 
  ChatThread? findThreadById(String id) { 
    try { 
      return _threads.firstWhere((e) => e.id == id); 
    } catch (_) { 
      return null; 
    } 
  } 
 
  ChatThread? findPersonalThreadByPhone(String phone) { 
    try { 
      return _threads.firstWhere( 
        (e) => !e.isGroup && e.phoneNumber == phone, 
      ); 
    } catch (_) { 
      return null; 
    } 
  } 
 
  ChatThread createOrGetPersonalThread(PhoneContact contact) { 
    final existing = findPersonalThreadByPhone(contact.phoneNumber); 
    if (existing != null) return existing; 
 
    final thread = ChatThread( 
      id: 't_${DateTime.now().millisecondsSinceEpoch}', 
      title: contact.name, 
      phoneNumber: contact.phoneNumber, 
      isGroup: false, 
      memberPhones: [contact.phoneNumber], 
      messages: [], 
    ); 
 
    _threads.add(thread); 
    return thread; 
  } 
 
  void addContact({ 
    required String name, 
    required String phoneNumber, 
    required String rank, 
    required String unit, 
    required String status, 
  }) { 
    final existing = findContactByPhone(phoneNumber.trim()); 
    if (existing != null) return; 
 
    _contacts.insert( 
      0, 
      PhoneContact( 
        id: 'c_${DateTime.now().millisecondsSinceEpoch}', 
        name: name.trim(), 
        phoneNumber: phoneNumber.trim(), 
        rank: rank.trim(), 
        unit: unit.trim(), 
        status: status.trim(), 
        isOnline: true, 
      ), 
    ); 
  } 
 
  void deleteContact(String phoneNumber) { 
    _contacts.removeWhere((c) => c.phoneNumber == phoneNumber); 
  } 
 
  ChatThread createGroup({ 
    required String groupName, 
    required List<PhoneContact> members, 
  }) { 
    final groupId = 'g_${DateTime.now().millisecondsSinceEpoch}'; 
    final thread = ChatThread( 
      id: groupId, 
      title: groupName, 
      phoneNumber: 'GROUP-${_threads.length + 1}', 
      isGroup: true, 
      memberPhones: members.map((e) => e.phoneNumber).toList(), 
      messages: [ 
        AppMessage( 
          id: 'sys_${DateTime.now().millisecondsSinceEpoch}', 
          threadId: groupId, 
          senderName: 'System', 
          senderPhone: 'SYSTEM', 
          text: 'Group created securely.', 
          type: MessageType.system, 
          isMe: false, 
          timestamp: DateTime.now(), 
        ), 
      ], 
    ); 
    _threads.add(thread); 
    return thread; 
  } 
 
  void toggleThreadPin(String threadId) { 
    final index = _threads.indexWhere((e) => e.id == threadId); 
    if (index == -1) return; 
    final current = _threads[index]; 
    _threads[index] = current.copyWith(isPinned: !current.isPinned); 
  } 
 
  void toggleThreadMute(String threadId) { 
    final index = _threads.indexWhere((e) => e.id == threadId); 
    if (index == -1) return; 
    final current = _threads[index]; 
    _threads[index] = current.copyWith(isMuted: !current.isMuted); 
  } 
 
  void sendTextMessage({ 
    required String threadId, 
    required String text, 
  }) { 
    _appendMessage( 
      threadId: threadId, 
      message: AppMessage( 
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: threadId, 
        senderName: 'You', 
        senderPhone: '+91 90000 00000', 
        text: text, 
        type: MessageType.text, 
        isMe: true, 
        timestamp: DateTime.now(), 
        isSent: true, 
        isDelivered: true, 
        isRead: false, 
      ), 
    ); 
  } 
 
  void sendImageMessage({ 
    required String threadId, 
    required String path, 
  }) { 
    _appendMessage( 
      threadId: threadId, 
      message: AppMessage( 
        id: 'img_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: threadId, 
        senderName: 'You', 
        senderPhone: '+91 90000 00000', 
        type: MessageType.image, 
        isMe: true, 
        timestamp: DateTime.now(), 
        filePath: path, 
        fileName: path.split('/').last, 
        isSent: true, 
        isDelivered: true, 
      ), 
    ); 
  } 
 
  void sendDocumentMessage({ 
    required String threadId, 
    required String path, 
    required String fileName, 
  }) { 
    _appendMessage( 
      threadId: threadId, 
      message: AppMessage( 
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: threadId, 
        senderName: 'You', 
        senderPhone: '+91 90000 00000', 
        type: MessageType.document, 
        isMe: true, 
        timestamp: DateTime.now(), 
        filePath: path, 
        fileName: fileName, 
        isSent: true, 
        isDelivered: true, 
      ), 
    ); 
  } 
 
  void sendLocationMessage({ 
    required String threadId, 
    required SharedLocationData data, 
  }) { 
    _appendMessage( 
      threadId: threadId, 
      message: AppMessage( 
        id: 'loc_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: threadId, 
        senderName: 'You', 
        senderPhone: '+91 90000 00000', 
        type: MessageType.location, 
        isMe: true, 
        timestamp: DateTime.now(), 
        latitude: data.latitude, 
        longitude: data.longitude, 
        text: data.label, 
        isSent: true, 
        isDelivered: true, 
      ), 
    ); 
  } 
 
  void sendAudioMessage({ 
    required String threadId, 
    required int durationSeconds, 
  }) { 
    _appendMessage( 
      threadId: threadId, 
      message: AppMessage( 
        id: 'audio_${DateTime.now().millisecondsSinceEpoch}', 
        threadId: threadId, 
        senderName: 'You', 
        senderPhone: '+91 90000 00000', 
        type: MessageType.audio, 
        isMe: true, 
        timestamp: DateTime.now(), 
        audioDurationSeconds: durationSeconds, 
        isSent: true, 
        isDelivered: true, 
      ), 
    ); 
  } 
 
  void deleteMessage({ 
    required String threadId, 
    required String messageId, 
  }) { 
    final index = _threads.indexWhere((e) => e.id == threadId); 
    if (index == -1) return; 
    final current = _threads[index]; 
    final updatedMessages = 
        current.messages.where((e) => e.id != messageId).toList(); 
    _threads[index] = current.copyWith(messages: updatedMessages); 
  } 
 
  void clearThread(String threadId) { 
    final index = _threads.indexWhere((e) => e.id == threadId); 
    if (index == -1) return; 
    final current = _threads[index]; 
    _threads[index] = current.copyWith(messages: []); 
  } 
 
  void _appendMessage({ 
    required String threadId, 
    required AppMessage message, 
  }) { 
    final index = _threads.indexWhere((e) => e.id == threadId); 
    if (index == -1) return; 
    final current = _threads[index]; 
    final updatedMessages = [...current.messages, message]; 
    _threads[index] = current.copyWith( 
      messages: updatedMessages, 
      unreadCount: 0, 
    ); 
  } 
 
  void addCallRecord({ 
    required String name, 
    required String phoneNumber, 
    required CallType type, 
    required bool isOutgoing, 
    bool isMissed = false, 
  }) { 
    _callHistory.insert( 
      0, 
      CallRecord( 
        id: 'call_${DateTime.now().millisecondsSinceEpoch}', 
        name: name, 
        phoneNumber: phoneNumber, 
        callType: type, 
        isOutgoing: isOutgoing, 
        isMissed: isMissed, 
        timestamp: DateTime.now(), 
      ), 
    ); 
  } 
 
  void addMeeting({ 
    required String title, 
    required String code, 
  }) { 
    _meetings.insert( 
      0, 
      MeetingRecord( 
        id: 'meeting_${DateTime.now().millisecondsSinceEpoch}', 
        title: title, 
        code: code, 
        timestamp: DateTime.now(), 
      ), 
    ); 
  } 
}
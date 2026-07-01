import 'package:flutter/material.dart';

enum MessageType {
  text, 
  image, 
  document, 
  location, 
  audio, 
  system, 
} 

enum CallType { 
  voice, 
  video, 
} 

class PhoneContact { 
  final String id; 
  final String name; 
  final String phoneNumber; 
  final String rank; 
  final String unit; 
  final String status; 
  final bool isOnline; 
  final bool isFavorite; 
 
  const PhoneContact({ 
    required this.id, 
    required this.name, 
    required this.phoneNumber, 
    required this.rank, 
    required this.unit, 
    required this.status, 
    required this.isOnline, 
    this.isFavorite = false, 
  }); 
 
  String get initials { 
    final parts = name.trim().split(' '); 
    if (parts.isEmpty) return 'U'; 
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase(); 
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase(); 
  } 
 
  PhoneContact copyWith({ 
    String? id, 
    String? name, 
    String? phoneNumber, 
    String? rank, 
    String? unit, 
    String? status, 
    bool? isOnline, 
    bool? isFavorite, 
  }) { 
    return PhoneContact( 
      id: id ?? this.id, 
      name: name ?? this.name, 
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      rank: rank ?? this.rank, 
      unit: unit ?? this.unit, 
      status: status ?? this.status, 
      isOnline: isOnline ?? this.isOnline, 
      isFavorite: isFavorite ?? this.isFavorite, 
    ); 
  } 
} 

class AppMessage { 
  final String id; 
  final String threadId; 
  final String senderName; 
  final String senderPhone; 
  final String? text; 
  final MessageType type; 
  final bool isMe; 
  final DateTime timestamp; 
  final bool isSent; 
  final bool isDelivered; 
  final bool isRead; 
  final String? filePath; 
  final String? fileName; 
  final double? latitude; 
  final double? longitude; 
  final int? audioDurationSeconds; 
 
  const AppMessage({ 
    required this.id, 
    required this.threadId, 
    required this.senderName, 
    required this.senderPhone, 
    required this.type, 
    required this.isMe, 
    required this.timestamp, 
    this.text, 
    this.isSent = true, 
    this.isDelivered = true, 
    this.isRead = false, 
    this.filePath, 
    this.fileName, 
    this.latitude, 
    this.longitude, 
    this.audioDurationSeconds, 
  }); 

  // UI Compatibility Getters
  String get content => text ?? '';
  String? get contentPath => filePath;
  int? get mediaDurationSeconds => audioDurationSeconds;
 
  AppMessage copyWith({ 
    String? id, 
    String? threadId, 
    String? senderName, 
    String? senderPhone, 
    String? text, 
    MessageType? type, 
    bool? isMe, 
    DateTime? timestamp, 
    bool? isSent, 
    bool? isDelivered, 
    bool? isRead, 
    String? filePath, 
    String? fileName, 
    double? latitude, 
    double? longitude, 
    int? audioDurationSeconds, 
  }) { 
    return AppMessage( 
      id: id ?? this.id, 
      threadId: threadId ?? this.threadId, 
      senderName: senderName ?? this.senderName, 
      senderPhone: senderPhone ?? this.senderPhone, 
      text: text ?? this.text, 
      type: type ?? this.type, 
      isMe: isMe ?? this.isMe, 
      timestamp: timestamp ?? this.timestamp, 
      isSent: isSent ?? this.isSent, 
      isDelivered: isDelivered ?? this.isDelivered, 
      isRead: isRead ?? this.isRead, 
      filePath: filePath ?? this.filePath, 
      fileName: fileName ?? this.fileName, 
      latitude: latitude ?? this.latitude, 
      longitude: longitude ?? this.longitude, 
      audioDurationSeconds: audioDurationSeconds ?? this.audioDurationSeconds, 
    ); 
  } 
} 

class ChatThread { 
  final String id; 
  final String title; 
  final String phoneNumber; 
  final bool isGroup; 
  final List<String> memberPhones; 
  final bool isPinned; 
  final bool isMuted; 
  final int unreadCount; 
  final List<AppMessage> messages; 
 
  const ChatThread({ 
    required this.id, 
    required this.title, 
    required this.phoneNumber, 
    required this.isGroup, 
    required this.memberPhones, 
    required this.messages, 
    this.isPinned = false, 
    this.isMuted = false, 
    this.unreadCount = 0, 
  }); 
 
  // Dynamic Calculation based on messages
  DateTime? get lastMessageTime => messages.isNotEmpty ? messages.last.timestamp : null;

  String get lastMessagePreview {
    if (messages.isEmpty) return 'No messages yet';
    final last = messages.last;

    switch (last.type) {
      case MessageType.text:
        return last.text ?? '';
      case MessageType.image:
        return '📷 Image';
      case MessageType.document:
        return '📄 ${last.fileName ?? "Document"}';
      case MessageType.location:
        return '📍 Shared location';
      case MessageType.audio:
        return '🎤 Voice message';
      case MessageType.system:
        return last.text ?? 'System update';
    }
  }
 
  ChatThread copyWith({ 
    String? id, 
    String? title, 
    String? phoneNumber, 
    bool? isGroup, 
    List<String>? memberPhones, 
    bool? isPinned, 
    bool? isMuted, 
    int? unreadCount, 
    List<AppMessage>? messages, 
  }) { 
    return ChatThread( 
      id: id ?? this.id, 
      title: title ?? this.title, 
      phoneNumber: phoneNumber ?? this.phoneNumber, 
      isGroup: isGroup ?? this.isGroup, 
      memberPhones: memberPhones ?? this.memberPhones, 
      isPinned: isPinned ?? this.isPinned, 
      isMuted: isMuted ?? this.isMuted, 
      unreadCount: unreadCount ?? this.unreadCount, 
      messages: messages ?? this.messages, 
    ); 
  } 
} 

class CallRecord { 
  final String id; 
  final String name; 
  final String phoneNumber; 
  final CallType callType; 
  final bool isOutgoing; 
  final bool isMissed; 
  final DateTime timestamp; 
 
  const CallRecord({ 
    required this.id, 
    required this.name, 
    required this.phoneNumber, 
    required this.callType, 
    required this.isOutgoing, 
    required this.isMissed, 
    required this.timestamp, 
  }); 
} 

class MeetingRecord { 
  final String id; 
  final String title; 
  final String code; 
  final DateTime timestamp; 
 
  const MeetingRecord({ 
    required this.id, 
    required this.title, 
    required this.code, 
    required this.timestamp, 
  }); 
} 

class SharedLocationData { 
  final double latitude; 
  final double longitude; 
  final String label; 
 
  const SharedLocationData({ 
    required this.latitude, 
    required this.longitude, 
    required this.label, 
  }); 
} 

class UiChipData { 
  final String label; 
  final IconData icon; 
 
  const UiChipData({ 
    required this.label, 
    required this.icon, 
  }); 
}
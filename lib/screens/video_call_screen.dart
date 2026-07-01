
 
import 'dart:math'; 
 
import 'package:flutter/material.dart'; 
 
import '../models/app_models.dart'; 
import '../services/app_demo_data.dart'; 
import '../services/app_dialogs.dart'; 
 
class VideoCallScreen extends StatefulWidget { 
  const VideoCallScreen({super.key}); 
 
  @override 
  State<VideoCallScreen> createState() => _VideoCallScreenState(); 
} 
 
class _VideoCallScreenState extends State<VideoCallScreen> { 
  final AppDemoData _repo = AppDemoData.instance; 
  final TextEditingController _joinCodeController = TextEditingController(); 
 
  bool _didReadArgs = false; 
  String? _quickName; 
  String? _quickPhone; 
 
  @override 
  void dispose() { 
    _joinCodeController.dispose(); 
    super.dispose(); 
  } 
 
  void _readArgsOnce() { 
    if (_didReadArgs) return; 
    _didReadArgs = true; 
 
    final args = ModalRoute.of(context)?.settings.arguments; 
    if (args is Map<String, dynamic>) { 
      _quickPhone = args['phone']?.toString(); 
      _quickName = args['name']?.toString(); 
    } 
  } 
 
  String _generateMeetingCode() { 
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ'; 
    final random = Random(); 
    final left = List.generate(3, (_) => letters[random.nextInt(letters.length)]).join(); 
    final right = List.generate(4, (_) => random.nextInt(10).toString()).join(); 
    return '$left-$right'; 
  } 
 
  Future<void> _startInstantMeeting({ 
    String? title, 
    String? name, 
    String? phone, 
  }) async { 
    final code = _generateMeetingCode(); 
    final meetingTitle = title ?? (name != null ? 'Call with $name' : 'Instant Secure Meet'); 
 
    _repo.addMeeting(title: meetingTitle, code: code); 
 
    if (name != null && phone != null) { 
      _repo.addCallRecord( 
        name: name, 
        phoneNumber: phone, 
        type: CallType.video, 
        isOutgoing: true, 
      ); 
    } 
 
    if (!mounted) return; 
    setState(() {}); 
 
    await _showMeetingDialog( 
      title: meetingTitle, 
      code: code, 
      subtitle: name != null ? 'Connecting to $name (demo)' : 'Meeting started successfully (demo)', 
    ); 
  } 
 
  Future<void> _joinMeeting() async { 
    final code = _joinCodeController.text.trim(); 
    if (code.isEmpty) { 
      AppDialogs.showSnack(context, 'Enter meeting code.'); 
      return; 
    } 
 
    _repo.addMeeting(title: 'Joined Secure Meeting', code: code); 
    if (!mounted) return; 
    setState(() {}); 
 
    await _showMeetingDialog( 
      title: 'Joined Secure Meeting', 
      code: code, 
      subtitle: 'Joined with code (demo)', 
    ); 
  } 
 
  Future<void> _showMeetingDialog({ 
    required String title, 
    required String code, 
    required String subtitle, 
  }) async { 
    final theme = Theme.of(context); 
 
    await showModalBottomSheet<void>( 
      context: context, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                Icon( 
                  Icons.verified_user_outlined, 
                  size: 46, 
                  color: theme.colorScheme.primary, 
                ), 
                const SizedBox(height: 12), 
                Text( 
                  title, 
                  style: theme.textTheme.titleLarge?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
                const SizedBox(height: 8), 
                Text('Meeting code: $code'), 
                const SizedBox(height: 6), 
                Text(subtitle), 
                const SizedBox(height: 18), 
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [ 
                    _circleControl( 
                      icon: Icons.mic_off_outlined, 
                      label: 'Mute', 
                      onTap: () => AppDialogs.showSnack(context, 'Mic muted.'), 
                    ), 
                    _circleControl( 
                      icon: Icons.videocam_off_outlined, 
                      label: 'Camera', 
                      onTap: () => AppDialogs.showSnack(context, 'Camera toggled.'), 
                    ), 
                    _circleControl( 
                      icon: Icons.call_end, 
                      label: 'Leave', 
                      backgroundColor: Colors.red, 
                      onTap: () => Navigator.pop(context), 
                    ), 
                  ], 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _circleControl({ 
    required IconData icon, 
    required String label, 
    required VoidCallback onTap, 
    Color? backgroundColor, 
  }) { 
    return Column( 
      children: [ 
        CircleAvatar( 
          radius: 28, 
          backgroundColor: backgroundColor, 
          child: IconButton( 
            onPressed: onTap, 
            icon: Icon(icon, color: Colors.white), 
          ), 
        ), 
        const SizedBox(height: 8), 
        Text(label), 
      ], 
    ); 
  } 
 
  String _timeText(DateTime time) { 
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12; 
    final m = time.minute.toString().padLeft(2, '0'); 
    final s = time.hour >= 12 ? 'PM' : 'AM'; 
    return '$h:$m $s'; 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    _readArgsOnce(); 
 
    final theme = Theme.of(context); 
    final meetings = _repo.meetings; 
 
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
          child: Column( 
            children: [ 
              Padding( 
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10), 
                child: Row( 
                  children: [ 
                    Expanded( 
                      child: Text( 
                        'Video Call', 
                        style: theme.textTheme.headlineSmall?.copyWith( 
                          fontWeight: FontWeight.w800, 
                        ), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
              Expanded( 
                child: ListView( 
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20), 
                  children: [ 
                    if (_quickName != null && _quickPhone != null) 
                      Container( 
                        margin: const EdgeInsets.only(bottom: 14), 
                        padding: const EdgeInsets.all(16), 
                        decoration: BoxDecoration( 
                          borderRadius: BorderRadius.circular(22), 
                          gradient: LinearGradient( 
                            colors: [ 
                              theme.colorScheme.primary.withOpacity(0.18), 
                              theme.colorScheme.primary.withOpacity(0.06), 
                            ], 
                          ), 
                        ), 
                        child: Column( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [ 
                            Text( 
                              'Quick Video Connect', 
                              style: theme.textTheme.titleMedium?.copyWith( 
                                fontWeight: FontWeight.w800, 
                              ), 
                            ), 
                            const SizedBox(height: 8), 
                            Text('$_quickName • $_quickPhone'), 
                            const SizedBox(height: 14), 
                            FilledButton.icon( 
                              onPressed: () { 
                                _startInstantMeeting( 
                                  title: 'Direct Secure Video', 
                                  name: _quickName, 
                                  phone: _quickPhone, 
                                ); 
                              }, 
                              icon: const Icon(Icons.videocam), 
                              label: const Text('Start Video Call'), 
                            ), 
                          ], 
                        ), 
                      ), 
                    _topActionCard( 
                      theme, 
                      icon: Icons.video_call_outlined, 
                      title: 'New Meeting', 
                      subtitle: 'Create instant secure meeting', 
                      onTap: () => _startInstantMeeting(), 
                    ), 
                    const SizedBox(height: 12), 
                    _joinCard(theme), 
                    const SizedBox(height: 16), 
                    Text( 
                      'Recent Meetings', 
                      style: theme.textTheme.titleMedium?.copyWith( 
                        fontWeight: FontWeight.w700, 
                      ), 
                    ), 
                    const SizedBox(height: 10), 
                    if (meetings.isEmpty) 
                      Card( 
                        elevation: 0, 
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(18), 
                        ), 
                        child: const Padding( 
                          padding: EdgeInsets.all(18), 
                          child: Text('No recent meetings yet.'), 
                        ), 
                      ) 
                    else 
                      ...meetings.map( 
                        (meeting) => Card( 
                          elevation: 0, 
                          margin: const EdgeInsets.only(bottom: 10), 
                          shape: RoundedRectangleBorder( 
                            borderRadius: BorderRadius.circular(18), 
                          ), 
                          child: ListTile( 
                            leading: const CircleAvatar( 
                              child: Icon(Icons.video_camera_front_outlined), 
                            ), 
                            title: Text( 
                              meeting.title, 
                              style: const TextStyle(fontWeight: FontWeight.w700), 
                            ), 
                            subtitle: Text( 
                              '${meeting.code}\n${_timeText(meeting.timestamp)}', 
                            ), 
                            isThreeLine: true, 
                            trailing: IconButton( 
                              onPressed: () { 
                                _joinCodeController.text = meeting.code; 
                                _joinMeeting(); 
                              }, 
                              icon: const Icon(Icons.login), 
                            ), 
                          ), 
                        ), 
                      ), 
                    const SizedBox(height: 10), 
                    Text( 
                      'Video Contacts', 
                      style: theme.textTheme.titleMedium?.copyWith( 
                        fontWeight: FontWeight.w700, 
                      ), 
                    ), 
                    const SizedBox(height: 10), 
                    ..._repo.contacts.map( 
                      (contact) => Card( 
                        elevation: 0, 
                        margin: const EdgeInsets.only(bottom: 10), 
                        shape: RoundedRectangleBorder( 
                          borderRadius: BorderRadius.circular(18), 
                        ), 
                        child: ListTile( 
                          leading: CircleAvatar(child: Text(contact.initials)), 
                          title: Text( 
                            contact.name, 
                            style: const TextStyle(fontWeight: FontWeight.w700), 
                          ), 
                          subtitle: Text('${contact.rank} • ${contact.phoneNumber}'), 
                          trailing: IconButton( 
                            onPressed: () { 
                              _startInstantMeeting( 
                                title: 'Direct Secure Video', 
                                name: contact.name, 
                                phone: contact.phoneNumber, 
                              ); 
                            }, 
                            icon: const Icon(Icons.videocam_outlined), 
                          ), 
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
 
  Widget _topActionCard( 
    ThemeData theme, { 
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap, 
  }) { 
    return InkWell( 
      onTap: onTap, 
      borderRadius: BorderRadius.circular(22), 
      child: Container( 
        padding: const EdgeInsets.all(18), 
        decoration: BoxDecoration( 
          borderRadius: BorderRadius.circular(22), 
          gradient: LinearGradient( 
            colors: [ 
              theme.colorScheme.primary.withOpacity(0.18), 
              theme.colorScheme.primary.withOpacity(0.06), 
            ], 
          ), 
        ), 
        child: Row( 
          children: [ 
            CircleAvatar( 
              radius: 24, 
              child: Icon(icon), 
            ), 
            const SizedBox(width: 14), 
            Expanded( 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  Text( 
                    title, 
                    style: theme.textTheme.titleMedium?.copyWith( 
                      fontWeight: FontWeight.w800, 
                    ), 
                  ), 
                  const SizedBox(height: 4), 
                  Text(subtitle), 
                ], 
              ), 
            ), 
            const Icon(Icons.arrow_forward_ios_rounded, size: 16), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  Widget _joinCard(ThemeData theme) { 
    return Container( 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration( 
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3), 
        borderRadius: BorderRadius.circular(22), 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Text( 
            'Join with Code', 
            style: theme.textTheme.titleMedium?.copyWith( 
              fontWeight: FontWeight.w800, 
            ), 
          ), 
          const SizedBox(height: 12), 
          TextField( 
            controller: _joinCodeController, 
            decoration: const InputDecoration( 
              labelText: 'Meeting code', 
              border: OutlineInputBorder(), 
            ), 
          ), 
          const SizedBox(height: 12), 
          FilledButton.icon( 
            onPressed: _joinMeeting, 
            icon: const Icon(Icons.login), 
            label: const Text('Join Meeting'), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
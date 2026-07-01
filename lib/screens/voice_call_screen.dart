
 
import 'package:flutter/material.dart'; 
 
import '../models/app_models.dart'; 
import '../services/app_demo_data.dart'; 
import '../services/app_dialogs.dart'; 
 
class VoiceCallScreen extends StatefulWidget { 
  const VoiceCallScreen({super.key}); 
 
  @override 
  State<VoiceCallScreen> createState() => _VoiceCallScreenState(); 
} 
 
class _VoiceCallScreenState extends State<VoiceCallScreen> { 
  final AppDemoData _repo = AppDemoData.instance; 
  final TextEditingController _numberController = TextEditingController(); 
 
  bool _didReadArgs = false; 
  String? _selectedName; 
 
  @override 
  void dispose() { 
    _numberController.dispose(); 
    super.dispose(); 
  } 
 
  void _readArgsOnce() { 
    if (_didReadArgs) return; 
    _didReadArgs = true; 
 
    final args = ModalRoute.of(context)?.settings.arguments; 
    if (args is Map<String, dynamic>) { 
      final phone = args['phone']?.toString(); 
      final name = args['name']?.toString(); 
      if (phone != null && phone.isNotEmpty) { 
        _numberController.text = phone; 
      } 
      if (name != null && name.isNotEmpty) { 
        _selectedName = name; 
      } 
    } 
  } 
 
  Future<void> _startCall({ 
    required String phone, 
    String? name, 
  }) async { 
    final cleanPhone = phone.trim(); 
    if (cleanPhone.isEmpty) { 
      AppDialogs.showSnack(context, 'Enter a phone number first.'); 
      return; 
    } 
 
    final displayName = name?.trim().isNotEmpty == true 
        ? name!.trim() 
        : (_repo.findContactByPhone(cleanPhone)?.name ?? 'Unknown Contact'); 
 
    _repo.addCallRecord( 
      name: displayName, 
      phoneNumber: cleanPhone, 
      type: CallType.voice, 
      isOutgoing: true, 
    ); 
 
    if (!mounted) return; 
    setState(() {}); 
 
    await showModalBottomSheet<void>( 
      context: context, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        final theme = Theme.of(context); 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24), 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                CircleAvatar( 
                  radius: 34, 
                  child: Text( 
                    displayName.substring(0, 1).toUpperCase(), 
                    style: const TextStyle(fontWeight: FontWeight.bold), 
                  ), 
                ), 
                const SizedBox(height: 14), 
                Text( 
                  displayName, 
                  style: theme.textTheme.titleLarge?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
                const SizedBox(height: 6), 
                Text(cleanPhone), 
                const SizedBox(height: 8), 
                Text( 
                  'Secure voice call started (demo)', 
                  style: theme.textTheme.bodyMedium, 
                ), 
                const SizedBox(height: 18), 
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [ 
                    _callCircleButton( 
                      icon: Icons.mic_off_outlined, 
                      label: 'Mute', 
                      onTap: () { 
                        AppDialogs.showSnack(context, 'Microphone muted.'); 
                      }, 
                    ), 
                    _callCircleButton( 
                      icon: Icons.volume_up_outlined, 
                      label: 'Speaker', 
                      onTap: () { 
                        AppDialogs.showSnack(context, 'Speaker enabled.'); 
                      }, 
                    ), 
                    _callCircleButton( 
                      icon: Icons.call_end, 
                      label: 'End', 
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
 
  Widget _callCircleButton({ 
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
 
  Widget _digitButton(String digit) { 
    return InkWell( 
      borderRadius: BorderRadius.circular(16), 
      onTap: () { 
        setState(() { 
          _numberController.text += digit; 
        }); 
      }, 
      child: Center( 
        child: Text( 
          digit, 
          style: const TextStyle( 
            fontSize: 24, 
            fontWeight: FontWeight.w700, 
          ), 
        ), 
      ), 
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
    final recentCalls = 
        _repo.callHistory.where((e) => e.callType == CallType.voice).toList(); 
 
    return DefaultTabController( 
      length: 3, 
      child: Scaffold( 
        body: DecoratedBox( 
          decoration: BoxDecoration( 
            gradient: LinearGradient( 
              colors: [ 
                theme.colorScheme.surface, 
                theme.colorScheme.primary.withOpacity(0.07), 
                theme.colorScheme.surface, 
              ], 
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
            ), 
          ), 
          child: SafeArea( 
            child: Column( 
              children: [ 
                Padding( 
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 8), 
                  child: Row( 
                    children: [ 
                      Expanded( 
                        child: Text( 
                          'Voice Call', 
                          style: theme.textTheme.headlineSmall?.copyWith( 
                            fontWeight: FontWeight.w800, 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
                const TabBar( 
                  tabs: [ 
                    Tab(text: 'Dialpad'), 
                    Tab(text: 'Recents'), 
                    Tab(text: 'Contacts'), 
                  ], 
                ), 
                Expanded( 
                  child: TabBarView( 
                    children: [ 
                      _buildDialpad(theme), 
                      _buildRecents(theme, recentCalls), 
                      _buildContacts(theme), 
                    ], 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildDialpad(ThemeData theme) { 
    const digits = [ 
      '1', '2', '3', 
      '4', '5', '6', 
      '7', '8', '9', 
      '*', '0', '#', 
    ]; 
 
    return Padding( 
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18), 
      child: Column( 
        children: [ 
          TextField( 
            controller: _numberController, 
            readOnly: true, 
            textAlign: TextAlign.center, 
            style: theme.textTheme.titleLarge?.copyWith( 
              fontWeight: FontWeight.w700, 
            ), 
            decoration: InputDecoration( 
              hintText: 'Enter secure number', 
              filled: true, 
              fillColor: 
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.35), 
              border: OutlineInputBorder( 
                borderRadius: BorderRadius.circular(18), 
                borderSide: BorderSide.none, 
              ), 
            ), 
          ), 
          if (_selectedName != null) ...[ 
            const SizedBox(height: 8), 
            Text( 
              'Selected: $_selectedName', 
              style: theme.textTheme.bodyMedium, 
            ), 
          ], 
          const SizedBox(height: 14), 
          Expanded( 
            child: GridView.builder( 
              itemCount: digits.length, 
              physics: const NeverScrollableScrollPhysics(), 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
                crossAxisCount: 3, 
                mainAxisSpacing: 10, 
                crossAxisSpacing: 10, 
                childAspectRatio: 1.15, 
              ), 
              itemBuilder: (context, index) => Card( 
                elevation: 0, 
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(16), 
                ), 
                child: _digitButton(digits[index]), 
              ), 
            ), 
          ), 
          const SizedBox(height: 8), 
          Row( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              FloatingActionButton.small( 
                onPressed: () { 
                  final text = _numberController.text; 
                  if (text.isNotEmpty) { 
                    setState(() { 
                      _numberController.text = 
                          text.substring(0, text.length - 1); 
                    }); 
                  } 
                }, 
                heroTag: 'voice_backspace', 
                child: const Icon(Icons.backspace_outlined), 
              ), 
              const SizedBox(width: 16), 
              FloatingActionButton( 
                onPressed: () { 
                  _startCall( 
                    phone: _numberController.text, 
                    name: _selectedName, 
                  ); 
                }, 
                heroTag: 'voice_call', 
                child: const Icon(Icons.call), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildRecents(ThemeData theme, List<CallRecord> recents) { 
    if (recents.isEmpty) { 
      return Center( 
        child: Text( 
          'No recent voice calls.', 
          style: theme.textTheme.bodyLarge, 
        ), 
      ); 
    } 
 
    return ListView.builder( 
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20), 
      itemCount: recents.length, 
      itemBuilder: (context, index) { 
        final call = recents[index]; 
        return Card( 
          elevation: 0, 
          margin: const EdgeInsets.only(bottom: 10), 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(18), 
          ), 
          child: ListTile( 
            leading: CircleAvatar( 
              child: Text(call.name.substring(0, 1).toUpperCase()), 
            ), 
            title: Text( 
              call.name, 
              style: const TextStyle(fontWeight: FontWeight.w700), 
            ), 
            subtitle: Text( 
              '${call.phoneNumber}\n${call.isOutgoing ? 'Outgoing' : 'Incoming'} • ${_timeText(call.timestamp)}', 
            ), 
            isThreeLine: true, 
            trailing: IconButton( 
              onPressed: () => _startCall( 
                phone: call.phoneNumber, 
                name: call.name, 
              ), 
              icon: const Icon(Icons.call), 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _buildContacts(ThemeData theme) { 
    final contacts = _repo.contacts; 
 
    return ListView.builder( 
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20), 
      itemCount: contacts.length, 
      itemBuilder: (context, index) { 
        final contact = contacts[index]; 
        return Card( 
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
              onPressed: () => _startCall( 
                phone: contact.phoneNumber, 
                name: contact.name, 
              ), 
              icon: const Icon(Icons.call_outlined), 
            ), 
            onTap: () { 
              setState(() { 
                _numberController.text = contact.phoneNumber; 
                _selectedName = contact.name; 
              }); 
              DefaultTabController.of(context).animateTo(0); 
            }, 
          ), 
        ); 
      }, 
    ); 
  } 
} 
 
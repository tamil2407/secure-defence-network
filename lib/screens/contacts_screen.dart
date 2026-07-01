
 
import 'package:flutter/material.dart'; 
 
import '../models/app_models.dart'; 
import '../services/app_demo_data.dart'; 
import '../services/app_dialogs.dart'; 
 
class ContactsScreen extends StatefulWidget { 
  const ContactsScreen({super.key}); 
 
  @override 
  State<ContactsScreen> createState() => _ContactsScreenState(); 
} 
 
class _ContactsScreenState extends State<ContactsScreen> { 
  final AppDemoData _repo = AppDemoData.instance; 
  final TextEditingController _searchController = TextEditingController(); 
 
  String _searchText = ''; 
 
  List<PhoneContact> get _contacts { 
    final items = _repo.contacts; 
    if (_searchText.trim().isEmpty) return items; 
    final query = _searchText.toLowerCase(); 
    return items.where((contact) { 
      return contact.name.toLowerCase().contains(query) || 
          contact.phoneNumber.toLowerCase().contains(query) || 
          contact.rank.toLowerCase().contains(query) || 
          contact.unit.toLowerCase().contains(query); 
    }).toList(); 
  } 
 
  @override 
  void dispose() { 
    _searchController.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _showAddContactSheet() async { 
    final nameController = TextEditingController(); 
    final phoneController = TextEditingController(); 
    final rankController = TextEditingController(); 
    final unitController = TextEditingController(); 
    final statusController = TextEditingController(text: 'Available'); 
 
    final created = await showModalBottomSheet<bool>( 
      context: context, 
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return SafeArea( 
          child: Padding( 
            padding: EdgeInsets.fromLTRB( 
              20, 
              18, 
              20, 
              MediaQuery.of(context).viewInsets.bottom + 24, 
            ), 
            child: SingleChildScrollView( 
              child: Column( 
                mainAxisSize: MainAxisSize.min, 
                children: [ 
                  const Text( 
                    'Add Contact', 
                    style: TextStyle( 
                      fontSize: 20, 
                      fontWeight: FontWeight.w700, 
                    ), 
                  ), 
                  const SizedBox(height: 16), 
                  TextField( 
                    controller: nameController, 
                    decoration: const InputDecoration( 
                      labelText: 'Name', 
                      border: OutlineInputBorder(), 
                    ), 
                  ), 
                  const SizedBox(height: 12), 
                  TextField( 
                    controller: phoneController, 
                    decoration: const InputDecoration( 
                      labelText: 'Phone Number', 
                      border: OutlineInputBorder(), 
                    ), 
                  ), 
                  const SizedBox(height: 12), 
                  TextField( 
                    controller: rankController, 
                    decoration: const InputDecoration( 
                      labelText: 'Rank', 
                      border: OutlineInputBorder(), 
                    ), 
                  ), 
                  const SizedBox(height: 12), 
                  TextField( 
                    controller: unitController, 
                    decoration: const InputDecoration( 
                      labelText: 'Unit', 
                      border: OutlineInputBorder(), 
                    ), 
                  ), 
                  const SizedBox(height: 12), 
                  TextField( 
                    controller: statusController, 
                    decoration: const InputDecoration( 
                      labelText: 'Status', 
                      border: OutlineInputBorder(), 
                    ), 
                  ), 
                  const SizedBox(height: 16), 
                  SizedBox( 
                    width: double.infinity, 
                    child: FilledButton( 
                      onPressed: () { 
                        final name = nameController.text.trim(); 
                        final phone = phoneController.text.trim(); 
                        final rank = rankController.text.trim(); 
                        final unit = unitController.text.trim(); 
                        final status = statusController.text.trim(); 
 
                        if (name.isEmpty || 
                            phone.isEmpty || 
                            rank.isEmpty || 
                            unit.isEmpty || 
                            status.isEmpty) { 
                          AppDialogs.showSnack( 
                            context, 
                            'Fill all contact details.', 
                          ); 
                          return; 
                        } 
 
                        if (_repo.findContactByPhone(phone) != null) { 
                          AppDialogs.showSnack( 
                            context, 
                            'This phone number already exists.', 
                          ); 
                          return; 
                        } 
 
                        _repo.addContact( 
                          name: name, 
                          phoneNumber: phone, 
                          rank: rank, 
                          unit: unit, 
                          status: status, 
                        ); 
 
                        Navigator.pop(context, true); 
                      }, 
                      child: const Text('Add Contact'), 
                    ), 
                  ), 
                ], 
              ), 
            ), 
          ), 
        ); 
      }, 
    ); 
 
    if (created == true && mounted) { 
      setState(() {}); 
      AppDialogs.showSnack(context, 'Contact added.'); 
    } 
  } 
 
  Future<void> _deleteContact(PhoneContact contact) async { 
    final yes = await AppDialogs.confirmAction( 
      context: context, 
      title: 'Delete contact?', 
      message: 'Do you want to remove ${contact.name} from contacts?', 
      confirmText: 'Delete', 
      confirmColor: Colors.red, 
    ); 
 
    if (!yes) return; 
 
    _repo.deleteContact(contact.phoneNumber); 
    if (!mounted) return; 
    setState(() {}); 
    AppDialogs.showSnack(context, 'Contact deleted.'); 
  } 
 
  void _openContactDetails(PhoneContact contact) { 
    final theme = Theme.of(context); 
 
    showModalBottomSheet<void>( 
      context: context, 
      backgroundColor: theme.colorScheme.surface, 
      shape: const RoundedRectangleBorder( 
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)), 
      ), 
      builder: (context) { 
        return SafeArea( 
          child: Padding( 
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24), 
            child: Column( 
              mainAxisSize: MainAxisSize.min, 
              children: [ 
                CircleAvatar( 
                  radius: 34, 
                  child: Text( 
                    contact.initials, 
                    style: const TextStyle(fontWeight: FontWeight.bold), 
                  ), 
                ), 
                const SizedBox(height: 12), 
                Text( 
                  contact.name, 
                  style: theme.textTheme.titleLarge?.copyWith( 
                    fontWeight: FontWeight.w800, 
                  ), 
                ), 
                const SizedBox(height: 6), 
                Text('${contact.rank} • ${contact.unit}'), 
                const SizedBox(height: 4), 
                Text(contact.phoneNumber), 
                const SizedBox(height: 4), 
                Text(contact.status), 
                const SizedBox(height: 18), 
                Row( 
                  children: [ 
                    Expanded( 
                      child: _actionButton( 
                        label: 'Message', 
                        icon: Icons.chat_bubble_outline, 
                        onTap: () { 
                          Navigator.pop(context); 
                          Navigator.pushNamed( 
                            this.context, 
                            '/chat', 
                            arguments: { 
                              'phone': contact.phoneNumber, 
                              'name': contact.name, 
                            }, 
                          ); 
                        }, 
                      ), 
                    ), 
                    const SizedBox(width: 10), 
                    Expanded( 
                      child: _actionButton( 
                        label: 'Voice', 
                        icon: Icons.call_outlined, 
                        onTap: () { 
                          Navigator.pop(context); 
                          Navigator.pushNamed( 
                            this.context, 
                            '/voice', 
                            arguments: { 
                              'phone': contact.phoneNumber, 
                              'name': contact.name, 
                            }, 
                          ); 
                        }, 
                      ), 
                    ), 
                    const SizedBox(width: 10), 
                    Expanded( 
                      child: _actionButton( 
                        label: 'Video', 
                        icon: Icons.videocam_outlined, 
                        onTap: () { 
                          Navigator.pop(context); 
                          Navigator.pushNamed( 
                            this.context, 
                            '/video', 
                            arguments: { 
                              'phone': contact.phoneNumber, 
                              'name': contact.name, 
                            }, 
                          ); 
                        }, 
                      ), 
                    ), 
                  ], 
                ), 
                const SizedBox(height: 12), 
                SizedBox( 
                  width: double.infinity, 
                  child: OutlinedButton.icon( 
                    onPressed: () async { 
                      Navigator.pop(context); 
                      await _deleteContact(contact); 
                    }, 
                    icon: const Icon(Icons.delete_outline, color: Colors.red), 
                    label: const Text( 
                      'Delete Contact', 
                      style: TextStyle(color: Colors.red), 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ); 
      }, 
    ); 
  } 
 
  Widget _actionButton({ 
    required String label, 
    required IconData icon, 
    required VoidCallback onTap, 
  }) { 
    return FilledButton.icon( 
      onPressed: onTap, 
      icon: Icon(icon), 
      label: Text(label), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = Theme.of(context); 
    final contacts = _contacts; 
 
    return Scaffold( 
      floatingActionButton: FloatingActionButton.extended( 
        onPressed: _showAddContactSheet, 
        icon: const Icon(Icons.person_add_alt_1), 
        label: const Text('Add Contact'), 
      ), 
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
                        'Contacts', 
                        style: theme.textTheme.headlineSmall?.copyWith( 
                          fontWeight: FontWeight.w800, 
                        ), 
                      ), 
                    ), 
                    IconButton( 
                      onPressed: _showAddContactSheet, 
                      icon: const Icon(Icons.person_add_alt_1), 
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
                    hintText: 'Search by name, number, rank, or unit', 
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
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 18), 
                child: Container( 
                  padding: const EdgeInsets.all(14), 
                  decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(20), 
                    gradient: LinearGradient( 
                      colors: [ 
                        theme.colorScheme.primary.withOpacity(0.18), 
                        theme.colorScheme.primary.withOpacity(0.05), 
                      ], 
                    ), 
                  ), 
                  child: Row( 
                    children: [ 
                      Icon( 
                        Icons.phone_android_outlined, 
                        color: theme.colorScheme.primary, 
                      ), 
                      const SizedBox(width: 12), 
                      Expanded( 
                        child: Text( 
                          'Primary identity is mobile number. Tap any contact for secure actions.', 
                          style: theme.textTheme.bodyMedium?.copyWith( 
                            fontWeight: FontWeight.w600, 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
              const SizedBox(height: 8), 
              Expanded( 
                child: contacts.isEmpty 
                    ? Center( 
                        child: Text( 
                          'No contacts found.', 
                          style: theme.textTheme.bodyLarge, 
                        ), 
                      ) 
                    : ListView.builder( 
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 20), 
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
                              onTap: () => _openContactDetails(contact), 
                              contentPadding: const EdgeInsets.all(14), 
                              leading: Stack( 
                                children: [ 
                                  CircleAvatar( 
                                    radius: 26, 
                                    child: Text(contact.initials), 
                                  ), 
                                  Positioned( 
                                    right: 0, 
                                    bottom: 0, 
                                    child: CircleAvatar( 
                                      radius: 7, 
                                      backgroundColor: contact.isOnline 
                                          ? Colors.green 
                                          : Colors.grey, 
                                    ), 
                                  ), 
                                ], 
                              ), 
                              title: Text( 
                                contact.name, 
                                style: const TextStyle(fontWeight: FontWeight.w700), 
                              ), 
                              subtitle: Padding( 
                                padding: const EdgeInsets.only(top: 4), 
                                child: Column( 
                                  crossAxisAlignment: CrossAxisAlignment.start, 
                                  children: [ 
                                    Text('${contact.rank} • ${contact.unit}'), 
                                    const SizedBox(height: 2), 
                                    Text(contact.phoneNumber), 
                                  ], 
                                ), 
                              ), 
                              trailing: PopupMenuButton<String>( 
                                onSelected: (value) async { 
                                  if (value == 'chat') { 
                                    Navigator.pushNamed( 
                                      context, 
                                      '/chat', 
                                      arguments: { 
                                        'phone': contact.phoneNumber, 
                                        'name': contact.name, 
                                      }, 
                                    ); 
                                  } else if (value == 'voice') { 
                                    Navigator.pushNamed( 
                                      context, 
                                      '/voice', 
                                      arguments: { 
                                        'phone': contact.phoneNumber, 
                                        'name': contact.name, 
                                      }, 
                                    ); 
                                  } else if (value == 'video') { 
                                    Navigator.pushNamed( 
                                      context, 
                                      '/video', 
                                      arguments: { 
                                        'phone': contact.phoneNumber, 
                                        'name': contact.name, 
                                      }, 
                                    ); 
                                  } else if (value == 'delete') { 
                                    await _deleteContact(contact); 
                                  } 
                                }, 
                                itemBuilder: (context) => const [ 
                                  PopupMenuItem(value: 'chat', child: Text('Message')), 
                                  PopupMenuItem(value: 'voice', child: Text('Voice Call')), 
                                  PopupMenuItem(value: 'video', child: Text('Video Call')), 
                                  PopupMenuItem(value: 'delete', child: Text('Delete')), 
                                ], 
                              ), 
                            ), 
                          ); 
                        }, 
                      ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
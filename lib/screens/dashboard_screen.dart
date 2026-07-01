
 
import 'package:flutter/material.dart'; 
import '../theme/app_theme.dart'; 
import '../services/app_demo_data.dart'; 
import '../models/app_models.dart'; 
 
class DashboardScreen extends StatelessWidget { 
  const DashboardScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    final c = ThemeScope.of(context).colors; 
    final repo = AppDemoData.instance; 
 
    return Scaffold( 
      backgroundColor: c.background, 
      body: SafeArea( 
        child: SingleChildScrollView( 
          child: Column( 
            children: [ 
              _buildHeader(context, c), 
              Transform.translate( 
                offset: const Offset(0, -28), 
                child: Padding( 
                  padding: const EdgeInsets.symmetric(horizontal: 16), 
                  child: Column( 
                    children: [ 
                      _buildCommandCenter(context, c), 
                      const SizedBox(height: 20), 
                      _buildRecentContacts(context, c, repo.recentContacts), 
                      const SizedBox(height: 20), 
                    ], 
                  ), 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildHeader(BuildContext context, AppColors c) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 74), 
      decoration: BoxDecoration( 
        gradient: LinearGradient( 
          colors: [c.headerStart, c.headerEnd], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
        ), 
        boxShadow: [ 
          BoxShadow( 
            color: c.primary.withOpacity(0.18), 
            blurRadius: 20, 
            offset: const Offset(0, 8), 
          ), 
        ], 
      ), 
      child: Column( 
        children: [ 
          Row( 
            children: [ 
              Container( 
                width: 76, 
                height: 76, 
                decoration: BoxDecoration( 
                  color: Colors.white.withOpacity(0.12), 
                  shape: BoxShape.circle, 
                  border: Border.all( 
                    color: Colors.white.withOpacity(0.16), 
                  ), 
                ), 
                child: const Icon( 
                  Icons.person, 
                  size: 42, 
                  color: Colors.white, 
                ), 
              ), 
              const SizedBox(width: 16), 
              Expanded( 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    const Text( 
                      'Major Rajesh Kumar', 
                      style: TextStyle( 
                        color: Colors.white, 
                        fontSize: 19, 
                        fontWeight: FontWeight.bold, 
                      ), 
                    ), 
                    const SizedBox(height: 4), 
                    Text( 
                      'Major - ID: MJ7845', 
                      style: TextStyle( 
                        color: Colors.white.withOpacity(0.82), 
                        fontSize: 14, 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
              Container( 
                decoration: BoxDecoration( 
                  color: Colors.white.withOpacity(0.10), 
                  borderRadius: BorderRadius.circular(14), 
                ), 
                child: IconButton( 
                  onPressed: () { 
                    Navigator.pushNamed(context, '/settings'); 
                  }, 
                  icon: const Icon(Icons.settings, color: Colors.white, size: 28), 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 26), 
          Row( 
            children: [ 
              Icon(Icons.wifi, color: Colors.white.withOpacity(0.82)), 
              const SizedBox(width: 8), 
              Text( 
                'Secure Network Active', 
                style: TextStyle( 
                  color: Colors.white.withOpacity(0.82), 
                  fontSize: 14, 
                ), 
              ), 
              const SizedBox(width: 22), 
              Icon(Icons.shield_outlined, color: Colors.white.withOpacity(0.82)), 
              const SizedBox(width: 8), 
              Text( 
                'Encrypted', 
                style: TextStyle( 
                  color: Colors.white.withOpacity(0.82), 
                  fontSize: 14, 
                ), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildCommandCenter(BuildContext context, AppColors c) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.all(18), 
      decoration: BoxDecoration( 
        color: c.surface, 
        borderRadius: BorderRadius.circular(28), 
        border: Border.all(color: c.border), 
        boxShadow: [ 
          BoxShadow( 
            color: c.shadow.withOpacity(0.14), 
            blurRadius: 18, 
            offset: const Offset(0, 8), 
          ), 
        ], 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Row( 
            children: [ 
              Icon(Icons.shield_outlined, color: c.primary, size: 28), 
              const SizedBox(width: 10), 
              Text( 
                'Command Center', 
                style: TextStyle( 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: c.textPrimary, 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 20), 
          Row( 
            children: [ 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.chat_bubble_outline, 
                  'Secure Chat', 
                  [c.tileBlue1, c.tileBlue2], 
                  '/chat', 
                ), 
              ), 
              const SizedBox(width: 16), 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.groups_outlined, 
                  'Groups', 
                  [c.tileCyan1, c.tileCyan2], 
                  '/groups', 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 16), 
          Row( 
            children: [ 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.call_outlined, 
                  'Voice Call', 
                  [c.tileGreen1, c.tileGreen2], 
                  '/voice', 
                ), 
              ), 
              const SizedBox(width: 16), 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.videocam_outlined, 
                  'Video Call', 
                  [c.tilePurple1, c.tilePurple2], 
                  '/video', 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 16), 
          Row( 
            children: [ 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.people_outline, 
                  'Contacts', 
                  [c.tileOrange1, c.tileOrange2], 
                  '/contacts', 
                ), 
              ), 
              const SizedBox(width: 16), 
              Expanded( 
                child: _tile( 
                  context, 
                  Icons.description_outlined, 
                  'Personal Notes', 
                  [c.tilePink1, c.tilePink2], 
                  '/notes', 
                ), 
              ), 
            ], 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _tile( 
    BuildContext context, 
    IconData icon, 
    String title, 
    List<Color> colors, 
    String routeName, 
  ) { 
    return GestureDetector( 
      onTap: () { 
        Navigator.pushNamed(context, routeName); 
      }, 
      child: Container( 
        height: 150, 
        decoration: BoxDecoration( 
          gradient: LinearGradient( 
            colors: colors, 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
          ), 
          borderRadius: BorderRadius.circular(22), 
          boxShadow: [ 
            BoxShadow( 
              color: colors.last.withOpacity(0.24), 
              blurRadius: 12, 
              offset: const Offset(0, 5), 
            ), 
          ], 
        ), 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            Icon(icon, color: Colors.white, size: 34), 
            const SizedBox(height: 12), 
            Text( 
              title, 
              textAlign: TextAlign.center, 
              style: const TextStyle( 
                color: Colors.white, 
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildRecentContacts( 
    BuildContext context, 
    AppColors c, 
    List<PhoneContact> contacts, 
  ) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.all(18), 
      decoration: BoxDecoration( 
        color: c.surface, 
        borderRadius: BorderRadius.circular(28), 
        border: Border.all(color: c.border), 
        boxShadow: [ 
          BoxShadow( 
            color: c.shadow.withOpacity(0.14), 
            blurRadius: 18, 
            offset: const Offset(0, 8), 
          ), 
        ], 
      ), 
      child: Column( 
        children: [ 
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [ 
              Text( 
                'Recent Contacts', 
                style: TextStyle( 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: c.textPrimary, 
                ), 
              ), 
              Text( 
                'Last communicated', 
                style: TextStyle( 
                  fontSize: 14, 
                  color: c.textSecondary, 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 18), 
          if (contacts.isEmpty) 
            Padding( 
              padding: const EdgeInsets.symmetric(vertical: 12), 
              child: Text( 
                'No recent contacts', 
                style: TextStyle( 
                  color: c.textSecondary, 
                  fontSize: 14, 
                ), 
              ), 
            ) 
          else 
            ...contacts.map( 
              (contact) => Padding( 
                padding: const EdgeInsets.only(bottom: 14), 
                child: InkWell( 
                  borderRadius: BorderRadius.circular(18), 
                  onTap: () { 
                    Navigator.pushNamed( 
                      context, 
                      '/chat', 
                      arguments: { 
                        'phone': contact.phoneNumber, 
                        'name': contact.name, 
                      }, 
                    ); 
                  }, 
                  child: Container( 
                    padding: const EdgeInsets.all(12), 
                    decoration: BoxDecoration( 
                      color: c.background, 
                      borderRadius: BorderRadius.circular(18), 
                      border: Border.all(color: c.border), 
                    ), 
                    child: Row( 
                      children: [ 
                        CircleAvatar( 
                          radius: 26, 
                          backgroundColor: c.secondary, 
                          child: Text( 
                            contact.initials, 
                            style: const TextStyle( 
                              color: Colors.white, 
                              fontWeight: FontWeight.bold, 
                            ), 
                          ), 
                        ), 
                        const SizedBox(width: 14), 
                        Expanded( 
                          child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [ 
                              Text( 
                                contact.name, 
                                style: TextStyle( 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w700, 
                                  color: c.textPrimary, 
                                ), 
                              ), 
                              const SizedBox(height: 4), 
                              Text( 
                                '${contact.rank} • ${contact.phoneNumber}', 
                                style: TextStyle( 
                                  fontSize: 13, 
                                  color: c.textSecondary, 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
                        IconButton( 
                          onPressed: () { 
                            Navigator.pushNamed( 
                              context, 
                              '/voice', 
                              arguments: { 
                                'phone': contact.phoneNumber, 
                                'name': contact.name, 
                              }, 
                            ); 
                          }, 
                          icon: Icon(Icons.call_outlined, color: c.textMuted), 
                        ), 
                        IconButton( 
                          onPressed: () { 
                            Navigator.pushNamed( 
                              context, 
                              '/video', 
                              arguments: { 
                                'phone': contact.phoneNumber, 
                                'name': contact.name, 
                              }, 
                            ); 
                          }, 
                          icon: Icon(Icons.videocam_outlined, color: c.textMuted), 
                        ), 
                      ], 
                    ), 
                  ), 
                ), 
              ), 
            ), 
        ], 
      ), 
    ); 
  } 
} 
 
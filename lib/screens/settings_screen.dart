
 
import 'package:flutter/material.dart'; 
import '../theme/app_theme.dart'; 
 
class SettingsScreen extends StatefulWidget { 
  const SettingsScreen({super.key}); 
 
  @override 
  State<SettingsScreen> createState() => _SettingsScreenState(); 
} 
 
class _SettingsScreenState extends State<SettingsScreen> { 
  bool biometricEnabled = true; 
  bool notificationsEnabled = true; 
  String lockTimeout = '30 Seconds'; 
 
  @override 
  Widget build(BuildContext context) { 
    final themeController = ThemeScope.of(context); 
    final c = themeController.colors; 
    final isDark = themeController.mode == AppThemeMode.dark; 
 
    return Scaffold( 
      backgroundColor: c.background, 
      appBar: AppBar( 
        backgroundColor: c.surface, 
        title: Text( 
          'Settings', 
          style: TextStyle( 
            color: c.textPrimary, 
            fontWeight: FontWeight.w600, 
          ), 
        ), 
      ), 
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16), 
        child: Column( 
          children: [ 
            _profileCard(c), 
            const SizedBox(height: 18), 
            _sectionTitle('Appearance', c), 
            const SizedBox(height: 12), 
            Container( 
              padding: const EdgeInsets.all(14), 
              decoration: _box(c), 
              child: Row( 
                children: [ 
                  Expanded( 
                    child: _modeButton( 
                      title: 'Dark Mode', 
                      icon: Icons.dark_mode_outlined, 
                      isSelected: isDark, 
                      activeColor: c.primary, 
                      inactiveColor: c.surfaceSoft, 
                      selectedIconColor: Colors.white, 
                      unselectedIconColor: c.textPrimary, 
                      selectedTextColor: Colors.white, 
                      unselectedTextColor: c.textPrimary, 
                      onTap: () { 
                        themeController.setMode(AppThemeMode.dark); 
                      }, 
                    ), 
                  ), 
                  const SizedBox(width: 12), 
                  Expanded( 
                    child: _modeButton( 
                      title: 'Light Mode', 
                      icon: Icons.light_mode_outlined, 
                      isSelected: !isDark, 
                      activeColor: c.primary, 
                      inactiveColor: c.surfaceSoft, 
                      selectedIconColor: Colors.white, 
                      unselectedIconColor: c.textPrimary, 
                      selectedTextColor: Colors.white, 
                      unselectedTextColor: c.textPrimary, 
                      onTap: () { 
                        themeController.setMode(AppThemeMode.light); 
                      }, 
                    ), 
                  ), 
                ], 
              ), 
            ), 
            const SizedBox(height: 18), 
            _sectionTitle('Security Controls', c), 
            const SizedBox(height: 12), 
            _switchTile( 
              c: c, 
              icon: Icons.fingerprint, 
              title: 'Biometric Authentication', 
              subtitle: 'Require fingerprint before secure access', 
              value: biometricEnabled, 
              onChanged: (value) { 
                setState(() { 
                  biometricEnabled = value; 
                }); 
              }, 
            ), 
            const SizedBox(height: 18), 
            _sectionTitle('Notifications', c), 
            const SizedBox(height: 12), 
            _switchTile( 
              c: c, 
              icon: Icons.notifications_none, 
              title: 'Alerts and Notifications', 
              subtitle: 'Mission updates, calls, and security warnings', 
              value: notificationsEnabled, 
              onChanged: (value) { 
                setState(() { 
                  notificationsEnabled = value; 
                }); 
              }, 
            ), 
            const SizedBox(height: 18), 
            _sectionTitle('Access Settings', c), 
            const SizedBox(height: 12), 
            _dropdownTile(c), 
            const SizedBox(height: 12), 
            _actionTile( 
              c: c, 
              icon: Icons.lock_outline, 
              title: 'Change Password', 
              subtitle: 'Old password and fingerprint required', 
              onTap: () { 
                Navigator.pushNamed(context, '/change-password'); 
              }, 
            ), 
            const SizedBox(height: 12), 
            _actionTile( 
              c: c, 
              icon: Icons.shield_outlined, 
              title: 'Security Policies', 
              subtitle: 'View defence compliance settings', 
              onTap: () {}, 
            ), 
            const SizedBox(height: 12), 
            _actionTile( 
              c: c, 
              icon: Icons.info_outline, 
              title: 'About Platform', 
              subtitle: 'Application version and system details', 
              onTap: () {}, 
            ), 
            const SizedBox(height: 24), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  BoxDecoration _box(AppColors c) { 
    return BoxDecoration( 
      color: c.surface, 
      borderRadius: BorderRadius.circular(22), 
      border: Border.all(color: c.border), 
      boxShadow: [ 
        BoxShadow( 
          color: c.shadow.withOpacity(0.18), 
          blurRadius: 16, 
          offset: const Offset(0, 6), 
        ), 
      ], 
    ); 
  } 
 
  Widget _profileCard(AppColors c) { 
    return Container( 
      width: double.infinity, 
      padding: const EdgeInsets.all(18), 
      decoration: BoxDecoration( 
        gradient: LinearGradient( 
          colors: [c.headerStart, c.headerEnd], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight, 
        ), 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [ 
          BoxShadow( 
            color: c.primary.withOpacity(0.22), 
            blurRadius: 18, 
            offset: const Offset(0, 8), 
          ), 
        ], 
      ), 
      child: Column( 
        children: [ 
          const CircleAvatar( 
            radius: 34, 
            backgroundColor: Colors.white24, 
            child: Icon(Icons.person, size: 34, color: Colors.white), 
          ), 
          const SizedBox(height: 12), 
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
            'Secure Defence Access Profile', 
            style: TextStyle( 
              color: Colors.white.withOpacity(0.82), 
              fontSize: 13, 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _sectionTitle(String text, AppColors c) { 
    return Align( 
      alignment: Alignment.centerLeft, 
      child: Text( 
        text, 
        style: TextStyle( 
          color: c.textPrimary, 
          fontSize: 17, 
          fontWeight: FontWeight.bold, 
        ), 
      ), 
    ); 
  } 
 
  Widget _modeButton({ 
    required String title, 
    required IconData icon, 
    required bool isSelected, 
    required Color activeColor, 
    required Color inactiveColor, 
    required Color selectedIconColor, 
    required Color unselectedIconColor, 
    required Color selectedTextColor, 
    required Color unselectedTextColor, 
    required VoidCallback onTap, 
  }) { 
    return GestureDetector( 
      onTap: onTap, 
      child: AnimatedContainer( 
        duration: const Duration(milliseconds: 180), 
        padding: const EdgeInsets.symmetric(vertical: 14), 
        decoration: BoxDecoration( 
          color: isSelected ? activeColor : inactiveColor, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all( 
            color: isSelected ? activeColor : Colors.transparent, 
          ), 
        ), 
        child: Column( 
          children: [ 
            Icon( 
              icon, 
              color: isSelected ? selectedIconColor : unselectedIconColor, 
            ), 
            const SizedBox(height: 8), 
            Text( 
              title, 
              style: TextStyle( 
                color: isSelected ? selectedTextColor : unselectedTextColor, 
                fontWeight: FontWeight.w600, 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  Widget _switchTile({ 
    required AppColors c, 
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required bool value, 
    required ValueChanged<bool> onChanged, 
  }) { 
    return Container( 
      margin: const EdgeInsets.only(bottom: 12), 
      padding: const EdgeInsets.all(14), 
      decoration: _box(c), 
      child: Row( 
        children: [ 
          Container( 
            width: 48, 
            height: 48, 
            decoration: BoxDecoration( 
              color: c.surfaceSoft, 
              borderRadius: BorderRadius.circular(14), 
            ), 
            child: Icon(icon, color: c.primary), 
          ), 
          const SizedBox(width: 14), 
          Expanded( 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Text( 
                  title, 
                  style: TextStyle( 
                    color: c.textPrimary, 
                    fontSize: 15, 
                    fontWeight: FontWeight.w600, 
                  ), 
                ), 
                const SizedBox(height: 4), 
                Text( 
                  subtitle, 
                  style: TextStyle( 
                    color: c.textSecondary, 
                    fontSize: 12, 
                    height: 1.35, 
                  ), 
                ), 
              ], 
            ), 
          ), 
          Switch( 
            value: value, 
            activeThumbColor: c.primary, 
            onChanged: onChanged, 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _dropdownTile(AppColors c) { 
    return Container( 
      padding: const EdgeInsets.all(14), 
      decoration: _box(c), 
      child: Row( 
        children: [ 
          Container( 
            width: 48, 
            height: 48, 
            decoration: BoxDecoration( 
              color: c.surfaceSoft, 
              borderRadius: BorderRadius.circular(14), 
            ), 
            child: Icon(Icons.timer_outlined, color: c.primary), 
          ), 
          const SizedBox(width: 14), 
          Expanded( 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Text( 
                  'App Lock Timeout', 
                  style: TextStyle( 
                    color: c.textPrimary, 
                    fontSize: 15, 
                    fontWeight: FontWeight.w600, 
                  ), 
                ), 
                const SizedBox(height: 4), 
                Text( 
                  'Automatic lock after inactivity', 
                  style: TextStyle( 
                    color: c.textSecondary, 
                    fontSize: 12, 
                  ), 
                ), 
              ], 
            ), 
          ), 
          DropdownButton<String>( 
            value: lockTimeout, 
            underline: const SizedBox(), 
            dropdownColor: c.surface, 
            borderRadius: BorderRadius.circular(14), 
            style: TextStyle(color: c.textPrimary), 
            items: const [ 
              DropdownMenuItem(value: '15 Seconds', child: Text('15s')), 
              DropdownMenuItem(value: '30 Seconds', child: Text('30s')), 
              DropdownMenuItem(value: '1 Minute', child: Text('1m')), 
              DropdownMenuItem(value: '5 Minutes', child: Text('5m')), 
            ], 
            onChanged: (value) { 
              if (value != null) { 
                setState(() { 
                  lockTimeout = value; 
                }); 
              } 
            }, 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _actionTile({ 
    required AppColors c, 
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required VoidCallback onTap, 
  }) { 
    return GestureDetector( 
      onTap: onTap, 
      child: Container( 
        padding: const EdgeInsets.all(14), 
        decoration: _box(c), 
        child: Row( 
          children: [ 
            Container( 
              width: 48, 
              height: 48, 
              decoration: BoxDecoration( 
                color: c.surfaceSoft, 
                borderRadius: BorderRadius.circular(14), 
              ), 
              child: Icon(icon, color: c.primary), 
            ), 
            const SizedBox(width: 14), 
            Expanded( 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  Text( 
                    title, 
                    style: TextStyle( 
                      color: c.textPrimary, 
                      fontSize: 15, 
                      fontWeight: FontWeight.w600, 
                    ), 
                  ), 
                  const SizedBox(height: 4), 
                  Text( 
                    subtitle, 
                    style: TextStyle( 
                      color: c.textSecondary, 
                      fontSize: 12, 
                    ), 
                  ), 
                ], 
              ), 
            ), 
            Icon(Icons.arrow_forward_ios, color: c.textMuted, size: 16), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
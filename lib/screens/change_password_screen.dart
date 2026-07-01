
 
import 'package:flutter/material.dart'; 
import '../theme/app_theme.dart'; 
 
class ChangePasswordScreen extends StatefulWidget { 
  const ChangePasswordScreen({super.key}); 
 
  @override 
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState(); 
} 
 
class _ChangePasswordScreenState extends State<ChangePasswordScreen> { 
  final TextEditingController oldPasswordController = TextEditingController(); 
  final TextEditingController newPasswordController = TextEditingController(); 
  final TextEditingController confirmPasswordController = 
      TextEditingController(); 
 
  bool oldPasswordVisible = false; 
  bool newPasswordVisible = false; 
  bool confirmPasswordVisible = false; 
  bool fingerprintVerified = false; 
 
  @override 
  void dispose() { 
    oldPasswordController.dispose(); 
    newPasswordController.dispose(); 
    confirmPasswordController.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _verifyFingerprint() async { 
 
    await showDialog( 
      context: context, 
      builder: (context) { 
        final dc = ThemeScope.of(context).colors; 
 
        return AlertDialog( 
          backgroundColor: dc.surface, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(20), 
          ), 
          title: Text( 
            'Fingerprint Verification', 
            style: TextStyle( 
              color: dc.textPrimary, 
              fontWeight: FontWeight.bold, 
            ), 
          ), 
          content: Column( 
            mainAxisSize: MainAxisSize.min, 
            children: [ 
              Icon( 
                Icons.fingerprint, 
                size: 64, 
                color: dc.primary, 
              ), 
              const SizedBox(height: 14), 
              Text( 
                'Place your finger to verify secure identity.', 
                textAlign: TextAlign.center, 
                style: TextStyle( 
                  color: dc.textSecondary, 
                ), 
              ), 
            ], 
          ), 
          actions: [ 
            TextButton( 
              onPressed: () { 
                Navigator.pop(context); 
              }, 
              child: Text( 
                'Cancel', 
                style: TextStyle(color: dc.textSecondary), 
              ), 
            ), 
            ElevatedButton( 
              onPressed: () { 
                setState(() { 
                  fingerprintVerified = true; 
                }); 
                Navigator.pop(context); 
                ScaffoldMessenger.of(this.context).showSnackBar( 
                  const SnackBar( 
                    content: Text('Fingerprint verified successfully'), 
                  ), 
                ); 
              }, 
              style: ElevatedButton.styleFrom( 
                backgroundColor: dc.primary, 
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(12), 
                ), 
              ), 
              child: const Text( 
                'Verify', 
                style: TextStyle(color: Colors.white), 
              ), 
            ), 
          ], 
        ); 
      }, 
    ); 
  } 
 
  void _changePassword() { 
    final oldPassword = oldPasswordController.text.trim(); 
    final newPassword = newPasswordController.text.trim(); 
    final confirmPassword = confirmPasswordController.text.trim(); 
 
    if (!fingerprintVerified) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('Fingerprint verification is required'), 
        ), 
      ); 
      return; 
    } 
 
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('Please fill all password fields'), 
        ), 
      ); 
      return; 
    } 
 
    if (oldPassword.length < 4) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('Enter a valid old password'), 
        ), 
      ); 
      return; 
    } 
 
    if (newPassword.length < 6) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('New password must be at least 6 characters'), 
        ), 
      ); 
      return; 
    } 
 
    if (newPassword != confirmPassword) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('New password and confirm password do not match'), 
        ), 
      ); 
      return; 
    } 
 
    if (oldPassword == newPassword) { 
      ScaffoldMessenger.of(context).showSnackBar( 
        const SnackBar( 
          content: Text('New password must be different from old password'), 
        ), 
      ); 
      return; 
    } 
 
    ScaffoldMessenger.of(context).showSnackBar( 
      const SnackBar( 
        content: Text('Password changed successfully'), 
      ), 
    ); 
 
    Future.delayed(const Duration(milliseconds: 700), () { 
      if (mounted) { 
        Navigator.pop(context); 
      } 
    }); 
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
 
  Widget _passwordField({ 
    required AppColors c, 
    required String label, 
    required String hint, 
    required TextEditingController controller, 
    required bool obscure, 
    required VoidCallback onToggle, 
  }) { 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4), 
      decoration: _box(c), 
      child: TextField( 
        controller: controller, 
        obscureText: !obscure, 
        style: TextStyle(color: c.textPrimary), 
        decoration: InputDecoration( 
          labelText: label, 
          hintText: hint, 
          labelStyle: TextStyle(color: c.textSecondary), 
          hintStyle: TextStyle(color: c.textMuted), 
          border: InputBorder.none, 
          suffixIcon: IconButton( 
            onPressed: onToggle, 
            icon: Icon( 
              obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, 
              color: c.textSecondary, 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final c = ThemeScope.of(context).colors; 
 
    return Scaffold( 
      backgroundColor: c.background, 
      appBar: AppBar( 
        backgroundColor: c.surface, 
        title: Text( 
          'Change Password', 
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
            Container( 
              width: double.infinity, 
              padding: const EdgeInsets.all(20), 
              decoration: BoxDecoration( 
                gradient: LinearGradient( 
                  colors: [c.headerStart, c.headerEnd], 
                  begin: Alignment.topLeft, 
                  end: Alignment.bottomRight, 
                ), 
                borderRadius: BorderRadius.circular(24), 
                boxShadow: [ 
                  BoxShadow( 
                    color: c.primary.withOpacity(0.20), 
                    blurRadius: 18, 
                    offset: const Offset(0, 8), 
                  ), 
                ], 
              ), 
              child: Column( 
                children: [ 
                  const Icon( 
                    Icons.lock_reset, 
                    color: Colors.white, 
                    size: 46, 
                  ), 
                  const SizedBox(height: 12), 
                  const Text( 
                    'Secure Password Update', 
                    style: TextStyle( 
                      color: Colors.white, 
                      fontSize: 19, 
                      fontWeight: FontWeight.bold, 
                    ), 
                  ), 
                  const SizedBox(height: 6), 
                  Text( 
                    'Old password and fingerprint verification are required before changing credentials.', 
                    textAlign: TextAlign.center, 
                    style: TextStyle( 
                      color: Colors.white.withOpacity(0.82), 
                      fontSize: 13, 
                      height: 1.4, 
                    ), 
                  ), 
                ], 
              ), 
            ), 
            const SizedBox(height: 18), 
            _passwordField( 
              c: c, 
              label: 'Old Password', 
              hint: 'Enter old password', 
              controller: oldPasswordController, 
              obscure: oldPasswordVisible, 
              onToggle: () { 
                setState(() { 
                  oldPasswordVisible = !oldPasswordVisible; 
                }); 
              }, 
            ), 
            const SizedBox(height: 14), 
            _passwordField( 
              c: c, 
              label: 'New Password', 
              hint: 'Enter new password', 
              controller: newPasswordController, 
              obscure: newPasswordVisible, 
              onToggle: () { 
                setState(() { 
                  newPasswordVisible = !newPasswordVisible; 
                }); 
              }, 
            ), 
            const SizedBox(height: 14), 
            _passwordField( 
              c: c, 
              label: 'Confirm Password', 
              hint: 'Re-enter new password', 
              controller: confirmPasswordController, 
              obscure: confirmPasswordVisible, 
              onToggle: () { 
                setState(() { 
                  confirmPasswordVisible = !confirmPasswordVisible; 
                }); 
              }, 
            ), 
            const SizedBox(height: 18), 
            Container( 
              width: double.infinity, 
              padding: const EdgeInsets.all(16), 
              decoration: _box(c), 
              child: Row( 
                children: [ 
                  Container( 
                    width: 52, 
                    height: 52, 
                    decoration: BoxDecoration( 
                      color: c.surfaceSoft, 
                      borderRadius: BorderRadius.circular(14), 
                    ), 
                    child: Icon( 
                      Icons.fingerprint, 
                      color: fingerprintVerified ? c.success : c.primary, 
                    ), 
                  ), 
                  const SizedBox(width: 14), 
                  Expanded( 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        Text( 
                          'Fingerprint Verification', 
                          style: TextStyle( 
                            color: c.textPrimary, 
                            fontSize: 15, 
                            fontWeight: FontWeight.w600, 
                          ), 
                        ), 
                        const SizedBox(height: 4), 
                        Text( 
                          fingerprintVerified 
                              ? 'Identity verified successfully' 
                              : 'Verify fingerprint before password update', 
                          style: TextStyle( 
                            color: c.textSecondary, 
                            fontSize: 12, 
                          ), 
                        ), 
                      ], 
                    ), 
                  ), 
                  ElevatedButton( 
                    onPressed: _verifyFingerprint, 
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: 
                          fingerprintVerified ? c.success : c.primary, 
                      shape: RoundedRectangleBorder( 
                        borderRadius: BorderRadius.circular(12), 
                      ), 
                    ), 
                    child: Text( 
                      fingerprintVerified ? 'Verified' : 'Verify', 
                      style: const TextStyle(color: Colors.white), 
                    ), 
                  ), 
                ], 
              ), 
            ), 
            const SizedBox(height: 22), 
            SizedBox( 
              width: double.infinity, 
              child: ElevatedButton.icon( 
                onPressed: _changePassword, 
                style: ElevatedButton.styleFrom( 
                  backgroundColor: c.primary, 
                  padding: const EdgeInsets.symmetric(vertical: 15), 
                  shape: RoundedRectangleBorder( 
                    borderRadius: BorderRadius.circular(16), 
                  ), 
                ), 
                icon: const Icon(Icons.check_circle_outline, color: Colors.white), 
                label: const Text( 
                  'Update Password', 
                  style: TextStyle( 
                    color: Colors.white, 
                    fontWeight: FontWeight.w600, 
                  ), 
                ), 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
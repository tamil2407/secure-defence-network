
 
import 'package:flutter/material.dart'; 
import 'package:local_auth/local_auth.dart'; 
import '../theme/app_theme.dart'; 
 
class BiometricAuthScreen extends StatefulWidget { 
  const BiometricAuthScreen({super.key}); 
 
  @override 
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState(); 
} 
 
class _BiometricAuthScreenState extends State<BiometricAuthScreen> { 
  final LocalAuthentication _auth = LocalAuthentication(); 
 
  bool verifying = false; 
  String status = "Place your finger on the scanner"; 
 
  Future<void> startVerification() async { 
    if (verifying) return; 
 
    setState(() { 
      verifying = true; 
      status = "Checking biometric support..."; 
    }); 
 
    try { 
      final bool canCheckBiometrics = await _auth.canCheckBiometrics; 
      final bool isSupported = await _auth.isDeviceSupported(); 
 
      if (!canCheckBiometrics && !isSupported) { 
        setState(() { 
          verifying = false; 
          status = "Biometric authentication is not available on this device"; 
        }); 
        return; 
      } 
 
      setState(() { 
        status = "Verifying biometric identity..."; 
      }); 
 
      final bool authenticated = await _auth.authenticate( 
        localizedReason: 'Authenticate to access the secure defence network', 
        options: const AuthenticationOptions( 
          biometricOnly: true, 
          stickyAuth: true, 
        ), 
      ); 
 
      if (!mounted) return; 
 
      if (authenticated) { 
        setState(() { 
          verifying = false; 
          status = "Identity verified successfully"; 
        }); 
 
        await Future.delayed(const Duration(milliseconds: 600)); 
 
        if (!mounted) return; 
        Navigator.pushReplacementNamed(context, '/dashboard'); 
      } else { 
        setState(() { 
          verifying = false; 
          status = "Authentication cancelled or failed"; 
        }); 
      } 
    } catch (e) { 
      setState(() { 
        verifying = false; 
        status = "Biometric error: $e"; 
      }); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final c = ThemeScope.of(context).colors; 
 
    return Scaffold( 
      backgroundColor: c.background, 
      body: Container( 
        width: double.infinity, 
        decoration: BoxDecoration( 
          gradient: LinearGradient( 
            colors: [c.headerStart, c.headerEnd], 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
          ), 
        ), 
        child: SafeArea( 
          child: Center( 
            child: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 20), 
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [ 
                  Container( 
                    width: double.infinity, 
                    padding: const EdgeInsets.all(24), 
                    decoration: BoxDecoration( 
                      color: c.surface, 
                      borderRadius: BorderRadius.circular(28), 
                      border: Border.all(color: c.border), 
                    ), 
                    child: Column( 
                      children: [ 
                        Container( 
                          height: 80, 
                          width: 80, 
                          decoration: BoxDecoration( 
                            borderRadius: BorderRadius.circular(20), 
                            gradient: LinearGradient( 
                              colors: [c.primary, c.secondary], 
                            ), 
                          ), 
                          child: const Icon( 
                            Icons.shield_outlined, 
                            size: 40, 
                            color: Colors.white, 
                          ), 
                        ), 
                        const SizedBox(height: 20), 
                        Text( 
                          "Biometric Authentication", 
                          style: TextStyle( 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: c.textPrimary, 
                          ), 
                        ), 
                        const SizedBox(height: 8), 
                        Text( 
                          "Verify your identity to access the secure network", 
                          textAlign: TextAlign.center, 
                          style: TextStyle( 
                            fontSize: 14, 
                            color: c.textSecondary, 
                          ), 
                        ), 
                        const SizedBox(height: 30), 
                        Container( 
                          height: 200, 
                          width: 200, 
                          decoration: BoxDecoration( 
                            shape: BoxShape.circle, 
                            color: c.surfaceSoft, 
                            border: Border.all(color: c.border), 
                          ), 
                          child: Center( 
                            child: verifying 
                                ? CircularProgressIndicator( 
                                    color: c.primary, 
                                  ) 
                                : Icon( 
                                    Icons.fingerprint, 
                                    size: 100, 
                                    color: c.primary, 
                                  ), 
                          ), 
                        ), 
                        const SizedBox(height: 30), 
                        Text( 
                          status, 
                          textAlign: TextAlign.center, 
                          style: TextStyle( 
                            fontSize: 16, 
                            color: c.textPrimary, 
                          ), 
                        ), 
                        const SizedBox(height: 28), 
                        SizedBox( 
                          width: double.infinity, 
                          height: 56, 
                          child: ElevatedButton.icon( 
                            onPressed: verifying ? null : startVerification, 
                            icon: const Icon( 
                              Icons.fingerprint, 
                              color: Colors.white, 
                            ), 
                            label: const Text( 
                              "Start Verification", 
                              style: TextStyle( 
                                fontSize: 17, 
                                fontWeight: FontWeight.w600, 
                                color: Colors.white, 
                              ), 
                            ), 
                            style: ElevatedButton.styleFrom( 
                              backgroundColor: c.primary, 
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(18), 
                              ), 
                            ), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ), 
                  const SizedBox(height: 24), 
                  const Text( 
                    "SECURE ACCESS PROTOCOL ACTIVE", 
                    style: TextStyle( 
                      color: Colors.white70, 
                      letterSpacing: 1.4, 
                      fontSize: 12, 
                    ), 
                  ), 
                ], 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
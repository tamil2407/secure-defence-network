
 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart'; 
 
class LoginScreen extends StatefulWidget { 
  const LoginScreen({super.key}); 
 
  @override 
  State<LoginScreen> createState() => _LoginScreenState(); 
} 
 
class _LoginScreenState extends State<LoginScreen> { 
  final TextEditingController _userIdController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController(); 
 
  bool _isLoading = false; 
  bool _obscurePassword = true; 
 
  @override 
  void dispose() { 
    _userIdController.dispose(); 
    _passwordController.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _handleLogin() async { 
    final email = _userIdController.text.trim(); 
    final password = _passwordController.text.trim(); 
 
    if (email.isEmpty || password.isEmpty) { 
      _showSnack('Enter email and password.'); 
      return; 
    } 
 
    setState(() { 
      _isLoading = true; 
    }); 
 
    try { 
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword( 
        email: email, 
        password: password, 
      ); 
 
      if (!mounted) return; 
 
      if (credential.user != null) { 
        _showSnack('Login successful.'); 
        Navigator.pushReplacementNamed(context, '/biometric'); 
      } else { 
        _showSnack('Login failed. User not returned.'); 
      } 
    } on FirebaseAuthException catch (e) { 
      if (!mounted) return; 
      _showSnack(_firebaseErrorText(e)); 
    } catch (e) { 
      if (!mounted) return; 
      _showSnack('Other error: $e'); 
    } finally { 
      if (mounted) { 
        setState(() { 
          _isLoading = false; 
        }); 
      } 
    } 
  } 
 
  String _firebaseErrorText(FirebaseAuthException e) { 
    switch (e.code) { 
      case 'invalid-email': 
        return 'Invalid email format.'; 
      case 'user-disabled': 
        return 'This account is disabled.'; 
      case 'user-not-found': 
        return 'No user found for this email.'; 
      case 'wrong-password': 
        return 'Wrong password.'; 
      case 'invalid-credential': 
        return 'Incorrect email or password.'; 
      case 'network-request-failed': 
        return 'Network error. Check internet.'; 
      case 'too-many-requests': 
        return 'Too many attempts. Try later.'; 
      case 'operation-not-allowed': 
        return 'Email/password login is not enabled in Firebase.'; 
      default: 
        return 'Firebase error: ${e.code}'; 
    } 
  } 
 
  void _showSnack(String text) { 
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    ScaffoldMessenger.of(context).showSnackBar( 
      SnackBar(content: Text(text)), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Container( 
        width: double.infinity, 
        decoration: const BoxDecoration( 
          gradient: LinearGradient( 
            begin: Alignment.topLeft, 
            end: Alignment.bottomRight, 
            colors: [ 
              Color(0xFF031130), 
              Color(0xFF0E47C9), 
              Color(0xFF7A1EE6), 
            ], 
          ), 
        ), 
        child: SafeArea( 
          child: SingleChildScrollView( 
            child: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20), 
              child: Column( 
                children: [ 
                  const SizedBox(height: 20), 
                  Container( 
                    height: 118, 
                    width: 118, 
                    decoration: BoxDecoration( 
                      color: Colors.white.withOpacity(0.08), 
                      borderRadius: BorderRadius.circular(24), 
                      border: Border.all( 
                        color: Colors.white.withOpacity(0.25), 
                        width: 1.2, 
                      ), 
                    ), 
                    child: const Center( 
                      child: Icon( 
                        Icons.shield_outlined, 
                        size: 58, 
                        color: Colors.white, 
                      ), 
                    ), 
                  ), 
                  const SizedBox(height: 26), 
                  const Text( 
                    'Secure Defence Network', 
                    textAlign: TextAlign.center, 
                    style: TextStyle( 
                      fontSize: 31, 
                      fontWeight: FontWeight.w700, 
                      color: Colors.white, 
                    ), 
                  ), 
                  const SizedBox(height: 10), 
                  const Text( 
                    'AUTHORIZED PERSONNEL ONLY', 
                    style: TextStyle( 
                      fontSize: 14.5, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.white, 
                      letterSpacing: 1.5, 
                    ), 
                  ), 
                  const SizedBox(height: 34), 
                  Container( 
                    width: double.infinity, 
                    padding: const EdgeInsets.fromLTRB(18, 22, 18, 22), 
                    decoration: BoxDecoration( 
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(22), 
                      boxShadow: [ 
                        BoxShadow( 
                          color: Colors.black.withOpacity(0.18), 
                          blurRadius: 14, 
                          offset: const Offset(0, 8), 
                        ), 
                      ], 
                    ), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        const Text( 
                          'USER ID', 
                          style: TextStyle( 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500, 
                            color: Colors.black87, 
                            letterSpacing: 0.8, 
                          ), 
                        ), 
                        const SizedBox(height: 12), 
                        _InputField( 
                          controller: _userIdController, 
                          hintText: 'Enter your Email ID', 
                          icon: Icons.person_outline, 
                          keyboardType: TextInputType.emailAddress, 
                        ), 
                        const SizedBox(height: 26), 
                        const Text( 
                          'PASSWORD', 
                          style: TextStyle( 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500, 
                            color: Colors.black87, 
                            letterSpacing: 0.8, 
                          ), 
                        ), 
                        const SizedBox(height: 12), 
                        _InputField( 
                          controller: _passwordController, 
                          hintText: 'Enter your Password', 
                          icon: Icons.lock_outline, 
                          obscureText: _obscurePassword, 
                          suffixIcon: IconButton( 
                            onPressed: () { 
                              setState(() { 
                                _obscurePassword = !_obscurePassword; 
                              }); 
                            }, 
                            icon: Icon( 
                              _obscurePassword 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined, 
                              color: const Color(0xFF334155), 
                            ), 
                          ), 
                        ), 
                        const SizedBox(height: 28), 
                        Container( 
                          width: double.infinity, 
                          height: 56, 
                          decoration: BoxDecoration( 
                            borderRadius: BorderRadius.circular(16), 
                            gradient: const LinearGradient( 
                              colors: [ 
                                Color(0xFF1358FF), 
                                Color(0xFF7B2CF6), 
                              ], 
                            ), 
                          ), 
                          child: ElevatedButton.icon( 
                            onPressed: _isLoading ? null : _handleLogin, 
                            icon: _isLoading 
                                ? const SizedBox( 
                                    width: 22, 
                                    height: 22, 
                                    child: CircularProgressIndicator( 
                                      strokeWidth: 2.2, 
                                      valueColor: AlwaysStoppedAnimation<Color>( 
                                        Colors.white, 
                                      ), 
                                    ), 
                                  ) 
                                : const Icon( 
                                    Icons.shield_outlined, 
                                    color: Colors.white, 
                                    size: 22, 
                                  ), 
                            label: Text( 
                              _isLoading ? 'Signing In...' : 'Secure Login', 
                              style: const TextStyle( 
                                color: Colors.white, 
                                fontSize: 18, 
                                fontWeight: FontWeight.w600, 
                              ), 
                            ), 
                            style: ElevatedButton.styleFrom( 
                              backgroundColor: Colors.transparent, 
                              shadowColor: Colors.transparent, 
                              disabledBackgroundColor: Colors.transparent, 
                              disabledForegroundColor: Colors.white, 
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(16), 
                              ), 
                            ), 
                          ), 
                        ), 
                        const SizedBox(height: 26), 
                        Divider(color: Colors.grey.shade300, thickness: 1), 
                        const SizedBox(height: 22), 
                        SizedBox( 
                          width: double.infinity, 
                          height: 56, 
                          child: OutlinedButton( 
                            onPressed: () { 
                              Navigator.pushNamed(context, '/step1'); 
                            }, 
                            style: OutlinedButton.styleFrom( 
                              side: BorderSide( 
                                color: Colors.grey.shade300, 
                                width: 1.2, 
                              ), 
                              backgroundColor: Colors.white, 
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(16), 
                              ), 
                            ), 
                            child: const Text( 
                              'New User Enrollment', 
                              style: TextStyle( 
                                fontSize: 17, 
                                fontWeight: FontWeight.w500, 
                                color: Colors.black87, 
                              ), 
                            ), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ), 
                  const SizedBox(height: 34), 
                  const Text( 
                    'END-TO-END ENCRYPTED • MILITARY GRADE SECURITY', 
                    textAlign: TextAlign.center, 
                    style: TextStyle( 
                      color: Colors.white, 
                      fontSize: 12.8, 
                      fontWeight: FontWeight.w500, 
                      letterSpacing: 1.0, 
                    ), 
                  ), 
                  const SizedBox(height: 20), 
                ], 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
class _InputField extends StatelessWidget { 
  final TextEditingController controller; 
  final String hintText; 
  final IconData icon; 
  final bool obscureText; 
  final TextInputType keyboardType; 
  final Widget? suffixIcon; 
 
  const _InputField({ 
    required this.controller, 
    required this.hintText, 
    required this.icon, 
    this.obscureText = false, 
    this.keyboardType = TextInputType.text, 
    this.suffixIcon, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return TextField( 
      controller: controller, 
      obscureText: obscureText, 
      keyboardType: keyboardType, 
      style: const TextStyle( 
        fontSize: 16, 
        color: Colors.black87, 
      ), 
      decoration: InputDecoration( 
        hintText: hintText, 
        hintStyle: TextStyle( 
          color: Colors.grey.shade500, 
          fontSize: 16, 
        ), 
        prefixIcon: Icon( 
          icon, 
          color: const Color(0xFF334155), 
          size: 24, 
        ), 
        suffixIcon: suffixIcon, 
        filled: true, 
        fillColor: Colors.white, 
        contentPadding: const EdgeInsets.symmetric( 
          horizontal: 16, 
          vertical: 18, 
        ), 
        enabledBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(16), 
          borderSide: BorderSide( 
            color: Colors.grey.shade300, 
            width: 1.2, 
          ), 
        ), 
        focusedBorder: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(16), 
          borderSide: const BorderSide( 
color: Color(0xFF2563EB), 
width: 1.5, 
), 
), 
), 
); 
} 
} 
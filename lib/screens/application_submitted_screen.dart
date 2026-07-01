
 
import 'package:flutter/material.dart'; 
 
class ApplicationSubmittedScreen extends StatelessWidget { 
  const ApplicationSubmittedScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      backgroundColor: const Color(0xFF0E47C9), 
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
          child: Center( 
            child: SingleChildScrollView( 
              child: Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20), 
                child: Container( 
                  width: double.infinity, 
                  padding: const EdgeInsets.all(24), 
                  decoration: BoxDecoration( 
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(28), 
                  ), 
                  child: Column( 
                    children: [ 
                      const SizedBox(height: 6), 
 
                      Container( 
                        height: 100, 
                        width: 100, 
                        decoration: const BoxDecoration( 
                          color: Color(0xFFFF9800), 
                          shape: BoxShape.circle, 
                        ), 
                        child: const Icon( 
                          Icons.access_time, 
                          color: Colors.white, 
                          size: 54, 
                        ), 
                      ), 
 
                      const SizedBox(height: 26), 
 
                      const Text( 
                        "Application Submitted", 
                        textAlign: TextAlign.center, 
                        style: TextStyle( 
                          fontSize: 28, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.black, 
                        ), 
                      ), 
 
                      const SizedBox(height: 16), 
 
                      const Text( 
                        "Your registration has been submitted to HQ for verification", 
                        textAlign: TextAlign.center, 
                        style: TextStyle( 
                          fontSize: 16, 
                          color: Colors.black87, 
                          height: 1.5, 
                        ), 
                      ), 
 
                      const SizedBox(height: 24), 
 
                      Container( 
                        width: double.infinity, 
                        padding: const EdgeInsets.all(18), 
                        decoration: BoxDecoration( 
                          color: const Color(0xFFFFFBEA), 
                          borderRadius: BorderRadius.circular(18), 
                          border: Border.all( 
                            color: const Color(0xFFF4D35E), 
                          ), 
                        ), 
                        child: const Column( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [ 
                            Text( 
                              "What happens next?", 
                              style: TextStyle( 
                                fontSize: 17, 
                                fontWeight: FontWeight.w600, 
                                color: Colors.black87, 
                              ), 
                            ), 
                            SizedBox(height: 16), 
                            _BulletRow( 
                              text: 
                                  "HQ will verify your documents and credentials", 
                            ), 
                            SizedBox(height: 14), 
                            _BulletRow( 
                              text: 
                                  "You'll receive User ID and Password via email", 
                            ), 
                            SizedBox(height: 14), 
                            _BulletRow( 
                              text: 
                                  "Biometric enrollment will be required on first login", 
                            ), 
                          ], 
                        ), 
                      ), 
 
                      const SizedBox(height: 20), 
 
                      Container( 
                        width: double.infinity, 
                        padding: const EdgeInsets.all(16), 
                        decoration: BoxDecoration( 
                          color: const Color(0xFFF3FAFF), 
                          borderRadius: BorderRadius.circular(16), 
                          border: Border.all( 
                            color: const Color(0xFFBFE7FF), 
                          ), 
                        ), 
                        child: const Row( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [ 
                            Icon( 
                              Icons.mail_outline, 
                              color: Colors.blue, 
                            ), 
                            SizedBox(width: 12), 
                            Expanded( 
                              child: Text( 
                                "Credentials will be sent to your registered email", 
                                style: TextStyle( 
                                  fontSize: 15, 
                                  color: Colors.black87, 
                                  height: 1.4, 
                                ), 
                              ), 
                            ), 
                          ], 
                        ), 
                      ), 
 
                      const SizedBox(height: 26), 
 
                      SizedBox( 
                        width: double.infinity, 
                        height: 55, 
                        child: ElevatedButton( 
                          onPressed: () { 
                            Navigator.pushNamedAndRemoveUntil( 
                              context, 
                              '/', 
                              (route) => false, 
                            ); 
                          }, 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: const Color(0xFF1358FF), 
                            shape: RoundedRectangleBorder( 
                              borderRadius: BorderRadius.circular(16), 
                            ), 
                          ), 
                          child: const Text( 
                            "Return to Login", 
                            style: TextStyle( 
                              color: Colors.white, 
                              fontSize: 18, 
                            ), 
                          ), 
                        ), 
                      ), 
 
                      const SizedBox(height: 20), 
 
                      const Text( 
                        "Approval typically takes 24–48 hours", 
                        textAlign: TextAlign.center, 
                        style: TextStyle( 
                          fontSize: 15, 
                          color: Colors.black54, 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
} 
 
class _BulletRow extends StatelessWidget { 
  final String text; 
 
  const _BulletRow({required this.text}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Row( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        const Icon( 
          Icons.check_circle_outline, 
          color: Colors.black87, 
          size: 22, 
        ), 
        const SizedBox(width: 10), 
        Expanded( 
          child: Text( 
            text, 
            style: const TextStyle( 
              fontSize: 15, 
              color: Colors.black87, 
              height: 1.4, 
            ), 
          ), 
        ), 
      ], 
    ); 
  } 
} 
 

 
import 'package:flutter/material.dart'; 
 
class RegistrationStep4Screen extends StatelessWidget { 
  const RegistrationStep4Screen({super.key}); 
 
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
          child: SingleChildScrollView( 
            child: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18), 
              child: Column( 
                children: [ 
                  const SizedBox(height: 6), 
 
                  // top row 
                  Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [ 
                      InkWell( 
                        onTap: () { 
                          Navigator.pop(context); 
                        }, 
                        child: const Row( 
                          children: [ 
                            Icon( 
                              Icons.arrow_back, 
                              color: Colors.white, 
                              size: 24, 
                            ), 
                            SizedBox(width: 6), 
                            Text( 
                              "Back", 
                              style: TextStyle( 
                                color: Colors.white, 
                                fontSize: 18, 
                              ), 
                            ), 
                          ], 
                        ), 
                      ), 
                      const Text( 
                        "Step 4 of 4", 
                        style: TextStyle( 
                          color: Colors.white, 
                          fontSize: 17, 
                        ), 
                      ), 
                    ], 
                  ), 
 
                  const SizedBox(height: 22), 
 
                  // progress bar 
                  Container( 
                    height: 10, 
                    width: double.infinity, 
                    decoration: BoxDecoration( 
                      color: Colors.white.withOpacity(0.35), 
                      borderRadius: BorderRadius.circular(20), 
                    ), 
                    child: Row( 
                      children: [ 
                        Expanded( 
                          child: Container( 
                            decoration: BoxDecoration( 
                              color: Colors.blueAccent, 
                              borderRadius: BorderRadius.circular(20), 
                            ), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ), 
 
                  const SizedBox(height: 28), 
 
                  // white card 
                  Container( 
                    width: double.infinity, 
                    padding: const EdgeInsets.all(22), 
                    decoration: BoxDecoration( 
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(28), 
                    ), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        // icon + title 
                        Row( 
                          children: [ 
                            Container( 
                              height: 75, 
                              width: 75, 
                              decoration: BoxDecoration( 
                                gradient: const LinearGradient( 
                                  colors: [ 
                                    Color(0xFF1358FF), 
                                    Color(0xFF7B2CF6), 
                                  ], 
                                ), 
                                borderRadius: BorderRadius.circular(20), 
                              ), 
                              child: const Icon( 
                                Icons.shield_outlined, 
                                color: Colors.white, 
                                size: 38, 
                              ), 
                            ), 
                            const SizedBox(width: 16), 
                            const Expanded( 
                              child: Column( 
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: [ 
                                  Text( 
                                    "Personnel Registration", 
                                    style: TextStyle( 
                                      fontSize: 25, 
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.black, 
                                    ), 
                                  ), 
                                  SizedBox(height: 4), 
                                  Text( 
                                    "Authorized Access Only", 
                                    style: TextStyle( 
                                      fontSize: 15, 
                                      color: Colors.black54, 
                                    ), 
                                  ), 
                                ], 
                              ), 
                            ), 
                          ], 
                        ), 
 
                        const SizedBox(height: 30), 
 
                        const Text( 
                          "PROFILE PHOTO", 
                          style: TextStyle( 
                            fontWeight: FontWeight.w600, 
                            fontSize: 13, 
                          ), 
                        ), 
                        const SizedBox(height: 10), 
 
                        Container( 
                          height: 190, 
                          width: double.infinity, 
                          decoration: BoxDecoration( 
                            border: Border.all( 
                              color: Colors.grey.shade400, 
                              width: 1.5, 
                            ), 
                            borderRadius: BorderRadius.circular(18), 
                          ), 
                          child: const Column( 
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [ 
                              Icon( 
                                Icons.camera_alt_outlined, 
                                size: 52, 
                                color: Colors.grey, 
                              ), 
                              SizedBox(height: 14), 
                              Text( 
                                "17731219619788824475374634285342.jpg", 
                                textAlign: TextAlign.center, 
                                style: TextStyle( 
                                  fontSize: 15, 
                                  color: Colors.black87, 
                                ), 
                              ), 
                              SizedBox(height: 8), 
                              Text( 
                                "Clear front-facing photo required", 
                                style: TextStyle( 
                                  fontSize: 13, 
                                  color: Colors.black54, 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
 
                        const SizedBox(height: 22), 
 
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
                                Icons.shield_outlined, 
                                color: Colors.blue, 
                              ), 
                              SizedBox(width: 12), 
                              Expanded( 
                                child: Text( 
                                  "Biometric enrollment will be required after HQ approval", 
                                  style: TextStyle( 
                                    fontSize: 14, 
                                    color: Colors.black87, 
                                    height: 1.4, 
                                  ), 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
 
                        const SizedBox(height: 18), 
 
                        Container( 
                          width: double.infinity, 
                          padding: const EdgeInsets.all(16), 
                          decoration: BoxDecoration( 
                            color: const Color(0xFFFFFBEA), 
                            borderRadius: BorderRadius.circular(16), 
                            border: Border.all( 
                              color: const Color(0xFFF4D35E), 
                            ), 
                          ), 
                          child: const Column( 
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [ 
                              Text( 
                                "Important Notice", 
                                style: TextStyle( 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w600, 
                                  color: Colors.black87, 
                                ), 
                              ), 
                              SizedBox(height: 10), 
                              Text( 
                                "Your credentials (User ID & Password) will be sent after HQ verifies and approves your application.", 
                                style: TextStyle( 
                                  fontSize: 14, 
                                  color: Colors.black87, 
                                  height: 1.4, 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
 
                        const SizedBox(height: 28), 
 
                        SizedBox( 
                          width: double.infinity, 
                          height: 55, 
                          child: ElevatedButton( 
                            onPressed: () { 
                              Navigator.pushNamed(context, '/submitted'); 
                            }, 
                            style: ElevatedButton.styleFrom( 
                              backgroundColor: const Color(0xFF1358FF), 
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(16), 
                              ), 
                            ), 
                            child: const Text( 
                              "Submit for HQ Approval", 
                              style: TextStyle( 
                                color: Colors.white, 
                                fontSize: 18, 
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
        ), 
      ), 
    ); 
  } 
} 
 
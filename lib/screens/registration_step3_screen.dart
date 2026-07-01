
import 'package:flutter/material.dart'; 
 
class RegistrationStep3Screen extends StatelessWidget { 
  const RegistrationStep3Screen({super.key}); 
 
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
                        "Step 3 of 4", 
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
                        Container( 
                          width: MediaQuery.of(context).size.width * 0.60, 
                          decoration: BoxDecoration( 
                            color: Colors.blueAccent, 
                            borderRadius: BorderRadius.circular(20), 
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
                          "IDENTITY PROOF", 
                          style: TextStyle( 
                            fontWeight: FontWeight.w600, 
                            fontSize: 13, 
                          ), 
                        ), 
                        const SizedBox(height: 10), 
                        const _UploadBox( 
                          title: "Click to upload ID", 
                          subtitle: "PDF, PNG, or JPG (max. 5MB)", 
                        ), 
 
                        const SizedBox(height: 22), 
 
                        const Text( 
                          "RELATIONSHIP PROOF", 
                          style: TextStyle( 
                            fontWeight: FontWeight.w600, 
                            fontSize: 13, 
                          ), 
                        ), 
                        const SizedBox(height: 10), 
                        const _UploadBox( 
                          title: "Upload relationship proof", 
                          subtitle: "PDF, PNG, or JPG (max. 5MB)", 
                        ), 
 
                        const SizedBox(height: 28), 
 
                        SizedBox( 
                          width: double.infinity, 
                          height: 55, 
                          child: ElevatedButton( 
                            onPressed: () { 
                              Navigator.pushNamed(context, '/step4'); 
                            }, 
                            style: ElevatedButton.styleFrom( 
                              backgroundColor: const Color(0xFF1358FF), 
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(16), 
                              ), 
                            ), 
                            child: const Text( 
                              "Continue", 
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
 
class _UploadBox extends StatelessWidget { 
  final String title; 
  final String subtitle; 
 
  const _UploadBox({ 
    required this.title, 
    required this.subtitle, 
  }); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      height: 180, 
      width: double.infinity, 
      decoration: BoxDecoration( 
        border: Border.all( 
          color: Colors.grey.shade400, 
          width: 1.5, 
        ), 
        borderRadius: BorderRadius.circular(18), 
      ), 
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [ 
          const Icon( 
            Icons.upload_outlined, 
            size: 52, 
            color: Colors.grey, 
          ), 
          const SizedBox(height: 14), 
          Text( 
            title, 
            style: const TextStyle( 
              fontSize: 17, 
              color: Colors.black87, 
            ), 
          ), 
          const SizedBox(height: 8), 
          Text( 
            subtitle, 
            style: const TextStyle( 
              fontSize: 13, 
              color: Colors.black54, 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
} 
 
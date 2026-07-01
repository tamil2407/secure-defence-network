
 
import 'package:flutter/material.dart'; 
 
class RegistrationStep1Screen extends StatelessWidget { 
  const RegistrationStep1Screen({super.key}); 
 
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
                        "Step 1 of 4", 
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
                          width: MediaQuery.of(context).size.width * 0.20, 
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
                          "FULL NAME",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            ),
                            ), 
                        const SizedBox(height: 8), 
                        const _AppTextField( 
                          hintText: "Enter your full name", 
                          icon: Icons.person_outline, 
                        ), 
 
                        const SizedBox(height: 20), 
 
                        const Text(
                          "OFFICIAL EMAIL",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ), 
                        const SizedBox(height: 8), 
                        const _AppTextField( 
                          hintText: "your.email@defence.gov.in", 
                          icon: Icons.mail_outline, 
                        ), 
 
                        const SizedBox(height: 8), 
 
                        const Text(
                          "Credentials will be sent to this email",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ), 
 
                        const SizedBox(height: 20), 
 
                        const Text(
                          "MOBILE NUMBER",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            ),
                          ), 
                        const SizedBox(height: 8), 
                        const _AppTextField( 
                          hintText: "+91 XXXXX XXXXX", 
                          icon: Icons.call_outlined, 
                        ), 
 
                        const SizedBox(height: 28), 
 
                        SizedBox( 
                          width: double.infinity, 
                          height: 55, 
                          child: ElevatedButton( 
                            onPressed: () { 
                              Navigator.pushNamed(context, '/step2'); 
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
 
class _AppTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const _AppTextField({
    super.key,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      cursorColor: const Color(0xFF1358FF),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black54,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF1358FF),
            width: 2,
          ),
        ),
      ),
    );
  }
}
 
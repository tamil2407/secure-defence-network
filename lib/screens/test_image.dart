
import 'dart:io'; 
import 'package:flutter/material.dart'; 
import 'package:image_picker/image_picker.dart'; 
 
class TestImage extends StatefulWidget { 
  const TestImage({super.key}); 
 
  @override 
  State<TestImage> createState() => _TestImageState(); 
} 
 
class _TestImageState extends State<TestImage> { 
 
  File? image; 
 
  final picker = ImagePicker(); 
 
  Future pickImage() async { 
 
    final picked = await picker.pickImage(source: ImageSource.gallery); 
 
    if(picked != null){ 
      setState(() { 
        image = File(picked.path); 
      }); 
    } 
 
  } 
 
  @override 
  Widget build(BuildContext context) { 
 
    return Scaffold( 
 
      appBar: AppBar(title: const Text("Image Picker Test")), 
 
      body: Center( 
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
 
            image != null 
                ? Image.file(image!, height:200) 
                : const Text("No Image Selected"), 
 
            const SizedBox(height:20), 
 
            ElevatedButton( 
              onPressed: pickImage, 
              child: const Text("Pick Image"), 
            ) 
 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
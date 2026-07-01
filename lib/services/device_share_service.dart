
 
import 'package:file_picker/file_picker.dart'; 
import 'package:geolocator/geolocator.dart'; 
import 'package:image_picker/image_picker.dart'; 
 
import '../models/app_models.dart'; 
 
class DeviceShareService { 
  DeviceShareService._(); 
 
  static final ImagePicker _picker = ImagePicker(); 
 
  static Future<XFile?> pickImageFromGallery() async { 
    return await _picker.pickImage( 
      source: ImageSource.gallery, 
      imageQuality: 80, 
    ); 
  } 
 
  static Future<XFile?> pickImageFromCamera() async { 
    return await _picker.pickImage( 
      source: ImageSource.camera, 
      imageQuality: 80, 
    ); 
  } 
 
  static Future<PlatformFile?> pickDocument() async { 
    final result = await FilePicker.platform.pickFiles( 
      allowMultiple: false, 
      withData: false, 
      type: FileType.any, 
    ); 
 
    if (result == null) return null; 
    if (result.files.isEmpty) return null; 
 
    return result.files.first; 
  } 
 
  static Future<SharedLocationData?> getCurrentLocation() async { 
    bool enabled = await Geolocator.isLocationServiceEnabled(); 
 
    if (!enabled) { 
      throw Exception('Location service disabled.'); 
    } 
 
    LocationPermission permission = await Geolocator.checkPermission(); 
 
    if (permission == LocationPermission.denied) { 
      permission = await Geolocator.requestPermission(); 
    } 
 
    if (permission == LocationPermission.denied) { 
      throw Exception('Location permission denied.'); 
    } 
 
    if (permission == LocationPermission.deniedForever) { 
      throw Exception('Location permission permanently denied.'); 
    } 
 
    final position = await Geolocator.getCurrentPosition( 
      desiredAccuracy: LocationAccuracy.high, 
    ); 
 
    return SharedLocationData( 
      latitude: position.latitude, 
      longitude: position.longitude, 
      label: 
          'Lat ${position.latitude.toStringAsFixed(5)}, Lng ${position.longitude.toStringAsFixed(5)}', 
    ); 
  } 
} 
 
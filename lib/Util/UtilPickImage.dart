import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  
  return file;

}
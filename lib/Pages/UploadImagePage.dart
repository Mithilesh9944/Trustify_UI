import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project/Util/UtilPages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_project/Util/UtilPickImage.dart';
import 'package:flutter_project/Pages/PostAdPage.dart';
class UploadImagePage extends StatefulWidget {
 final Map<String,dynamic> p_details;

  const UploadImagePage({ required this.p_details,super.key});

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final List<File> _selectedPhotos = [];

  Future<void> _pickImages(ImageSource source) async {
    final XFile? pickedImage = await pickImage(source);
    if (pickedImage != null) {
      setState(() {
        _selectedPhotos.add(File(pickedImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload your photos", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 109, 190, 231),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: UtilitiesPages.buildPadding(context),
        child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedPhotos.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () => _pickImages(ImageSource.camera),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
                      ),
                    ),
                  );
                } else if (index == 1) {
                  return GestureDetector(
                    onTap: () => _pickImages(ImageSource.gallery),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Icon(Icons.photo_library, size: 40, color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Image.file(
                    File(_selectedPhotos[index - 2].path),
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
          ),
          Text(
            "You have given TRUSTIFY access to only a select number of photos.",
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Manage", style: TextStyle(color: Colors.blue)),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 109, 190, 231), // White background
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: _selectedPhotos.isNotEmpty ? () {
                 print(widget.p_details);
                 print(_selectedPhotos);
                  widget.p_details['img_list'] = _selectedPhotos;

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PostAdPage(pDetails:widget.p_details)));

                } : null,
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
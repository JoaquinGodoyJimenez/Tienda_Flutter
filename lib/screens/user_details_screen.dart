import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:tienda/provider/userphoto_provider.dart';
import 'dart:io';

import '../firebase/user_firebase.dart';
import '../provider/font_provider.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  UserFirebase userFirebase = UserFirebase();
  
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String? userEmail = auth.currentUser?.email.toString() ?? '';
    String? userPhoto = auth.currentUser?.photoURL.toString();
    final fontProvider = Provider.of<FontProvider>(context);
    String font = fontProvider.selectedFontFamily; 
    final userPhotoProvider = Provider.of<UserPhotoProvider>(context);
    ImagePicker imagePicker = ImagePicker();
    String imageUrl = 'https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png';

    if (userPhoto == 'null') {
      userPhoto =
          'https://www.grouphealth.ca/wp-content/uploads/2018/05/placeholder-image.png';
    }

    return Scaffold(
      body: StreamBuilder(
        stream: userFirebase.getUserByEmail(userEmail),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  userPhotoProvider.imageUrl = snapshot.data!.docs[index].get('photoURL');
                });
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () async {
                          final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(userEmail);
                          if (signInMethods.contains('password')) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context, 
                              builder: (context) => AlertDialog(
                                title: Text('Cambiar imagen',textAlign: TextAlign.center,style: TextStyle(fontFamily: font)),
                                actions: [
                                  ElevatedButton.icon (
                                    onPressed: () async {
                                      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                                      if (file == null) return;
                                      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                                      Reference referenceRoot = FirebaseStorage.instance.ref();
                                      Reference referenceDirImages = referenceRoot.child('images');
                                      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);                                       
                                      try {
                                        await referenceImageToUpload.putFile(File(file.path));
                                        imageUrl = await referenceImageToUpload.getDownloadURL();
                                        // ignore: use_build_context_synchronously
                                        final imageProvider = Provider.of<UserPhotoProvider>(context, listen: false);
                                        imageProvider.imageUrl = imageUrl;
                                        userFirebase.updUser({'photoURL' : imageUrl}, snapshot.data.docs[index].id);                                       
                                      } catch (error) {
                                        print(error);
                                      }
                                    }, 
                                    icon: const Icon(Icons.camera), 
                                    label: const Text('Cámara'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      )
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () async{
                                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                                      if (file == null) return;
                                      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
                                      Reference referenceRoot = FirebaseStorage.instance.ref();
                                      Reference referenceDirImages = referenceRoot.child('images');
                                      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);                                       
                                      try {
                                        await referenceImageToUpload.putFile(File(file.path));
                                        imageUrl = await referenceImageToUpload.getDownloadURL();
                                        // ignore: use_build_context_synchronously
                                        final imageProvider = Provider.of<UserPhotoProvider>(context, listen: false);
                                        imageProvider.imageUrl = imageUrl;
                                        userFirebase.updUser({'photoURL' : imageUrl}, snapshot.data.docs[index].id);                                       
                                      } catch (error) {
                                        print(error);
                                      }
                                    }, 
                                    icon: const Icon(Icons.photo_library), 
                                    label: const Text('Gallería'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            );                 
                          }
                        },
                        child: Consumer<UserPhotoProvider>(
                          builder: (context, imageProvider, child) {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(imageProvider.imageUrl),
                              backgroundColor: Colors.grey.shade300,
                              radius: 50,
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        snapshot.data!.docs[index].get('name'),
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        snapshot.data!.docs[index].get('email'),
                        style: TextStyle(
                          fontFamily: font,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(height: 15),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error en la petición, Intente de nuevo.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

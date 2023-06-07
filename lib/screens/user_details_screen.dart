import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:tienda/api/categoria_api.dart';
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
                return SingleChildScrollView(
                  child: Center(
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
                                          Navigator.pop(context);
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
                                          Navigator.pop(context);
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
                        const SizedBox(height: 40),
                        //Aqui va el nuevo diseño del dash
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Proveedores', 
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: font, 
                                fontSize: 25, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/proveedores'), 
                              icon: const Icon(Icons.add), 
                              label: Text('Detalles', style: TextStyle(fontFamily: font),)
                            )                            
                          ],
                        ),
                        Container(
                          height: 300,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 2
                            ),
                            color:Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.blue)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Lunes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Bonafont', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Pepsi', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Marlboro', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.red)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Martes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Coca cola', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Abarrotes', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.yellow)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Miércoles', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Ninguno', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.green)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Jueves', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Coca cola', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Aga', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.orange)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Viernes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Bonafont', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.purple)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Sábado', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Peñafiel', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),                               
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Marcas', 
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: font, 
                                fontSize: 25, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => Navigator.pushNamed(context, '/marcas'), 
                              icon: const Icon(Icons.add), 
                              label: Text('Detalles', style: TextStyle(fontFamily: font),)
                            )                            
                          ],
                        ),
                        Container(
                          height: 480,
                          width: 420,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.green,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Sprite', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.black45,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Coca cola Zero', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.orange,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Fanta', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.brown,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Sidral mundet', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Coca cola', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.blue.shade900,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.orange,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Mirinda', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('manzanita sol', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.green,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('7up', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.blueAccent,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Epura', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Pepsi', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.yellow.shade700,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Cheetos', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),                                        
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.green,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Tostitos', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.red,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Doritos', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.yellow.shade700,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Fritos', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20,),
                                        Container(
                                          height: 150,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.pink,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Churrumais', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                                              const SizedBox(height: 10,),
                                              Text('Proveedor: Sabritas', style: TextStyle(fontFamily: font, color: Colors.white, fontWeight: FontWeight.bold,),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Entrega', 
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: font, 
                                fontSize: 25, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {}, 
                              icon: const Icon(Icons.add), 
                              label: Text('Detalles', style: TextStyle(fontFamily: font),)
                            )                            
                          ],
                        ),
                        Container(
                          height: 400,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 2
                            ),
                            color:Colors.white
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.blue)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Lunes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Peñafiel', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 110, decoration: const BoxDecoration(color: Colors.red)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Martes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Bonafont', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Pepsi', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Aga', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Sabritas', style: TextStyle(fontFamily: font, color: Colors.black54),),                                       
                                          const SizedBox(height: 5,),
                                          Text('Capistrano', style: TextStyle(fontFamily: font, color: Colors.black54),), 
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 100, decoration: const BoxDecoration(color: Colors.yellow)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Miércoles', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Coca cola', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Boing', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Abarrotes', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Luzma', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.green)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Jueves', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Bimbo', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [                                  
                                  Row(
                                    children: [
                                      Container(width: 5, height: 70, decoration: const BoxDecoration(color: Colors.orange)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Viernes', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Coca cola', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Aga', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                          const SizedBox(height: 5,),
                                          Text('Barcel', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(width: 5, height: 60, decoration: const BoxDecoration(color: Colors.purple)),
                                      const SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          Text('Sábado', style: TextStyle(fontFamily: font, color: Colors.black54, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text('Bonafont', style: TextStyle(fontFamily: font, color: Colors.black54),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),                               
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/proveedores'), 
                                    icon: const Icon(Icons.person), 
                                    label: const Text("Proveedores"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/marcas'), 
                                    icon: const Icon(Icons.shopping_bag), 
                                    label: const Text("Marcas"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {}, 
                                    icon: const Icon(Icons.card_giftcard), 
                                    label: const Text("Productos"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/ventas'), 
                                    icon: const Icon(Icons.credit_card), 
                                    label: const Text("Ventas"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/categories'), 
                                    icon: const Icon(Icons.category), 
                                    label: const Text("Categorias"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pushNamed(context, '/empleados'), 
                                    icon: const Icon(Icons.work), 
                                    label: const Text("Empleados"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black26,
                                      minimumSize: const Size(190, 140),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),                  
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),  
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
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

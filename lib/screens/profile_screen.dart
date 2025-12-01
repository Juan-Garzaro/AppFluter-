import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? imageBytes;
  String? base64Image;

  bool loadingImage = false;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImageFromBackend();
  }

  // Cargar imagen desde backend
  Future<void> _loadImageFromBackend() async {
    final url = Uri.parse("http://192.168.0.3:3000/api/users/${widget.user['id']}");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["profile_image"] != null) {
        String base64String = data["profile_image"];
        if (base64String.contains(",")) {
          base64String = base64String.split(",")[1];
        }

        setState(() {
          imageBytes = base64Decode(base64String);
        });
      }
    }
  }

  // Seleccionar desde galería
  Future<void> pickFromGallery() async {
    final XFile? photo =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        imageBytes = bytes;
        base64Image = base64Encode(bytes);
      });

      _uploadImage();
    }
  }

  // Tomar foto con cámara
  Future<void> pickFromCamera() async {
    final XFile? photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        imageBytes = bytes;
        base64Image = base64Encode(bytes);
      });

      _uploadImage();
    }
  }

  // Subir imagen al backend
  Future<void> _uploadImage() async {
    if (base64Image == null) return;

    setState(() => loadingImage = true);

    final url = Uri.parse("http://192.168.0.3:3000/api/users/${widget.user['id']}/profile-image");


    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "profile_image": "data:image/jpeg;base64,$base64Image",
      }),
    );

    setState(() => loadingImage = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Imagen actualizada")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al subir imagen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // FOTO DE PERFIL
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        imageBytes != null ? MemoryImage(imageBytes!) : null,
                    child: imageBytes == null
                        ? const Icon(Icons.person, size: 80)
                        : null,
                  ),
                  if (loadingImage)
                    const CircularProgressIndicator(
                      color: Colors.red,
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Botones de foto
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Cámara"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.photo),
                    label: const Text("Galería"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Información del usuario
              Text(
                user['name'],
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Edad: ${user['age']}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 5),
              Text(
                user['email'],
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:atividade_images/componentes/header.dart';
import 'package:atividade_images/pages/geo_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapturePage extends StatefulWidget {
  const ImageCapturePage({super.key, required this.title});
  final String title;

  @override
  State<ImageCapturePage> createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _images.add(pickedFile);
        });
      }
    } catch (e) {
      // Tratar erros (ex: permissão negada)
      debugPrint("Erro ao selecionar imagem: $e");
    }
  }

  Widget _buildImageList() {
    if (_images.isEmpty) {
      return const Center(child: Text('Nenhuma imagem selecionada.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 imagens por linha
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        return Image.file(File(_images[index].path), fit: BoxFit.cover);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cor do Header: 0xFFFF1744 (Vermelho forte)
    const headerColor = Color(0xFFFF1744);

    return Scaffold(
      // Fundo cinza claro
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          const Header(), // SEU COMPONENTE NO TOPO 🎯
          // Botões para Câmera e Galeria
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerColor, // Cor do Header
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerColor, // Cor do Header
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),
          ),
          // Adiciona um espaço extra e o Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(thickness: 2),
          ),

          // Lista de Imagens (Expandida)
          Expanded(child: _buildImageList()),

          // Botão do Mapa
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GeoPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerColor, // Cor do Header
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Mapa"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

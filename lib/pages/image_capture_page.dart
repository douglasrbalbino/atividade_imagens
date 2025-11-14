import 'dart:io'; // Necessário para Image.file
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
  // Lista para armazenar os arquivos de imagem selecionados/capturados
  final List<XFile> _images = [];
  // Instância do ImagePicker
  final ImagePicker _picker = ImagePicker();

  /// Captura uma imagem usando a fonte especificada (Câmera ou Galeria)
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

  /// Constrói a lista de imagens
  Widget _buildImageList() {
    if (_images.isEmpty) {
      return const Center(child: Text('Nenhuma imagem selecionada.'));
    }

    // Usando GridView para uma exibição em grade.
    // Para uma lista vertical, use ListView.builder
    // Para uma lista horizontal, use ListView.builder com scrollDirection: Axis.horizontal e um height fixo.
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 imagens por linha
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        // Image.file é usado para exibir imagens do sistema de arquivos do dispositivo
        return Image.file(File(_images[index].path), fit: BoxFit.cover);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Botões para Câmera e Galeria
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Câmera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),
          ),
          const Divider(),
          // A lista de imagens ocupa o espaço restante
          Expanded(child: _buildImageList()),
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

                  child: Text("Mapa"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

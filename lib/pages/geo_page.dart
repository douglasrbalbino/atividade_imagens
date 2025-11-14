import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
// Importação do seu serviço de localização
import 'package:atividade_images/services/location_service.dart';

class GeoPage extends StatefulWidget {
  const GeoPage({super.key, required this.title});
  final String title;

  @override
  State<GeoPage> createState() => _GeoPageState();
}

class _GeoPageState extends State<GeoPage> {
  // 1. Estado para armazenar a posição, erros e status de carregamento
  Position? _currentPosition;
  String? _locationError;
  bool _isLoading = true;

  // 2. Instância do serviço e controlador do mapa
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Inicia a busca pela localização ao abrir a tela
    _fetchLocation();
  }

  // 3. Função para buscar a localização e atualizar o estado
  void _fetchLocation() async {
    // 3a. Inicia o carregamento
    setState(() {
      _isLoading = true;
      _locationError = null;
    });

    try {
      Position position = await _locationService.determinePosition();

      // 3b. Atualiza o estado com a nova posição
      setState(() {
        _currentPosition = position;
        _isLoading = false;

        // CORREÇÃO APLICADA:
        // Chamada de _mapController.move() REMOVIDA.
        // O mapa se centralizará na próxima renderização via MapOptions(initialCenter)
      });
    } catch (e) {
      // 3c. Trata erros e notifica o usuário
      setState(() {
        // Remove a parte 'Exception: ' ou 'Error: ' para uma mensagem mais limpa
        _locationError = e
            .toString()
            .replaceFirst('Exception: ', '')
            .replaceFirst('Error: ', '');
        _isLoading = false;
      });

      // Define uma posição padrão se for a primeira falha, para exibir um mapa base.
      if (_currentPosition == null) {
        _currentPosition = Position.fromMap({
          'latitude': -23.5505,
          'longitude': -46.6333,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }); // Posição Padrão (São Paulo)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Posição de fallback para o mapa, usada se _currentPosition ainda for null
    final currentCenter = LatLng(
      _currentPosition?.latitude ?? -23.5505,
      _currentPosition?.longitude ?? -46.6333,
    );
    const double initialZoom = 15.0;

    Widget bodyContent;

    if (_isLoading && _currentPosition == null) {
      // Tela de carregamento inicial
      bodyContent = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Carregando localização...'),
            ),
          ],
        ),
      );
    } else if (_locationError != null) {
      // Tela de erro de permissão/serviço
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                'Erro de Geolocalização: $_locationError',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchLocation,
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    } else {
      // Exibição do mapa
      bodyContent = FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          // O mapa usa a posição atualizada, resolvendo o problema de centralização.
          initialCenter: currentCenter,
          initialZoom: initialZoom,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.atividade_images',
          ),
          // Marcador na localização atual
          MarkerLayer(
            markers: [
              Marker(
                point: currentCenter,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: bodyContent,

      // Botão para forçar a atualização da localização (ou no próximo passo, Capturar Foto)
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _fetchLocation,
        tooltip: 'Recarregar Localização',
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Icon(Icons.refresh),
      ),
    );
  }
}

import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Retorna a posição atual do dispositivo, tratando permissões e erros.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Teste se os serviços de localização estão ativados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviços de localização estão desativados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissões de localização foram negadas.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permissões de localização foram negadas permanentemente. Por favor, habilite nas configurações do dispositivo.',
      );
    }

    // Permissões concedidas, retorne a localização.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

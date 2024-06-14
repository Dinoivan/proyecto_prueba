import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

Future<Citizen> citizenById(String token, int id) async{

  try {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/v1/citizen/getCitizenById/$id'),
      headers: {
        'Authorization': '$token',
      });

    if(response.statusCode == 200){

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      Citizen citizen = Citizen(
          active: responseData['true'] ?? true,
          alias: responseData['alias'] ?? '',
          birthdayDate: responseData['birthdayDate'].toString(),
          email: responseData['email'] ?? '',
          firstname: responseData['firstname'] ?? '',
          fullname: responseData['fullname'] ?? '',
          lastname: responseData['lastname'] ?? '',
          password: responseData['password'] ?? '',
      );
      return citizen;
    }else{
      throw Exception('Failed to load citizen');
    }

}catch(e){
    throw Exception('Failed to load citizen: $e');
  }

}

//Actualizar información de perfil de usuario
Future<CitizenUpdate> updateCitizen(CitizenUpdate updatedCitizen, String? token, int? userId) async{
  try{
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/citizen/updateCitizen/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode({
          'birthdayDate': updatedCitizen.birthdayDate,
          'email': updatedCitizen.email,
          'firstname': updatedCitizen.firstname,
          'lastname': updatedCitizen.lastname,
        }),
    );
        if(response.statusCode == 200){

          final updatedData = CitizenUpdate(
              birthdayDate: updatedCitizen.birthdayDate,
              email: updatedCitizen.email,
              firstname: updatedCitizen.firstname,
              lastname: updatedCitizen.lastname);

          return updatedData;
    }else{
          throw Exception('Failed to update citizen');
        }
  }catch(e){
    throw Exception('Failed to update citizen: $e');
  }
}

Future<File> downloadImage(String imageUrl) async {
  var response = await http.get(Uri.parse(imageUrl));
  var documentDirectory = Directory.systemTemp;
  File file = File('${documentDirectory.path}/image.jpg');
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

Future<void> savePhoto(String token, File imageFile) async {
  const int maxRetries = 3;
  int retryCount = 0;
  bool photoSaved = false; // Bandera para indicar si la foto se ha guardado correctamente
  final List<String> validExtensions = ['.jpg', '.png', '.jpeg', '.gif', '.bmp', '.webp', '.tiff', '.ico', '.svg'];

  while (!photoSaved && retryCount < maxRetries) {
    try {
      // Verificar si el archivo seleccionado es una imagen válida
      List<int> imageBytes = await imageFile.readAsBytes();
      String extension = '.' + imageFile.path.split('.').last.toLowerCase();
      if (!validExtensions.contains(extension)) {
        throw Exception('Extensión de archivo no válida. Solo se permiten archivos JPG, PNG, JPEG, GIF, BMP, WEBP, TIFF, ICO o SVG');
      }

      String fileNameWithoutExtension = path.basenameWithoutExtension(imageFile.path);
      String base64Image = base64Encode(imageBytes);

      Map<String, dynamic> requestBody = {
        "active": true,
        "extension": extension,
        "image": base64Image,
        "name": fileNameWithoutExtension
      };

      print('Datos de la solicitud: $requestBody');
      print('Nombre del archivo sin extensión: $fileNameWithoutExtension');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/v1/userProfileImage/uploadUserProfileImage'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print("Estado: ${response.statusCode}");
      if (response.statusCode == 200) {
        print('Foto guardada exitosamente');
        photoSaved = true;
      } else {
        print('Error al guardar la foto: ${response.body}');
        throw Exception('Error al guardar la foto. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error durante la carga de la foto: $e');
      retryCount++;
      print('Conteo de reintentos $retryCount de $maxRetries');
      await Future.delayed(Duration(seconds: 1));
    }
  }

  throw Exception('Error al guardar la foto después de $maxRetries intentos');
}

Future<http.Response> getImageById(String token, int imageId) async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/v1/userProfileImage/getAllUserProfileImageByCitizenId/$imageId'), // Reemplaza 'images' por la ruta correspondiente en tu API
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  return response;
}


Future<String> citizenFirstnameById(String token, int id) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v1/citizen/getCitizenById/$id'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String firstname = responseData['firstname'] ?? '';
      return firstname;
    } else {
      throw Exception('Failed to load citizen');
    }
  } catch (e) {
    print('Error: $e');
    return ''; // Devuelve una cadena vacía en caso de error
  }
}



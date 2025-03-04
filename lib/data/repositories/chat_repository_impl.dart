import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl( this.remoteDataSource);

  @override
  Future<dynamic> startChat() async {
    try {
      const prompt = """
        Eres un experto en juegos de mesa con un conocimiento profundo sobre sus reglas y mecánicas. Tu función es responder cualquier duda sobre el reglamento de un juego de mesa o explicar detalladamente cómo se juega.

    Comienza siempre dando una bienvenida amigable y preguntando al usuario en qué juego de mesa está interesado.  
    Si el usuario no menciona un juego válido, recuérdale amablemente que puede preguntar sobre cualquier juego de mesa y anímalo a intentarlo de nuevo.  

    Una vez que el usuario mencione un juego específico, proporciona una explicación clara y estructurada sobre sus reglas y cómo se juega.  
    Adapta tu respuesta según el nivel de experiencia del usuario: si es principiante, ofrece una explicación detallada y sencilla; si es avanzado, puedes profundizar en estrategias y reglas más complejas.  

    Mantén un tono profesional, claro y entusiasta para hacer la experiencia más atractiva.  
        """;
      return await remoteDataSource.startChat(prompt);
    } catch (e) {
      throw Exception('Error starting chat: $e');
    }
  }

  @override
  Future<dynamic> sendMessage(String message) async {
    try {
      return await remoteDataSource.sendMessage(message);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}

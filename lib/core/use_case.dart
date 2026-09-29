import 'dart:typed_data';

abstract class UseCase<T, Params> {
  Future<T> call(Params params);
}

class NoParams {}

class GetShopUseCaseParams {
  final int idShop;

  GetShopUseCaseParams({required this.idShop});
}

class StadisticsParams {
  final int idShop;
  final String startTime;
  final String endTime;

  StadisticsParams({
    required this.idShop,
    required this.startTime,
    required this.endTime,
  });
}

class GetShopsByOwnerUseCaseParams {
  final String idOwner;

  GetShopsByOwnerUseCaseParams({required this.idOwner});
}

class GetTablesByShopUseCaseParams {
  final int idShop;

  GetTablesByShopUseCaseParams({required this.idShop});
}

class UserToReserveUseCaseParams {
  final int idReserve;
  final String idUser;

  UserToReserveUseCaseParams({required this.idReserve, required this.idUser});
}

class GetReservesByDateUseCaseParams {
  final DateTime date;
  final int idTable;

  GetReservesByDateUseCaseParams({required this.date, required this.idTable});
}

class IdReserveParams {
  final int idReserve;

  IdReserveParams({required this.idReserve});
}

class GetReserveFromUsersUseCaseParams {
  final String idUser;

  GetReserveFromUsersUseCaseParams({required this.idUser});
}

class GetEventsParams {
  final int idShop;

  GetEventsParams({required this.idShop});
}

class UpdateTokenNotificationParams {
  final String userId;
  final String token;

  UpdateTokenNotificationParams({required this.userId, required this.token});
}

class SendMessageParams {
  final String message;
  SendMessageParams(this.message);
}

class SendMessageGeminiParams {
  final String message;
  final List<ByteData>? imageBytes;
  SendMessageGeminiParams(this.message, this.imageBytes);
}

class StartChatParams {
  final String message;
  StartChatParams({required this.message});
}

class StartRolPlayParams {
  final String character;
  final String theme;
  final String languageCode;
  StartRolPlayParams({
    required this.character,
    required this.theme,
    this.languageCode = 'es',
  });
}

class ChatPromptParams {
  final String languageCode;
  ChatPromptParams({this.languageCode = 'es'});
}

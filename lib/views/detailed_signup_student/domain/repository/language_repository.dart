

import '../entities/metadata_entities.dart';

abstract class MasterDataRepository {
  Future<List<LanguageEntity>> getAllLanguages();
}
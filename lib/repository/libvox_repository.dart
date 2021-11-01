// ignore_for_file: overridden_fields

// Project imports:
import 'package:booklit/repository/base_repository.dart';

const _imageRoot = "https://archive.org/services/get-item-image.php?identifier=";
const _latestBooksApi =
    "https://archive.org/advancedsearch.php?$_commonParams&sort[]=addeddate desc&output=json";
const _metadata = "https://archive.org/metadata/";
const _commonParams =
    "q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size";

class LibraVoxRepository extends PlexlitRepository {
  @override
  RepoFeatures features = const RepoFeatures();
  

  @override
  Map toMap() {
    throw UnimplementedError();
  }
}

import '../model/image_item_model.dart';
import 'baseRestAPIService.dart';

class Repositry {
  BaseRestAPIService _service = BaseRestAPIService();

  Future<ImageItemModel> fetchImageList() async {
    final response = await _service
        .get("https://run.mocky.io/v3/c4ab4c1c-9a55-4174-9ed2-cbbe0738eedf");
    ImageItemModel imageItemModel = ImageItemModel.fromJson(response);
    print(response);
    return imageItemModel;
  }
}

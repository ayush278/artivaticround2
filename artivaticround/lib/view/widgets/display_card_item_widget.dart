import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/image_item_model.dart';

class DisplayCardItem extends StatelessWidget {
  final Rows data;
  DisplayCardItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              data.title != null
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        data.title!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              data.description != null
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10, right: 10, left: 12),
                      child: Text(
                        data.description!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                        // dtextAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              data.imageHref != null
                  ? Container(
                      child: Stack(
                        children: [
                          //Image.network(data.imageHref!)
                          CachedNetworkImage(
                            imageUrl: data.imageHref.toString(),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:news_app/ui/widgets/CustomText.dart';

class NewsListWidget extends StatelessWidget {
  final String title, description;

  NewsListWidget({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                text: description,
              )
            ],
          ),
        ),
      ),
    );
  }
}

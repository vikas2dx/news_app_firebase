import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/NewsCubit.dart';
import 'package:news_app/cubits/UICubit.dart';
import 'package:news_app/ui/resources/AppStrings.dart';
import 'package:news_app/ui/widgets/CustomButton.dart';
import 'package:news_app/ui/widgets/CustomTextFormField.dart';
import 'package:news_app/ui/widgets/LoadingWidget.dart';

class AddNewsPage extends StatefulWidget {
  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  NewsCubit newsCubit = NewsCubit();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final verticalGap = const SizedBox(
    height: 15,
  );
  FirebaseFirestore firestore;

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.NEWS,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(AppStrings.NEWS),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              Builder(builder: (scaffoldContext) {
                return Column(
                  children: [
                    CustomTextFormField(
                      hintText: AppStrings.NEWS_TITLE,
                      controller: titleController,
                    ),
                    verticalGap,
                    CustomTextFormField(
                      hintText: AppStrings.NEWS_DESCRIPTION,
                      controller: descriptionController,
                    ),
                    verticalGap,
                    CustomButton(
                      text: AppStrings.NEWS_ADD,
                      pressedCallBack: () {
                        newsCubit.addNewsToDb(titleController.text,
                            descriptionController.text, context);
                      },
                    )
                  ],
                );
              }),
              BlocBuilder<UICubit<bool>, bool>(
                cubit: newsCubit.loaderCubit,
                builder: (context, state) {
                  return state ? LoadingWidget(true) : LoadingWidget(false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

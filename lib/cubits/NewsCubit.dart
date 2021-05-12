import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/CubitState.dart';
import 'package:news_app/model/NewsModel.dart';
import 'package:news_app/utils/FirebaseConstant.dart';

import 'UICubit.dart';

class NewsCubit extends Cubit<CubitState> {
  NewsCubit() : super(InitialState());
  List<NewsModel> newsList = List();
  UICubit<bool> loaderCubit = UICubit<bool>(false);

  Future<void> addNewsToDb(
      String title, String description, BuildContext context) {
    loaderCubit.updateState(true);
    CollectionReference news =
        FirebaseFirestore.instance.collection(FirebaseConstant.NEWS);
    return news
        .add({
          'title': title,
          'description': description,
        })
        .then((value){
          loaderCubit.updateState(false);
          Navigator.pop(context, true);
        })
        .catchError((error) {
          loaderCubit.updateState(false);
    });
  }

  void getNewsListing() {
    newsList.clear();
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection(FirebaseConstant.NEWS)
        .get()
        .catchError((onError) => FailedState(exception: onError))
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["title"]);
        print(doc["description"]);
        newsList.add(NewsModel(doc["title"], doc["description"]));
      });
      print("List ${newsList}");
      if (newsList.length > 0) {
        emit(SuccessState());
      } else {
        emit(FailedState(message: "No data Found"));
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/CubitState.dart';
import 'package:news_app/cubits/NewsCubit.dart';
import 'package:news_app/ui/pages/AddNewsPage.dart';
import 'package:news_app/ui/pages/LoginPage.dart';
import 'package:news_app/ui/resources/AppColor.dart';
import 'package:news_app/ui/widgets/LoadingWidget.dart';
import 'package:news_app/ui/widgets/NewsListWidget.dart';
import 'package:news_app/utils/PreferencesUtils.dart';

class DashboardPage extends StatelessWidget {
  BuildContext context;
  NewsCubit _newsCubit = NewsCubit();

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        PreferencesUtils().removeAll(PreferencesKeys.IS_LOGIN);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ));
        break;
      case 'Support':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    _newsCubit.getNewsListing();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard Page"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: handleClick,
              itemBuilder: (context) {
                return {'Logout', 'Support'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: BlocBuilder<NewsCubit, CubitState>(
            cubit: _newsCubit,
            builder: (context, state) {
              if (state is FailedState) {
                return Text(state.message);
              } else if (state is SuccessState) {
                print("Size_${_newsCubit.newsList.length}");
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _newsCubit.newsList.length,
                  itemBuilder: (context, index) {
                    return NewsListWidget(
                      title: _newsCubit.newsList[index].title,
                      description: _newsCubit.newsList[index].description,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else if (state is LoadingState) {
                return LoadingWidget(true);
              } else {
                return Container();
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

            bool flag = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewsPage(),
                ));
            if (flag!=null ) {
              _newsCubit.getNewsListing();
            }
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: AppColor.themeColor,
        ),
      ),
    );
  }
}

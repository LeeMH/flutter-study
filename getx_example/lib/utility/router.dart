import 'package:get/get.dart';
import 'package:getx_example/view/home_view.dart';
import 'package:getx_example/view/login_view.dart';

class MyRouter {
  static final route = [
    GetPage(
      name: '/loginView',
      page: () => LoginView(),
    ),
    GetPage(
      name: '/homeView',
      page: () => HomeView(),
    ),
  ];
}

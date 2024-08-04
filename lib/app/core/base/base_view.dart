import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseView<Controller extends GetxController>
    extends StatelessWidget {
  const BaseView({super.key});

  Controller get controller => GetInstance().find<Controller>();

  @override
  Widget build(BuildContext context) {
    return GetX<Controller>(builder: (Controller controller) {
      return Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
        body: SafeArea(child: body()),
        floatingActionButton: floatingActionButton(),
      );
    });
  }

  Widget body();

  Widget? floatingActionButton() {
    return null;
  }

  bool resizeToAvoidBottomInset() => true;
}

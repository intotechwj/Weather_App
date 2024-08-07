import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeData.dark(useMaterial3: true));

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? ThemeData.light(useMaterial3: true) : ThemeData.dark(useMaterial3: true));
  }
}

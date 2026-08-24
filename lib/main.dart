import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: initialize dependency injection here later, e.g.:
  // await setupLocator(); // get_it setup (core/di/injection_container.dart)

  runApp(const CoinQuestApp());
}

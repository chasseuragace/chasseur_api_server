import 'package:get_it/get_it.dart';

import 'database/db.dart';

GetIt getIt = GetIt.instance;

AppDatabase get appDb {
  try {
    return GetIt.instance<AppDatabase>();
  } on Exception catch (e) {
    return AppDatabase();
  }
}

Future<void> initLocator() async {
  try {
    getIt.registerSingleton<AppDatabase>(
      AppDatabase(),
    );
    await appDb.initDatabase();
  } catch (e) {
    await appDb.initDatabase();
  }
}

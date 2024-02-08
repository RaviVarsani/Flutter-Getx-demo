import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_skeleton/routes/app_pages.dart';
import 'package:getx_skeleton/utils/local/my_hive.dart';
import 'package:getx_skeleton/utils/local/my_shared_pref.dart';

import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyHive.init(registerAdapters: (hive) {
    hive.registerAdapter(UserModelAdapter());
  });
  await MySharedPref.init();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: "GetXSkeleton",
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            bool themeIsLight = MySharedPref.getThemeIsLight();
            return Theme(
              data: MyTheme.getThemeData(isLight: themeIsLight),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              ),
            );
          },
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          locale: MySharedPref.getCurrentLocal(),
          translations: LocalizationService.getInstance(),
        );
      },
    ),
  );
}

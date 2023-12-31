import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_dapp/home_page.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isDarkMode = false;
  // Uncomment to see how modal theme is changed
  // final _themeData = Web3ModalThemeData(
  //   lightColors: Web3ModalColors.lightMode.copyWith(
  //     accent100: Colors.red,
  //     background125: Colors.yellow.shade300,
  //   ),
  //   darkColors: Web3ModalColors.darkMode.copyWith(
  //     accent100: Colors.green,
  //     background125: Colors.brown,
  //   ),
  //   radiuses: Web3ModalRadiuses.square,
  // );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    W3MLoggerUtil.setLogLevel(W3MLogLevel.error);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        final platformDispatcher = View.of(context).platformDispatcher;
        final platformBrightness = platformDispatcher.platformBrightness;
        _isDarkMode = platformBrightness == Brightness.dark;
      });
    }
    super.didChangePlatformBrightness();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Web3ModalTheme(
      isDarkMode: _isDarkMode,
      // themeData: _themeData, // Uncomment to see how modal theme is changed
      child: MaterialApp(
        // showPerformanceOverlay: true,
        // checkerboardRasterCacheImages: true,
        // checkerboardOffscreenLayers: true,
        // debugShowMaterialGrid: true,
        // showSemanticsDebugger: true,
        // debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: MyHomePage(swapTheme: () => _swapTheme()),
      ),
    );
  }

  void _swapTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

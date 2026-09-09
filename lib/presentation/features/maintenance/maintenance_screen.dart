import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../widgets/independent/independent.dart';

class MaintenanceParameters {
  final String message;

  const MaintenanceParameters({required this.message});
}

class MaintenanceScreen extends StatefulWidget {
  final MaintenanceParameters parameters;

  const MaintenanceScreen({super.key, required this.parameters});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorGreenGradient, colorBlueGradient],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: ScreenSize.height * 0.18),
            Container(
              height: ScreenSize.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: ImageConverter(
                    imagePath: 'assets/image/maintenance.webp',
                    isAssets: true,
                  ).imageProvider!,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                widget.parameters.message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontFamilyMain,
                  color: colorWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

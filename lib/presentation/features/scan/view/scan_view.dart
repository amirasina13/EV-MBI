import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../config/config.dart';
import '../../../helper/helper.dart';
import '../../../widgets/independent/independent.dart';
import '../../history/history.dart';
import '../../settings/settings.dart';
import '../scan.dart';

class ScanView extends StatefulWidget {
  final Function changeView;
  const ScanView({super.key, required this.changeView});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  MobileScannerController? controller;

  bool tapToFocus = true;
  Size desiredCameraResolution = const Size(1920, 1080);
  DetectionSpeed detectionSpeed = DetectionSpeed.unrestricted;
  int detectionTimeoutMs = 1000;

  bool useBarcodeOverlay = true;
  bool useScanWindow = !kIsWeb;
  BoxFit boxFit = BoxFit.contain;

  CameraLensType currentLensType = CameraLensType.normal;

  bool hideMobileScannerWidget = false;

  MobileScannerController initController() => MobileScannerController(
    autoStart: false,
    cameraResolution: desiredCameraResolution,
    detectionSpeed: detectionSpeed,
    detectionTimeoutMs: detectionTimeoutMs,
    lensType: currentLensType,
  );

  @override
  void initState() {
    super.initState();
    controller = initController();
    unawaited(controller!.start());

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller?.dispose();
    controller = null;
  }

  @override
  Widget build(BuildContext context) {
    late final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
      width: 300,
      height: 300,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          MainRoutes.home,
          (Route<dynamic> route) => false,
        );
      },
      child: controller == null || hideMobileScannerWidget
          ? const SizedBox()
          : BlocConsumer<ScanBloc, ScanState>(
              listener: (context, state) {
                if (state is ScanError) {
                  showErrorToast(state.error, context);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.home,
                    (Route<dynamic> route) => false,
                  );
                }

                if (state is ScanSessionError) {
                  showErrorToast(state.error, context);
                  TokenKeystore().deleteToken();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    MainRoutes.account,
                    (Route<dynamic> route) => false,
                    arguments: CheckingParameters(fromPage: 'scan'),
                  );
                }

                if (state is ScanSuccess) {
                  showSuccessToast(state.scanResult['message'], context);

                  // Safely access the nested 'transaction' object
                  final String? terminalId =
                      state.scanResult['data']['transaction']['terminalTranId'];

                  if (terminalId != null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainRoutes.historyDetail,
                      (Route<dynamic> route) => false,
                      arguments: HistoryDetailParameters(
                        id: terminalId, // No more crash!
                      ),
                    );
                  } else {
                    // Handle the case where the ID is missing from the API response
                    debugPrint(
                      "Error: terminalTranId is missing from transaction data",
                    );
                  }
                }
              },
              builder: (context, state) {
                return SafeArea(
                  child: Stack(
                    children: [
                      MobileScanner(
                        scanWindow: scanWindow,
                        tapToFocus: true,
                        controller: controller,
                        onDetect: (capture) async {
                          final List<Barcode> barcodes = capture.barcodes;

                          if (barcodes.isNotEmpty) {
                            final String? displayValue =
                                barcodes.first.displayValue;

                            if (displayValue != null) {
                              //  Stop the camera immediately to prevent multiple scans
                              await controller!.stop();

                              if (!context.mounted) return;
                              BlocProvider.of<ScanBloc>(
                                context,
                              ).add(ScanLoad(scanCode: displayValue));
                            }
                          }
                        },
                      ),
                      // Needed for tapToFocus
                      IgnorePointer(
                        child: ScanWindowOverlay(
                          scanWindow: scanWindow,
                          controller: controller!,
                        ),
                      ),
                      // Instruction text
                      Positioned(
                        bottom: 150,
                        left: 0,
                        right: 0,
                        child: const Center(
                          child: Text(
                            'Align QR code within the box',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ToggleFlashlightButton(controller: controller!),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// Source - https://stackoverflow.com/a/78805550
// Posted by Nipul Rathod
// Retrieved 2026-02-26, License - CC BY-SA 4.0

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    super.key,
    required Null Function(dynamic value) callback,
  });

  @override
  Widget build(BuildContext context) {
    double scanArea =
        (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 220.0
        : 330.0;
    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CustomPaint(
                foregroundPainter: BorderPainter(),
                child: SizedBox(width: scanArea + 25, height: scanArea + 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Creates the white borders
class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const width = 4.0;
    const radius = 20.0;
    const tRadius = 3 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    const clippingRect0 = Rect.fromLTWH(0, 0, tRadius, tRadius);
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// Button widget for toggle torch (flash) function
class ToggleFlashlightButton extends StatelessWidget {
  /// Construct a new [ToggleFlashlightButton] instance.
  const ToggleFlashlightButton({required this.controller, super.key});

  /// Controller which is used to call toggleTorch
  final MobileScannerController controller;

  Future<void> _onPressed() async => controller.toggleTorch();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_auto),
              onPressed: _onPressed,
            );
          case TorchState.off:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_off),
              onPressed: _onPressed,
            );
          case TorchState.on:
            return IconButton(
              color: Colors.white,
              iconSize: 32,
              icon: const Icon(Icons.flash_on),
              onPressed: _onPressed,
            );
          case TorchState.unavailable:
            return const SizedBox.square(
              dimension: 48,
              child: Icon(Icons.no_flash, size: 32, color: Colors.grey),
            );
        }
      },
    );
  }
}

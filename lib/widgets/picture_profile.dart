import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:cripto_qr_googlemarine/utils/ui/ui.dart';
import 'package:flutter/material.dart';

class TakeAPicture extends StatefulWidget {
  const TakeAPicture({Key? key}) : super(key: key);

  @override
  _TakeAPictureState createState() => _TakeAPictureState();
}

class _TakeAPictureState extends State<TakeAPicture> {
  /*late CameraController _cameraController;
  late Future<void> _cameraInitialized;
  XFile? _takenPicture;

  @override
  void initState() {
    super.initState();
    _cameraInitialized = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      return _cameraController.initialize();
    }
  }

  Future<void> _takePicture() async {
    try {
      await _cameraInitialized;

      // Tire a foto
      final XFile picture = await _cameraController.takePicture();

      setState(() {
        _takenPicture = picture;
      });

      print('Foto tirada: ${picture.path}');
    } catch (e) {
      print('Erro ao tirar foto: $e');
    }
  }
*/ //funcionalidade de tirar foto e exibir na tela ----

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: Text(
            CQStrings.mypicture,
            style: CQTheme.h2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
                child: GestureDetector(
                  onTap: () {
                    // o que acontece quando clicar no botão
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CQColors.slate100,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: CQColors.white,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_sharp,
                              color: CQColors.iron100,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'TIRAR FOTO',
                              style: TextStyle(
                                color: CQColors.iron100,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

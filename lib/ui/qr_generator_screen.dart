import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  String? qrRawValue;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2B3DB), // Warna ungu pastel
        title: const Text(
          'Generate QR Code',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/scanerQR');
            },
            icon: const Icon(
              Icons.qr_code_rounded,
              color: Color(0xFFF7F4ED),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F4ED), // Warna krem
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Generate QR Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1957),
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Buat QR Code kamu di sini, silahkan\ncantumkan link kamu sekarang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0B1957),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        qrRawValue = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'your link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (qrRawValue != null && qrRawValue!.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  _showQrCodePopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2B3DB), // Warna ungu pastel
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'Tampilkan QR Code',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showQrCodePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Screenshot(
            controller: screenshotController,
            child: PrettyQrView.data(
              data: qrRawValue!,
              errorCorrectLevel: QrErrorCorrectLevel.M,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async{
                    _shareQrCode();
                    final url = qrRawValue;
                    await Share.share('$url');
                  },
                  icon: const Icon(
                    Icons.share, 
                    color: Color(0xFFD2B3DB), 
                    size: 24
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareQrCode() async {
    final image = await screenshotController.capture();
    if (image != null) {
      await Share.shareXFiles([
        XFile.fromData(
          image,
          name: "qr_code.png",
          mimeType: "image/png",
        ),
      ]);
    }
  }
}

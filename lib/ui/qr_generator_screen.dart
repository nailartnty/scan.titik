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
              Navigator.popAndPushNamed(context, '/generator');
            }, 
            icon: const Icon(
              Icons.qr_code_rounded,
              color: Color(0xFFF7F4ED),
            )
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD2B3DB), width: 4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Screenshot(
                  controller: screenshotController,
                  child: PrettyQrView.data(
                    data: qrRawValue!,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async{
                _shareQrCode();
                final url = qrRawValue;
                await Share.share('$url');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2B3DB), // Warna ungu pastel
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(
                        Icons.share, 
                        color: Colors.white, 
                        size: 15
                      ),
                    ),
                    const TextSpan(text: '   '),
                    TextSpan(
                      text: 'Share gak nih?',
                      style: GoogleFonts.sora(color: Colors.white, fontSize: 15)
                    )
                  ]
                )
              )
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _shareQrCode() async {
    // ambil screenshot dari QR
    final image = await screenshotController.capture();
    if (image != null) {
      // kalau berhasil ambil gambar, share menggunakan Share Plus
      await Share.shareXFiles([
        XFile.fromData(
          image,
          name: "qr_code.png", // nama file screenshot
          mimeType: "image/png", // format file
        ),
      ]);
    }
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2B3DB),
        title: Text(
          'QR Scanner',
          style: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/generator');
            }, 
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Color(0xFFF7F4ED),
            )
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  height: 163,
                  width: 329,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xfff7f4ed)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scan a QR code',
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B1957),
                            fontSize: 20
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Scan a QR code to \n generate a unique link',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF0B1957),
                            fontSize: 15
                          )
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF0B1957), width: 4),
              borderRadius: BorderRadius.circular(23)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                // bawaan dari kamera x
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates, 
                  // noDuplicates -> buat sekali take 
                  // DetectionSpeed -> berapa lama dia nunggu atau mengontrol kecepatan deteksi pemindaian
                  returnImage: true // dia bakal ngembaliin image
                ), 
                onDetect: (capture) {
                  // capture -> object yang berisi hasil pemindaian
                  final List<Barcode> barcodes = capture.barcodes; // kita bakal nyimpan datanya yang di scan di variable yang namanya barcode
                  final Uint8List? image = capture.image; // 8 bit untuk ukuran 
                  for (final barcode in barcodes) {
                    // code -> object yang berisi hasil pemindaian
                    print('Barcode is valid! Here the result : ${barcode.rawValue}'); // rawValue -> data asli dari qr codenya
                  }
                  // pop up notification
                  if (image != null) {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  barcodes.first.rawValue ?? 'no reference found from this QR Code',
                                  style: GoogleFonts.sora(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0B1957),
                                    fontSize: 20
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(), // Garis di bawah teks
                                const SizedBox(height: 16),
                                Image(
                                  image: MemoryImage(image),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Tutup dialog
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}

// kalau IOS -> 
// decode -> akan mengkompres size image
// Image.memory(image)


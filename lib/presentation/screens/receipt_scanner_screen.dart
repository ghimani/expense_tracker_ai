import 'dart:io';

import 'package:expense_tracker_ai/core/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'add_expense_screen.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({
    super.key,
  });

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  File? imageFile;
  bool isLoading = false;

  Map<String, dynamic>? result;
  Future<void> pickImage() async {

    showModalBottomSheet(
      context: context,

      builder: (context) {

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading:
                const Icon(
                  Icons.camera_alt,
                ),

                title:
                const Text(
                  "Camera",
                ),

                onTap: () async {

                  Navigator.pop(context);

                  final image =
                  await ImagePicker()
                      .pickImage(
                    source:
                    ImageSource.camera,
                    imageQuality: 60,
                  );

                  if (image != null) {

                    setState(() {

                      imageFile =
                          File(image.path);
                    });
                  }
                },
              ),

              ListTile(
                leading:
                const Icon(
                  Icons.photo,
                ),

                title:
                const Text(
                  "Gallery",
                ),

                onTap: () async {

                  Navigator.pop(context);

                  final image =
                  await ImagePicker()
                      .pickImage(
                    source:
                    ImageSource.gallery,
                    imageQuality: 60,
                  );

                  if (image != null) {

                    setState(() {

                      imageFile =
                          File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> scanReceipt() async {
    if (imageFile == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await GeminiService().scanReceipt(
        imageFile!,
      );
      print("SCAN RESULT = $data");
      setState(() {
        result = data;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddExpenseScreen(
            expense: {
              "merchantName": data["merchantName"],
              "amount": data["amount"],
              "category": data["category"],
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Receipt Scanner",
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null)
              Image.file(
                imageFile!,
                height: 250,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text(
                "Pick Receipt",
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: isLoading ? null : scanReceipt,
              child: Text(
                isLoading ? "Scanning..." : "Scan Receipt",
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (result != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Merchant : ${result!['merchantName']}",
                    ),
                    Text(
                      "Amount : ${result!['amount']}",
                    ),
                    Text(
                      "Date : ${result!['date']}",
                    ),
                    Text(
                      "Category : ${result!['category']}",
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

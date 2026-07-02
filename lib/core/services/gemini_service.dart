import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {

  late final GenerativeModel model =
  GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? "",
  );
  Future<Map<String, dynamic>>
  scanReceipt(File imageFile) async {
    print("MODEL = gemini-2.5-flash");
    final bytes =
    await imageFile.readAsBytes();

    final prompt = """
Analyze this receipt image.

Extract:
Merchant Name
Amount
Date
Category

Return ONLY valid JSON.
Do not use markdown.
Do not use ```json.

{
 "merchantName":"",
 "amount":"",
 "date":"",
 "category":""
}
""";    print("Calling Gemini API");

    final response =
    await model.generateContent([

      Content.multi([

        TextPart(prompt),

        DataPart(
          'image/jpeg',
          bytes,
        ),
      ])
    ]);

    String text = response.text ?? "{}";

    text = text
        .replaceAll("```json", "")
        .replaceAll("```", "")
        .trim();

    print("Gemini Response = $text");

    final data = jsonDecode(text);

    return {
      "merchantName":
      data["merchantName"]?.toString().isNotEmpty == true
          ? data["merchantName"]
          : "Unknown",

      "amount":
      data["amount"]?.toString().isNotEmpty == true
          ? data["amount"]
          : "0",

      "date":
      data["date"]?.toString().isNotEmpty == true
          ? data["date"]
          : DateTime.now().toString().split(" ")[0],

      "category":
      data["category"]?.toString().isNotEmpty == true
          ? data["category"]
          : "Others",
    };
  }

  Future<String> generateInsights(
      List expenses) async {

    final prompt = """
Analyze these expenses.

$expenses

Generate:

1. Total Spending
2. Category Breakdown
3. Largest Expense
4. Spending Trend
5. One Recommendation

Return simple text.
""";

    final response =
    await model.generateContent([
      Content.text(prompt),
    ]);

    return response.text ??
        "No insights generated";
  }

}
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:classico/constants/api_consts.dart';
import 'package:classico/models/chat_model.dart';
import 'package:classico/models/models_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(Uri.parse("$BASE_URL/models"),
          headers: {"Authorization": "Bearer $API_KEY"});

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      // print("jsonResponse $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log('temp $(value["id"])');
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      // log('error $error');
      rethrow;
    }
  }

  //Send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          "Authorization": "Bearer $API_KEY",
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": "text-davinci-003",
            "prompt": "Hello what is flutter",
            "max-tokens": 100
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }

      // print("jsonResponse $jsonResponse");
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      print('error $error');
      rethrow;
    }
  }
}

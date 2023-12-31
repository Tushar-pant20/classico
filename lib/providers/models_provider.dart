import 'package:classico/models/models_model.dart';
import 'package:classico/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "text-davinci-003";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelList = [];
  List<ModelsModel> get getModelsList {
    return modelList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelList = await ApiService.getModels();
    return modelList;
  }
}

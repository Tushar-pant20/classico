import 'package:classico/models/models_model.dart';
import 'package:classico/providers/models_provider.dart';
import 'package:classico/services/api_services.dart';
import 'package:classico/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';

class dropDownWidget extends StatefulWidget {
  const dropDownWidget({super.key});
  @override
  State<dropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<dropDownWidget> {
  String? CurrentModel;
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    CurrentModel = modelsProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
        future: modelsProvider.getAllModels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextWidget(label: snapshot.error.toString()),
            );
          }
          return snapshot.data == null || snapshot.data!.isEmpty
              ? SizedBox.shrink()
              : FittedBox(
                  child: DropdownButton(
                      dropdownColor: scaffoldBackgroundColor,
                      iconEnabledColor: Colors.white,
                      items: List<DropdownMenuItem<String>>.generate(
                          snapshot.data!.length,
                          (index) => DropdownMenuItem(
                              value: snapshot.data![index].id,
                              child: TextWidget(
                                label: snapshot.data![index].id,
                                fontSize: 15,
                              ))),
                      value: CurrentModel,
                      onChanged: (value) {
                        setState(() {
                          CurrentModel = value.toString();
                        });
                        modelsProvider.setCurrentModel(
                          value.toString(),
                        );
                      }));
        });
  }
}

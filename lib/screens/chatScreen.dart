import 'dart:math';

import 'package:classico/constants/constants.dart';
import 'package:classico/models/chat_model.dart';
import 'package:classico/providers/models_provider.dart';
import 'package:classico/services/api_services.dart';
import 'package:classico/services/assets_manager.dart';
import 'package:classico/services/services.dart';
import 'package:classico/widgets/chat_widgets.dart';
import 'package:classico/widgets/text_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class chatScreen extends StatefulWidget {
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<chatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Text("chatGPT"),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              return ChatWidget(
                msg: chatList[index].msg,
                chatIndex: chatList[index].chatIndex,
              );
            },
          )),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
          ],
          const SizedBox(
            height: 15,
          ),
          Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(modelsProvider: modelsProvider);
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          sendMessageFCT(modelsProvider: modelsProvider);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ))
        ]),
      ),
    );
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList = await ApiService.sendMessage(
        message: textEditingController.text,
        modelId: modelsProvider.getCurrentModel,
      );
      setState(() {});
    } catch (error) {
      print("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}

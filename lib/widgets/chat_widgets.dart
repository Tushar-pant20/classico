import "package:classico/constants/constants.dart";
import "package:classico/services/assets_manager.dart";
import "package:classico/widgets/text_widgets.dart";
import "package:flutter/material.dart";

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
            color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      chatIndex == 0
                          ? AssetsManager.userImage
                          : AssetsManager.botImage,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: TextWidget(
                      label: msg,
                    )),
                    chatIndex == 0
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Colors.white,
                              )
                            ],
                          )
                  ],
                )))
      ],
    );
  }
}

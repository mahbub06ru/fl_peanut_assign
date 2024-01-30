import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.posText,
    required this.negText,
    required this.positiveBtn,
    this.negetiveBtn
  }) : super(key: key);

  final String title, description, posText, negText;
  final Function() positiveBtn;
  final Function()? negetiveBtn;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? Dialog(
            elevation: 0,
            backgroundColor: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(
                  height: 2,
                ),
                Row(
                  children: [
                    Expanded(child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        highlightColor: Colors.grey[200],
                        onTap: () {
                          widget.negetiveBtn!();
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            widget.negText,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    )),
                    Expanded(child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: InkWell(
                        highlightColor: Colors.grey[200],
                        onTap: () {
                          widget.positiveBtn();
                        },
                        child: Center(
                          child: Text(
                            widget.posText,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                )

              ],
            ),
          )
        : CupertinoAlertDialog(
            title: Text(widget.title),
            actions: [
              CupertinoDialogAction(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text(widget.negText)),
              CupertinoDialogAction(onPressed: () {
                widget.positiveBtn();
              }, child: Text(widget.posText)),
            ],
            content: Text(widget.description),
          );
  }
}

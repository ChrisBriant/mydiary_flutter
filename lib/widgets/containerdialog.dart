import 'package:flutter/material.dart';

class ContainerDialog extends StatefulWidget {
  final Text title;
  final Widget content;
  final Function? confirmAction;
  final String? confirmName;
  final String? cancelName;

  const ContainerDialog({
    required this.title,
    required this.content,
    this.confirmAction,
    this.confirmName,
    this.cancelName,
    super.key,
  });

  @override
  State<ContainerDialog> createState() => _ContainerDialogState();
}

class _ContainerDialogState extends State<ContainerDialog> {
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Colors.yellow.shade200,
      title: widget.title,
      content:  widget.content,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        widget.confirmAction != null
          ? ElevatedButton(
            onPressed: () => widget.confirmAction!(), 
            child: Text(widget.confirmName != null ? widget.confirmName! : "Ok")
          )
          : const SizedBox()  
        ,
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text(widget.cancelName != null ? widget.cancelName! : "Cancel")
        ),

      ],
    );
  }
}

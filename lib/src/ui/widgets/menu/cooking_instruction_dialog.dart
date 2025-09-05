import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CookingInstructionDialog extends StatefulWidget {
  final String dishName;
  final TextEditingController controller;
  final void Function(String text) onSave;
  final VoidCallback onCancel;

  const CookingInstructionDialog({
    super.key,
    required this.dishName,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<CookingInstructionDialog> createState() =>
      _CookingInstructionDialogState();
}

class _CookingInstructionDialogState extends State<CookingInstructionDialog> {
  final FocusNode textFieldFocus = FocusNode();
  final FocusNode cancelButtonFocus = FocusNode();
  final FocusNode saveButtonFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(saveButtonFocus);
    });
  }

  @override
  void dispose() {
    textFieldFocus.dispose();
    cancelButtonFocus.dispose();
    saveButtonFocus.dispose();
    super.dispose();
  }

  KeyEventResult _handleButtonKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      FocusScope.of(context).requestFocus(textFieldFocus);
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      if (saveButtonFocus.hasFocus) {
        FocusScope.of(context).unfocus();
        widget.onSave(widget.controller.text);
        return KeyEventResult.handled;
      }
      if (cancelButtonFocus.hasFocus) {
        FocusScope.of(context).unfocus();
        widget.onCancel();
        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (saveButtonFocus.hasFocus || cancelButtonFocus.hasFocus) {
        FocusScope.of(context).unfocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleTextFieldKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        FocusScope.of(context).requestFocus(saveButtonFocus);
        return KeyEventResult.handled;

      case LogicalKeyboardKey.escape:
        FocusScope.of(context).unfocus();
        return KeyEventResult.handled;

      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.select:
        if (saveButtonFocus.hasFocus) {
          FocusScope.of(context).unfocus();
          widget.onSave(widget.controller.text);
          return KeyEventResult.handled;
        }
        if (cancelButtonFocus.hasFocus) {
          FocusScope.of(context).unfocus();
          widget.onCancel();
          return KeyEventResult.handled;
        }
        break;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[850],
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 450,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.dishName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Focus(
                  onKeyEvent: _handleTextFieldKey,
                  child: TextField(
                    focusNode: textFieldFocus,
                    controller: widget.controller,
                    expands: true,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "Add your cooking instruction here",
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: textFieldFocus.hasFocus
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white24,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: Focus(
                      focusNode: cancelButtonFocus,
                      onKeyEvent: _handleButtonKey,
                      child: Builder(builder: (context) {
                        final hasFocus = Focus.of(context).hasFocus;
                        return ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            widget.onCancel();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasFocus ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: hasFocus ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 160,
                    child: Focus(
                      focusNode: saveButtonFocus,
                      onKeyEvent: _handleButtonKey,
                      child: Builder(builder: (context) {
                        final hasFocus = Focus.of(context).hasFocus;
                        return ElevatedButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            widget.onSave(widget.controller.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                hasFocus ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                          child: Text(
                            "Save Instructions",
                            style: TextStyle(
                              color: hasFocus ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

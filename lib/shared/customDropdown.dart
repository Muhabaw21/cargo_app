import 'package:flutter/material.dart';

class CustomDropTextFormField extends StatefulWidget {
  final String hintText;
  final List? dropdownItems;
  final FormFieldValidator validator;
  final TextEditingController textController;
  const CustomDropTextFormField(
      {super.key,
      required this.hintText,
      this.dropdownItems,
      required this.textController,
      required this.validator});

  @override
  State<CustomDropTextFormField> createState() =>
      _CustomDropTextFormFieldState();
}

class _CustomDropTextFormFieldState extends State<CustomDropTextFormField> {
  final TextEditingController _controller = TextEditingController();
  void _handleItemSelected(String value) {
    setState(() {
      var textController;
      textController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: widget.textController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
          suffixIcon: widget.dropdownItems != null
              ? PopupMenuButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (dynamic value) {
                    _handleItemSelected(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return widget.dropdownItems!.map((dynamic value) {
                      return PopupMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList();
                  },
                )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}

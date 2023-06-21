import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

class ExpandableTextField extends StatefulWidget {
  final List<dynamic> datalist;
  final LocalStorage _storage;
  const ExpandableTextField(this.datalist, this._storage, {super.key});

  @override
  ExpandableTextFieldState createState() => ExpandableTextFieldState();
}

class ExpandableTextFieldState extends State<ExpandableTextField> {
  final TextEditingController _textEditingController = TextEditingController();
  double _textFieldHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            // height: ,
            // width: 300, // Set the desired width of the text field
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: _textFieldHeight,
                  maxHeight: 200,
                ),
                child: TextField(
                  onTap: () {
                    if (_textEditingController.text.isEmpty) {
                      Clipboard.getData(Clipboard.kTextPlain).then((value) {
                        _textEditingController.text = value?.text ?? '';
                      });
                    }
                    print(_textEditingController.text);
                  },
                  controller: _textEditingController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  onChanged: (value) {
                    setState(() {
                      // Calculate the height of the text field based on the text content
                      _textFieldHeight = _textEditingController.text.isEmpty
                          ? 50.0
                          : _textEditingController.text.split('\n').length *
                              24.0;
                    });
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter text...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                if (_textEditingController.text.isNotEmpty) {
                  widget.datalist.add(_textEditingController.text);
                  await widget._storage.setItem('datalist', widget.datalist);
                }
                _textEditingController.clear();
              },
              child: const Text("Submit"))
        ],
      ),
    );
  }
}

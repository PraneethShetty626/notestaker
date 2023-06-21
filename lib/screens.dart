import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:notestaker/data_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenElements {
  static AppBar appBar(DataModel dataModel) {
    final Uri url = Uri.parse('https://www.buymeacoffee.com/purposeDevs');
    final TextEditingController _controller = TextEditingController();
    return AppBar(
      backgroundColor: const Color.fromRGBO(39, 55, 77, 1),
      leading: Image.asset('assets/logo.png'),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          width: 200,
          child: TextField(
            controller: _controller,
            cursorColor: Colors.white,
            maxLength: 10,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              labelText: "Add new category",
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 0.5, color: Colors.amberAccent),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        IconButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              dataModel
                  .createNewKey(_controller.text.trim())
                  .then((value) => _controller.clear());
            }
          },
          icon: const Icon(Icons.add_circle_outline_sharp),
        ),
        IconButton(
            onPressed: () async {
              try {
                await launchUrl(url);
              } catch (e) {
                // print(e);
              }
            },
            icon: const Icon(
              Icons.coffee,
              size: 20,
            ))
      ],
    );
  }

  static Widget futureReadyBody(DataModel datamodel) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return streamBody(datamodel);
          // return Text("save");
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to connect to DB"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: datamodel.isReady(),
    );
  }

  static Widget streamBody(DataModel dataModel) {
    return StreamBuilder(
      stream: dataModel.dataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error in Data"),
            );
          } else if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data;
            if (data.isEmpty) {
              dataModel.createNewKey("Default");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            dataModel.setData(data);
            return listBodyView();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static Widget listBodyView() {
    final TextEditingController _controller = TextEditingController();
    return Consumer<DataModel>(
      builder: (context, dataModel, child) => Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemBuilder: (context, index) => Container(
                height: 60,
                constraints: const BoxConstraints(minWidth: 80),
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: dataModel.cindex == index
                        ? const Color.fromRGBO(82, 109, 130, 1)
                        : const Color.fromRGBO(157, 178, 191, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => dataModel.setIndex(index),
                      child: Text(
                        dataModel.data.keys.elementAt(index),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    if (dataModel.data.keys
                            .elementAt(index)
                            .compareTo('Default') !=
                        0)
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: InkWell(
                          child: const Icon(
                            Icons.delete_outline_sharp,
                            size: 15,
                          ),
                          onTap: () {
                            showAlertDialog(context, dataModel,
                                dataModel.data.keys.elementAt(index));
                          },
                        ),
                      ),
                  ],
                ),
              ),
              itemCount: dataModel.data.keys.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Expanded(
            child: listTileBody(
                dataModel, dataModel.data.keys.elementAt(dataModel.cindex)),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(39, 55, 77, 1))),

                  constraints:
                      const BoxConstraints(maxHeight: 250, minHeight: 15),
                  // color: Colors.amber,
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      dataModel
                          .setKeyData(
                              dataModel.data.keys.elementAt(dataModel.cindex),
                              _controller.text.trim())
                          .then((value) => _controller.clear());
                    }
                  },
                  icon: const Icon(Icons.arrow_right_sharp),
                  label: const Text("Save"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color.fromRGBO(39, 55, 77, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget listTileBody(DataModel dataModel, String key) {
    // Text(dataModel.data[key][index])
    int l = dataModel.data[key].length - 1;
    return ListView.builder(
      reverse: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(39, 55, 77, 1)),
              color: const Color.fromARGB(227, 255, 255, 255)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: SelectableText(
                  dataModel.data[key][l - index],
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: dataModel.data[key][l - index],
                      )).then((value) => ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                              duration: Duration(milliseconds: 200),
                              content: Text("Text copied to clipboard"))));
                    },
                    icon: const Icon(Icons.copy_all_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      dataModel.deleteKeyData(key, l - index);
                    },
                    icon: const Icon(Icons.delete_outline_outlined),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: dataModel.data[key].length,
    );
  }

  static showAlertDialog(
      BuildContext context, DataModel dataModel, String key) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromRGBO(39, 55, 77, 1))),
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromRGBO(39, 55, 77, 1))),
      child: const Text("Confirm"),
      onPressed: () {
        dataModel.deleteKey(key).then((value) => Navigator.of(context).pop());
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm delete $key"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

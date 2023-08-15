import 'package:cargo/Components/Home_Page.dart';
import 'package:cargo/shared/customAppbar.dart';
import 'package:cargo/shared/customButton.dart';

import 'package:flutter/material.dart';

class Communicate extends StatefulWidget {
  const Communicate({super.key});

  @override
  State<Communicate> createState() => _CommunicateState();
}

class _CommunicateState extends State<Communicate> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.white,
        title: Container(
          width: double.infinity,
          margin: EdgeInsets.only(right: screenWidth * 0.12),
          height: 40,
          child: const Center(
            child: Text(
              "Communication Page",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: SizedBox(
                  height: screenHeight * 0.125,
                  width: screenWidth - 25.0,
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 6,
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: " write message",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                )),
          ),
          Container(
              margin: EdgeInsets.only(right: screenWidth * 0.55),
              width: screenWidth * 0.5,
              child: CustomButton(
                onPressed: () {},
                text: "Send",
                alignment: Alignment.bottomLeft,
              ))
        ],
      ),
    );
  }
}

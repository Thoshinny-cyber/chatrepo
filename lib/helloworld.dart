
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';
import 'package:firebase_chat_example/page/chats_page.dart';
class HelloWorld extends StatefulWidget {
  const HelloWorld({Key key}) : super(key: key);

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  TextEditingController yourNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Getting the value and object or contract_linking
    var contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Messaging dapp!"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          // child: contractLink.isLoading
          //     ? const CircularProgressIndicator()
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hello ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 52),
                      ),
                      Text(
                        // contractLink.newMessage!,
                        "User",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 52,
                            color: Colors.tealAccent),
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 29),
                  //   child: TextFormField(
                  //     controller: yourNameController,
                  //     decoration: const InputDecoration(
                  //         border: OutlineInputBorder(),
                  //         labelText: "Your receiver id",
                  //         hintText: "What is your receiver id ?",
                  //         icon: Icon(Icons.drive_file_rename_outline)),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 29),
                    child: TextFormField(
                      controller: yourNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Your key",
                          hintText: "What is your address ?",
                          icon: Icon(Icons.drive_file_rename_outline)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 30),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () async {
                        await contractLink.registerUser();
                        yourNameController.clear();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                        child: const Text(
                          'start Messaging',
                          style: TextStyle(fontSize: 30),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatsPage()),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
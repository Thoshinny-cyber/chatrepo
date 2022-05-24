import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://192.168.1.7:7545";
  final String _wsUrl = "ws://192.168.1.7:7545/";
  final String _privateKey ="0f2bbc2a25692f4b4b08324c6bd56214c43f37f5343aa42dd9fd617f663c8e3e";

  Web3Client _client;
  String _abiCode;

  Credentials _credentials;
  EthereumAddress _contractAddress;
  EthereumAddress _ownAddress;

  DeployedContract _contract;
  ContractFunction _registerUser;
  ContractFunction _sendMessage;
  ContractFunction _receiveMessage;
  ContractFunction _checkUser;
  ContractFunction _myInbox;

  bool isLoading = false;
  String newMessage;

  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    final abiStringFile =
        await rootBundle.loadString("build/contracts/Chat.json");
    var jsonFile = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonFile["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonFile["networks"]["5777"]["address"]);
    print(_contractAddress);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Chat"), _contractAddress);
    _registerUser = _contract.function("registerUser");
    _sendMessage = _contract.function("sendMessage");
    _receiveMessage = _contract.function("receiveMessages");
    _checkUser = _contract.function("checkUserRegistration");
    _myInbox = _contract.function("getMyInboxSize");

    //myInbox();
  }

  Future<void> sendMessage(String receiverAddr, String content) async {
    isLoading = false;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _sendMessage,
            parameters: [EthereumAddress.fromHex(receiverAddr), content]));
    receiveMessage();
  }

  Future<void> receiveMessage() async {
    var currentMessage = await _client
        .call(contract: _contract, function: _receiveMessage, params: []);
    // print(currentName);
    newMessage = currentMessage[0];
    isLoading = false;
    notifyListeners();
  }

  Future<void> registerUser() async {
    await _client
        .sendTransaction(
        _credentials,
        Transaction.callContract(contract: _contract,
        function: _registerUser, 
        parameters: []));
  }

}

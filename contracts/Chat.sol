pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;

contract Chat {
  struct Message {
    address sender;
    string content;
    uint timestamp;
  }

  struct ContractProperties {
    address ChatWeiOwner;
    address[] registeredUsersAddress;
  }

  struct Inbox {
    uint numSentMessages;
    uint numReceivedMessages;
    mapping (uint => Message) sentMessages;
    mapping (uint => Message) receivedMessages;
  }

  mapping (address => Inbox) userInboxes;
  mapping (address => bool) hasRegistered;

  Inbox newInbox;
  uint donationsInWei = 0;
  Message newMessage;
  ContractProperties contractProperties;

  function ChatWei() public {
    // Constructor
    registerUser();
    contractProperties.ChatWeiOwner = msg.sender;
  }

  function checkUserRegistration() public view returns (bool) {
    return hasRegistered[msg.sender];
  }

  function clearInbox() public {
    userInboxes[msg.sender] = newInbox;
  }

  function registerUser() public {
    if(!hasRegistered[msg.sender]) {
      userInboxes[msg.sender] = newInbox;
      hasRegistered[msg.sender] = true;
      contractProperties.registeredUsersAddress.push(msg.sender);
    }
  }

  function getContractProperties() public view returns (address, address[] memory) {
    return (contractProperties.ChatWeiOwner, contractProperties.registeredUsersAddress);
  }

  function sendMessage(address _receiver, string memory _content) public {
    newMessage.content = _content;
    newMessage.timestamp = now;
    newMessage.sender = msg.sender;
    // Update senders inbox
    Inbox storage sendersInbox = userInboxes[msg.sender];
    sendersInbox.sentMessages[sendersInbox.numSentMessages] = newMessage;
    sendersInbox.numSentMessages++;

    // Update receivers inbox
    Inbox storage receiversInbox = userInboxes[_receiver];
    receiversInbox.receivedMessages[receiversInbox.numReceivedMessages] = newMessage;
    receiversInbox.numReceivedMessages++;
  }

  function receiveMessages() public view returns (string[] memory, uint[] memory, address[] memory) {
    Inbox storage receiversInbox = userInboxes[msg.sender];
    string[] memory content=new string[](16);
    address[] memory sender = new address[](16);
    uint[] memory timestamp = new uint[](16);
    for (uint m = 0; m < 15; m++) {
      Message memory message = receiversInbox.receivedMessages[m];
      content[m]= message.content;
      sender[m] = message.sender;
      timestamp[m] = message.timestamp;
    }
    return (content, timestamp, sender);
  }

  function getMyInboxSize() public view returns (uint, uint) {
    return (userInboxes[msg.sender].numSentMessages, userInboxes[msg.sender].numReceivedMessages);
  }

}
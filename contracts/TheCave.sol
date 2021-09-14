// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TheCave {

  // max supply, how much?
  uint public MAX_SUPPLY = 1;
  uint public MESSAGES_COUNT = 0;
  mapping(uint => RockMessage) public messages;

  struct RockMessage {
    string message;
    string positionInCave;
    uint date;
    address owner;
  }

  event RockMessageRecorded {
    string message;
    string positionInCave;
  }


  function record_message(string _message, string _positionInCave) external {
    // len of message? 50 or 70 ?
    require(MESSAGES_COUNT < MAX_SUPPLY);

    require(bytes(_message).length > 0 && bytes(_message).length < 70);
    require(bytes(_positionInCave).length > 0);

    MESSAGES_COUNT++;

    messages[MESSAGES_COUNT] = RockMessage(_message, _positionInCave, now, msg.sender);

    emit RockMessageRecorded(_message, _positionInCave);
  }

}

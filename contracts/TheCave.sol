// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./Base64.sol";

contract TheCave is Ownable, ERC721Enumerable, ReentrancyGuard {

  using Counters for Counters.Counter;

  Counters.Counter private _tokenIds;
  uint256 public MAX_SUPPLY = 100;
  uint256 public constant PRICE = 0.003 ether;
  mapping(uint256 => RockMessage) private _rockMessages;

  // Name and symbol
  constructor() ERC721("The Cave", "CAVE") Ownable() {}

  struct RockMessage {
    string message;
    string positionInCave;
    uint256 date;
    address owner;
  }

  event RockMessageRecorded (
    string message,
    string positionInCave
  );

  function withdraw() external onlyOwner nonReentrant {
    uint256 balance = address(this).balance;
    require(balance > 0, "Balance should be positive!");
    payable(owner()).transfer(balance);
  }

  // show in interface total available
  function currentSupply() public view returns (uint256) {
    return _tokenIds.current();
  }

  function recordMessage(string memory _message, string memory _positionInCave) external payable nonReentrant {
    require(msg.value == PRICE, "Eth sended insufficient.");

    require(currentSupply()+1 <= MAX_SUPPLY, "Max supply reached.");

    require(bytes(_message).length > 0 && bytes(_message).length < 70, "Message size is wrong");
    require(bytes(_positionInCave).length > 0, "Position in cave is not valid.");

    uint256 newTokenId = currentSupply();

    _rockMessages[newTokenId] = RockMessage(_message, _positionInCave, block.timestamp, _msgSender());

    _safeMint(_msgSender(), newTokenId);

    _tokenIds.increment();

    emit RockMessageRecorded(_message, _positionInCave);
  }

  function getRockMessages() external view returns (RockMessage[] memory) {
    RockMessage[] memory rockMessages = new RockMessage[](currentSupply());

    for(uint256 i = 0; i < currentSupply(); i++) {
      RockMessage memory rockMessage = _rockMessages[i];
      rockMessages[i] = rockMessage;
    }

    return rockMessages;
  }

  function tokensOfOwner(address owner) external view returns (uint256[] memory){
    uint256 tokenCount = balanceOf(owner);
    uint256[] memory tokens = new uint256[](tokenCount);

    for(uint256 i = 0; i < tokenCount; i++) {
      tokens[i] = tokenOfOwnerByIndex(owner, i);
    }

    return tokens;
  }

  /*
  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    RockMessage memory rockMessage = _rockMessages[tokenId];

    // generate the NFT
  }
  */

}

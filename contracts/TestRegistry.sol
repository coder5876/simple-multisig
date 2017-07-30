pragma solidity ^0.4.8;

// This contract is only used for testing purposes.
contract TestRegistry {

  mapping(address => uint) public registry;

  function register(uint x) payable {
    registry[msg.sender] = x;
  }

}

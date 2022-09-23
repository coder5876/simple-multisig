// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// This contract is only used for testing purposes.
contract TestRegistry {

  mapping(address => uint) public registry;

  function register(uint x) payable public {
    registry[msg.sender] = x;
  }

}

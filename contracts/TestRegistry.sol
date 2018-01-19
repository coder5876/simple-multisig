pragma solidity 0.4.18;


// This contract is only used for testing purposes.
contract TestRegistry {
    mapping(address => uint) public registry;

    function register(uint x) public payable {
        registry[msg.sender] = x;
    }
}

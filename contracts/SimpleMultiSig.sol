pragma solidity ^0.4.22;

contract SimpleMultiSig {

  uint[] public nonces;              // mutable state
  uint public next_nonce;            // mutable state
  uint public threshold;             // immutable state
  mapping (address => bool) isOwner; // immutable state
  address[] public ownersArr;        // immutable state
  address admin;                     // immutable state

  // Note that owners_ must be strictly increasing, in order to prevent duplicates
  constructor(uint threshold_, address[] owners_, uint nonce_window_size) public {
    require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ >= 0 && nonce_window_size > 0);
    admin = msg.sender;
    next_nonce = 0;

    address lastAdd = address(0); 
    for (uint i = 0; i < owners_.length; i++) {
      require(owners_[i] > lastAdd);
      isOwner[owners_[i]] = true;
      lastAdd = owners_[i];
    }
    ownersArr = owners_;
    threshold = threshold_;
    nonces.length = nonce_window_size;
    for (uint j = 0; j < nonces.length; j++) {
        nonces[j] = next_nonce++;
    }
  }

  // Return the first available nonce.
  // If you want to perform concurrent requests, access the nonces array directly.
  function nonce() view public returns (uint) {
    return nonces[0];
  }

  // Use up the nonce at the specified index, aborting any in-flight transactionwith that nonce
  function cancel_nonce(uint nonce_index) public {
    require(msg.sender == admin && nonce_index < nonces.length);

    nonces[nonce_index] = next_nonce++;
  }

  // Execute with first nonce.
  // If you want to perform concurrent requests, use execute_with_nonce_index.
  function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) public {
      execute_with_nonce_index(sigV, sigR, sigS, destination, value, data, 0);
  }

  // Note that address recovered from signatures must be strictly increasing, in order to prevent duplicates
  function execute_with_nonce_index(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data, uint nonce_index) public {
    require(sigR.length == threshold);
    require(sigR.length == sigS.length && sigR.length == sigV.length);
    require(nonce_index < nonces.length);

    // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
    bytes32 txHash = keccak256(byte(0x19), byte(0), this, destination, value, data, nonces[nonce_index]);

    address lastAdd = address(0); // cannot have address(0) as an owner
    for (uint i = 0; i < threshold; i++) {
      address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
      require(recovered > lastAdd && isOwner[recovered]);
      lastAdd = recovered;
    }

    // If we make it here all signatures are accounted for.
    // The address.call() syntax is no longer recommended, see:
    // https://github.com/ethereum/solidity/issues/2884
    nonces[nonce_index] = next_nonce++;
    bool success = false;
    assembly { success := call(gas, destination, value, add(data, 0x20), mload(data), 0, 0) }
    require(success);
  }

  function () payable public {}
}

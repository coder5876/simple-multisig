pragma solidity 0.4.11;
contract SimpleMultiSig {

  uint public nonce; // mutable state
  uint public threshold; // immutable state
  address[] public owners; // immutable state

  function SimpleMultiSig(uint threshold_, address[] owners_) {
    if (owners_.length > 10 || threshold_ > owners_.length || threshold_ == 0) {throw;}

    for (uint i=0; i<owners_.length; i++) {
      if(owners_[i] == 0) {throw;} // disallow zero address
    }

    threshold = threshold_;
    owners = owners_;
    nonce = 0;
  }
  
  // Note that signature vectors need to be in same order as owners vector
  // Example: Signatures by owners 0, 2, 3 ok, but 2, 0, 3 will throw.
  function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) {
    if (sigR.length != threshold) {throw;}
    if (sigR.length != sigS.length || sigR.length != sigV.length) {throw;}

    // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
    bytes32 txHash = sha3(byte(0x19), byte(0), this, destination, value, data, nonce);

    uint i=0; uint j=0;
    while (i<threshold) {
      address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
      while (j<owners.length) {
        if (recovered == owners[j]) {i++; j++; break;}
        else {j++;}
      }
      if (j == owners.length && i < threshold) {throw;}
    }

    // If we make it here all signatures are accounted for
    nonce = nonce + 1;
    if (!destination.call.value(value)(data)) {throw;}
  }

  function () payable {}
}

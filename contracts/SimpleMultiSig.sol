pragma solidity 0.4.11;
contract SimpleMultiSig {

  uint public nonce;                // (only) mutable state
  uint public threshold;            // immutable state
  mapping (address => bool) isOwner; // immutable state
  address[] public ownersArr;        // immutable state

  function SimpleMultiSig(uint threshold_, address[] owners_) {
    require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ != 0);

    for (uint i=0; i<owners_.length; i++) {
      isOwner[owners_[i]] = true;
    }
    ownersArr = owners_;
    threshold = threshold_;
  }

  // Note that address recovered from signatures must be strictly increasing
  function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) {
    require(sigR.length == threshold);
    require(sigR.length == sigS.length && sigR.length == sigV.length);

    // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
    bytes32 txHash = sha3(byte(0x19), byte(0), this, destination, value, data, nonce);

    address lastAdd = address(0); // cannot have address(0) as an owner
    for (uint i = 0; i < threshold; i++) {
        address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
        require(recovered > lastAdd && isOwner[recovered]);
        lastAdd = recovered;
    }

    // If we make it here all signatures are accounted for
    nonce = nonce + 1;
    require(destination.call.value(value)(data));
  }

  function () payable {}
}

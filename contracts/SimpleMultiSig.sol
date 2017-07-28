pragma solidity 0.4.11;
contract SimpleMultiSig {

    uint public nonce; // long-term mutable state
    mapping(address => uint) hasSigned; //temp mutable state
    uint public threshold; // immutable state
    address[] public owners; // immutable state
    mapping(address => bool) public isOwner; // immutable state

    function SimpleMultiSig(uint threshold_, address[] owners_) {
        if (owners_.length > 10) {throw;}

        for (uint i=0; i<owners_.length; i++) {
            if(owners_[i] == 0) {throw;} // disallow zero address
            if(isOwner[owners_[i]]) {throw;} // disallow duplicates
            isOwner[owners_[i]] = true;
        }

        threshold = threshold_;
        owners = owners_;
        nonce = 0;
    }
    
    function sendTransaction(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes32 data) {
        if (sigR.length != threshold) {throw;}
        if (sigR.length != sigS.length || sigR.length != sigV.length) {throw;}

        bytes32 txHash = sha3(this, bytes32(nonce), bytes32(destination), bytes32(value), data);

        for (uint i=0; i<threshold; i++) {
            address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
            if (!isOwner[recovered]) {throw;} // Signer is not owner or sig invalid
            if (hasSigned[recovered] != 0) {throw;} // Duplicate sig
            hasSigned[recovered] = 1;
        }

        for (i=0; i<owners.length; i++) {
            hasSigned[owners[i]] = 0; // zero out temp storage
        }

        // If we make it here all signatures are good
        nonce = nonce + 1;
        if (!destination.call.value(value)(data)) {throw;}
    }
    
    function () payable {}
}

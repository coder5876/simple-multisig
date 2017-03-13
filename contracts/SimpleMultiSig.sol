pragma solidity ^0.4.0;
contract SimpleMultiSig {

    // Mutable state
    uint public nonce;
    
    // Constant state
    uint public threshold;
    address[] public signers;

    function SimpleMultiSig(uint threshold_, address[] signers_) {
        // No more than 20 signers
        if (signers_.length > 20) {throw;}
        threshold = threshold_;
        signers = signers_;
        nonce = 0;
    }
    
    function sendTransaction(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, uint nonce_, address destination, uint value, bytes32 data) {

        if (sigR.length != threshold) {throw;}
        if (sigR.length != sigS.length || sigR.length != sigV.length) {throw;}
        if (nonce_ != nonce) {throw;}

        mapping(address => uint) signatures;
        bytes32 txHash = sha3(bytes32(nonce), bytes32(destination), bytes32(value), data);
        uint i=0;

        for (i=0; i<threshold; i++) {
            address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
            signatures[recovered] = 1;
        }
        
        uint sumOfSigners = 0;        
        for (i=0; i<threshold; i++) {
            sumOfSigners = sumOfSigners + signatures[signers[i]];
        }
        
        if (sumOfSigners == threshold) {
            nonce = nonce + 1;
            if (!destination.call.value(value)(data)) {
                throw;
            }
        }
    }
    
    function () payable {}
}

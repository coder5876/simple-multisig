//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

contract SimpleMultiSig {

// EIP712 Precomputed hashes:
// keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)")
bytes32 constant EIP712DOMAINTYPE_HASH = 0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472;

// keccak256("Simple MultiSig")
bytes32 constant NAME_HASH = 0xb7a0bfa1b79f2443f4d73ebb9259cddbcd510b18be6fc4da7d1aa7b1786e73e6;

// keccak256("1")
bytes32 constant VERSION_HASH = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;

// keccak256("MultiSigTransaction(address destination,uint256 value,bytes data,uint256 nonce,address executor,uint256 gasLimit)")
bytes32 constant TXTYPE_HASH = 0x3ee892349ae4bbe61dce18f95115b5dc02daf49204cc602458cd4c1f540d56d7;

bytes32 constant SALT = 0x251543af6a222378665a76fe38dbceae4871a070b7fdaf5c6c30cf758dc33cc0;

  uint public nonce;                 // (only) mutable state
  uint public threshold;             // immutable state
  mapping (address => bool) isOwner; // immutable state
  address[] public ownersArr;        // immutable state

  bytes32 public DOMAIN_SEPARATOR;          // hash for EIP712, computed from contract address
  
  // Note that owners_ must be strictly increasing, in order to prevent duplicates
  constructor(uint threshold_, address[] memory owners_, uint chainId) {
    require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ > 0);

    address lastAdd = address(0);
    for (uint i = 0; i < owners_.length; i++) {
      require(owners_[i] > lastAdd);
      isOwner[owners_[i]] = true;
      lastAdd = owners_[i];
    }
    ownersArr = owners_;
    threshold = threshold_;

    DOMAIN_SEPARATOR = keccak256(abi.encode(EIP712DOMAINTYPE_HASH,
                                            NAME_HASH,
                                            VERSION_HASH,
                                            chainId,
                                            this,
                                            SALT));
  }


    // Note that address recovered from signatures must be strictly increasing, in order to prevent duplicates
  function execute(
  bytes [] memory sig, 
  address destination,
  uint value, 
  bytes memory data, 
  address executor, 
  uint gasLimit)
   public {
    require(sig.length == threshold, "execute: sigR.length == threshold ");
    require(executor == msg.sender || executor == address(0), "execute: executor == msg.sender || executor == address(0)");
    require(recoverMulti(sig, destination, value, data, executor, gasLimit) == true,"execute: recoverMulti == false" );
  
    nonce = nonce + 1;
    bool success = false;
    assembly { success := call(gasLimit, destination, value, add(data, 0x20), mload(data), 0, 0) }
    require(success,"execute: success ");
  }

function recoverMulti( 
bytes [] memory sig, 
address destination, 
uint value, 
bytes memory data,
address executor, 
uint gasLimit)
internal view
 returns (bool )
 {

    // EIP712 scheme: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
    bytes32 txInputHash = keccak256(abi.encode(TXTYPE_HASH, destination, value, keccak256(data), nonce, executor, gasLimit));
    bytes32 totalHash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, txInputHash));
    bytes32 message = prefixed(totalHash);
    
    address lastAdd = address(0); // cannot have address(0) as an owner

    for (uint i = 0; i < threshold; i++) {
      (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig[i]);
      address recovered = ecrecover(message, v, r, s);
      require(recovered > lastAdd,"execute: recovered > lastAdd ");
      require(isOwner[recovered],"execute: isOwner[recovered]");
      lastAdd = recovered;
    }
    
    return true;
  }

 /// signature methods.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

     /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) 
    internal 
    pure 
    returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }


  receive () payable external {}
}
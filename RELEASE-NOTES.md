# Release Notes #

## Version 2.0.1 - 2019-06-19

* Fix misspellings in contract comments. By [ethers](https://github.com/ethers).

* Update browser test with check for web3 object.

* Fix faulty documentation of private key in MetaMask browser test.

## Version 2.0.0 - 2018-08-18 ##

* Backwards incompatible update of main contract to support [EIP712](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md).

* Add `executor` to the signed data in order to specify which address needs to call the `execute` function. Allows `address(0)` as valid executor if the signers want anyone to be able to execute the transaction.

* Add `gasLimit` to the signed data in order to specify how much gas to supply to the function call.

* Add input parameter `chainId` to the constructor.

* Change fallback function from `public` to `external`.

* Update tests for EIP712.

* Add test for wrong nonce.

* Update Solidity compiler version to 0.4.24.

* Remove use of `bignumber.js` and replace with `web3.toBigNumber()` (Thanks to [barakman](https://github.com/barakman)).

## Version 1.0.4 - 2018-06-12 ##

* Document owners_ address being strictly increasing, by [ripper234](https://github.com/ripper234)

* Update to new constructor syntax, by [ripper234](https://github.com/ripper234)

* Check that threshold is positive instead of non-zero, by [ripper234](https://github.com/ripper234)

* Update .gitignore, by [ripper234](https://github.com/ripper234)

## Version 1.0.3 - 2018-06-11 ##

* Moved the assembly to inside the `execute()` function and removed the `executeCall()` function. This is to avoid the possibility of the `internal` keyword on the `executeCall()` function being accidentally removed which would have catastrophic consequences.

## Version 1.0.2 - 2018-05-04 ##

* Updated to use assembly instead of `address.call()` syntax. Thanks to [ethers](https://github.com/ethers) for the suggestion. For more info about the problems with `address.call()` see [here](https://github.com/ethereum/solidity/issues/2884).

* Fix indentation mismatch.

## Version 1.0.1 - 2018-05-04 ##

* Update to work with latest Solidity and Truffle version. By [grempe](https://github.com/grempe)

* Add RELEASE-NOTES

## Version 1.0.0 - 2017-03 to 2017-11 ##

* Initial implementation

* Tweaks by [naterush](https://github.com/naterush)

* Informal review and fixes by [maurelian](https://github.com/maurelian)

* Replace `sha3` with `keccak256` by [ethers](https://github.com/ethers)

* Add MIT license

# Release Notes #

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

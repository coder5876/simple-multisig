# simple-multisig
Simple multisig for Ethereum using detached signatures

This is an Ethereum multisig contract designed to be as simple as possible. It is described further in this [medium post](https://medium.com/@ChrisLundkvist/exploring-simpler-ethereum-multisig-contracts-b71020c19037).

The main idea behind the contract is to pass in a threshold of detached signatures into the `execute` function and the contract will check the signatures and send off the transaction.

For a review by maurelian, see the file `maurelian_review.md`.

To run the tests:

* Make sure `testrpc` is running.
* `npm install`
* `npm run test`


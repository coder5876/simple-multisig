# Smart contract review by maurelian

## Introduction by christianlundkvist

This is an informal review of the `SimpleMultisig` smart contract by [maurelian](https://github.com/maurelian). All the issues raised were also fixed by maurelian in subsequent PRs.

The original review is also available [here](https://gist.github.com/maurelian/f6b842854edec7d02a1f46be1f6e2a67). Some minor stylistic alterations were made.

## Introduction

This is an informal... you might even say adhoc review of the `SimpleMultisig` contract, found here: <https://github.com/christianlundkvist/simple-multisig/tree/9d486cb280c1b0108a64a0e1c4bc0c636919c2d7>

This review makes no legally binding guarantees whatsoever. Use at your own risk. 


## Summary

The two findings listed under `Major` and `Medium` should be fixed. The `Minor` and `Note` issues don't pose a security risk, but should be fixed to adhere to best practices. 

Otherwise, no significant issues were identified. This contract appears to work as advertised, and its simplicity is excellent for the task.


## Specific findings

### Major: contract can be "bricked" on deployment if same address is used twice

The contract could be deployed, and instantly unusable. This would occur if the same address is added twice, and the threshold requires all owners to sign in order to execute. The constructor should be modified to prevent this using a similar approach to the `execute` function.

### Medium: Upgrade to solidity ^0.4.14 

Prior to 0.4.14, a bug existed in `ecrecover`. 

Ref: <https://github.com/ConsenSys/0x_review/blob/final/report/3_general_findings.md#ecrecover-issue-in-solidity-0414>


### Minor: use `require` instead of `throw`

It's easier to read, and `throw` is being deprecated.

### Minor: Indentation of test suite

The utility functions were not properly indented from line 118 to 148 of `multisig.js`.

### Note: Clarify the value of the requirement that signatures be submitted in ascending order

I belive the purpose is to facilitate checking against duplicate signatures, but it would be nice to make that explicit. 
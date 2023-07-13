# bridge contracts

## Build Guide

To compile this Aleo program, run:

```bash
leo build
```

## Details

The aleo contracts has two parts:

1. The signature [`izar-sign`](https://github.com/izar-bridge/aleo-contracts/blob/master/imports/izar_sign.leo)

   The signature scheme we use is an equivalent implementation copied from [snarkvm](https://github.com/AleoHQ/snarkVM/blob/testnet3/console/account/src/signature/sign.rs)

   We have replaced some of the implementation details in the original scheme, such as `g_scalar_multiply` => `group::GEN`.

   We will improve the implementation of this signature algorithm once the Leo language is more mature and also implement a better way to verify validators like **MPC** or **zkSnark** in the future.

2. The Bridge and Izar-token [`izar_v2`](https://github.com/izar-bridge/aleo-contracts/blob/master/src/main.leo)

   In the current version of the Leo language, the issue of trust propagation between multiple contracts cannot be resolved, and contract-to-contract calls cannot be implemented. Therefore, the protocol layer of the bridge must currently be written together with the contract that maps the tokens.

   The main functions of the bridge and token are currently `cross` and `receive`, respectively, as well as the logic for verifying signatures within them.

   Listening to the `cross` transition is responsible for crossing from **Aleo** to the target chain.

   The `receive` operation is responsible for crossing from the target chain to **Aleo**.

   Currently, we use a method similar to **EIP-1155** to support multiple types of tokens, and in the future, we will implement independent contracts for each mapped token.

3. old contract [`izar_v1`](https://github.com/izar-bridge/aleo-contracts/blob/master/imports/izar_v1.leo)

## Contract Info

[aleo-explore](https://explorer.hamp.app/program?id=izar_bridge_v2_1.aleo)

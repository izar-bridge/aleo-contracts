# Welcome to IZAR Bridge

![w6z473.png](https://files.catbox.moe/w6z473.png)

## The Future of Cross-Chain Privacy

IZAR is a groundbreaking privacy-preserving interoperability protocol that seamlessly connects the Ethereum and Aleo ecosystems. We offer unparalleled support for heterogeneous chain arbitrary message cross-chain communication. Utilizing advanced zero-knowledge cryptography, IZAR ensures fully private cross-chain transactions while maintaining robust user privacy and security. Additionally, the protocol is designed to incorporate a novel governance model and zkSnark multisig verification to further enhance its capabilities and user trust.

IZAR can bring significant value to the Aleo ecosystem by providing a cross-chain bridge to Ethereum. This connection would facilitate collaboration, exchange of information and value, and boost growth and liquidity for Aleo. By tapping into Ethereum's extensive resources, IZAR would attract more developers, projects, and users to enhance the Aleo network's integration and adoption. Additionally, IZAR's integration would introduce unique privacy features to the broader blockchain community, further increasing Aleo's appeal and positioning it as a leading privacy-focused blockchain solution.

**Our website:** [https://izar.xyz/](https://izar.xyz/)

## Details

![arch.png](https://1949658826-files.gitbook.io/~/files/v0/b/gitbook-x-prod.appspot.com/o/spaces%2FnxA9NmdC2OhVMmg1iXEx%2Fuploads%2F7dpMPFcYAQYrZxoe6dqI%2FFrame%203.png?alt=media&token=5d0cde9e-001e-44ee-b442-a0f244a2e1cf)

The Aleo contracts consist of two main parts:

1. The signature scheme called `izar-sign`, which is used to verify signatures within the contracts. This scheme is based on an implementation from the [`snarkvm`](https://github.com/AleoHQ/snarkVM/blob/testnet3/console/account/src/signature/sign.rs) library, with some modifications made to the original scheme. For example, `g_scalar_multiply` has been replaced with `group::GEN`. The current implementation of `izar-sign` is not optimal and will be improved in the future once the Leo language is more mature. Additionally, better ways to verify validators like MPC or zkSnark will be implemented.
2. The Bridge and Izar-token contracts, which are responsible for mapping tokens between Aleo and other chains. Due to limitations in the current version of the Leo language, the bridge and token contracts must be written together. The main functions of the bridge and token are `cross` and `receive`, respectively, which handle the movement of tokens between Aleo and the target chain. Currently, the contracts use a method similar to EIP-1155 to support multiple types of tokens, but in the future, independent contracts will be implemented for each mapped token.
3. Old contract [`izar_v1`](https://github.com/izar-bridge/aleo-contracts/blob/master/imports/izar_v1.leo)

## Build Guide

To compile this Aleo program, run:

```bash
leo build
```

## Contract Info

[aleo-explore](https://explorer.hamp.app/program?id=izar_bridge_v2_1.aleo)

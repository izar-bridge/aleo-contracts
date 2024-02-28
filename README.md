# Welcome to IZAR Bridge

![b2qhya.png](https://files.catbox.moe/b2qhya.png)

## The Future of Cross-Chain Privacy

IZAR is a groundbreaking privacy-preserving interoperability protocol that seamlessly connects the Ethereum and Aleo ecosystems. We offer unparalleled support for heterogeneous chain arbitrary message cross-chain communication. Utilizing advanced zero-knowledge cryptography, IZAR ensures fully private cross-chain transactions while maintaining robust user privacy and security. Additionally, the protocol is designed to incorporate a novel governance model and zkSnark multisig verification to further enhance its capabilities and user trust.

IZAR can bring significant value to the Aleo ecosystem by providing a cross-chain bridge to Ethereum. This connection would facilitate collaboration, exchange of information and value, and boost growth and liquidity for Aleo. By tapping into Ethereum's extensive resources, IZAR would attract more developers, projects, and users to enhance the Aleo network's integration and adoption. Additionally, IZAR's integration would introduce unique privacy features to the broader blockchain community, further increasing Aleo's appeal and positioning it as a leading privacy-focused blockchain solution.

**Our website:** [https://izar.xyz/](https://izar.xyz/)

## Details

![6g7ihs.png](https://files.catbox.moe/6g7ihs.png)

The Izar Aleo contract consist of there parts:

1. [*izar-protocol*](https://github.com/izar-bridge/aleo-contracts/tree/master/imports/izar_protocol_v1.leo) is the cross-chain protocol of Izar, containing implemented verification signatures as well as governance-related logic.
2. [*izar-token*](https://github.com/izar-bridge/aleo-contracts/tree/master/imports/izar_token.leo) is izar's mapped token, mainly mapping the corresponding tokens on different chains, with logic referring to **erc1155**.
3. [*izar-token-proxy*](https://github.com/izar-bridge/aleo-contracts/tree/master/src/main.leo) is the proxy contract for **izar-token**, mainly controlling permissions and binding cross-chain logic.

## Build Guide

To compile this Aleo program, run:

```bash
leo build
```


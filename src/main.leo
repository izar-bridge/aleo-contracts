import izar_protocol_v1.aleo;
import izar_token.aleo;

// The 'izar_protocol_v3' program.
program izar_token_proxy_v1.aleo {
    // redefine
    struct Account {
        holder: address,
        token_id: field,
    }

    struct IzarTokenMeta {
        from_chain_id: u32,
        from_asset_addr: field,
    }

    struct Nonce {
        chain_id: u32,
        nonce: u128,
    }

    struct IzarRecvMsg {
        protocol_addr: address, // avoid replay attack when updated this contract
        nonce: u128,
        to_addr: address,
        from_chain_id: u32,
        from_asset_addr: field, // (from_chain_id, from_asset_addr) construct a unique asset
        token_id: field,
        amount: u128,
    }

    struct IzarCrossMsg {
        to_chain_id: u32,
        to_addr: field,
        to_asset_addr: field,
        token_id: field,
        amount: u128,
        fee: u128,
    }

    inline proxy_owner () -> address  {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    transition receive_payload (signatures: [signature; 20], keepers: [address; 20], payload: IzarRecvMsg) {
        // verify token when token is 1155 type
        izar_token.aleo/verify_token(payload.token_id, payload.from_chain_id, payload.from_asset_addr);
        // verify signatures
        izar_protocol_v1.aleo/verify(signatures, keepers, payload);
        // mint token
        izar_token.aleo/mint_public(payload.to_addr, payload.amount, payload.token_id);
    }

    transition cross_public(public payload: IzarCrossMsg) {
        // verify token when token is 1155 type
        izar_token.aleo/verify_token(payload.token_id, payload.to_chain_id, payload.to_asset_addr);
        // burn token if balance is not enough, it will panic
        izar_token.aleo/burn_public(self.caller, payload.amount, payload.token_id);
        // tranfer fee to fee account
        izar_token.aleo/mint_public(proxy_owner(), payload.fee, payload.token_id);
    }

    transition upgrade (public new_contract: address) {
        assert_eq(self.caller, proxy_owner());
        izar_token.aleo/transfer_ownership(new_contract);
    }

    transition proxy_regist_token (metadata: IzarTokenMeta) {
        assert_eq(self.caller, proxy_owner());
        izar_token.aleo/regist_token(metadata);
    }
}

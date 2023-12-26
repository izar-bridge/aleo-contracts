import izar_protocol_v1.leo;
import izar_token.leo;

// The 'izar_protocol_v3' program.
program izar_token_proxy_v1.aleo {
    inline proxy_owner () -> address  {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline proxy_address () -> address {
        return aleo1wtafw0cw4ckqczq2mvhc8zp9p845ptjkydzz8wtm4fp5haurjg9s8y92qe;
    }

    transition receive_payload (signatures: [signature; 20], keepers: [address; 20], payload: IzarRecvMsg) {
        // verify token when token is 1155 type
        izar_token.leo/verify_token(payload.token_id, payload.from_chain_id, payload.from_asset_addr);
        // verify signatures
        izar_protocol_v1.leo/verify(signatures, keepers, payload);
        // mint token
        izar_token.leo/mint_public(payload.to_addr, payload.amount, payload.token_id);
    }

    transition cross_public(public payload: IzarCrossMsg) {
        // verify token when token is 1155 type
        izar_token.leo/verify_token(payload.token_id, payload.to_chain_id, payload.to_asset_addr);
        // burn token
        izar_token.leo/burn_public(self.caller, payload.amount, payload.token_id);
        // tranfer fee to fee account
        izar_token.leo/mint_public(proxy_owner(), payload.fee, payload.token_id);
    }

    transition upgrade (public new_contract: address) {
        assert_eq(self.caller, proxy_owner());
        izar_token.leo/transfer_ownership(new_contract);
    }

    transition proxy_regist_token (metadata: IzarTokenMeta) {
        assert_eq(self.caller, proxy_owner());
        izar_token.leo/regist_token(metadata);
    }
}

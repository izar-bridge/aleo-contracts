program izar_protocol_v3.aleo {
    mapping izar_keeper: bool => [address; 20];
    mapping izar_digest: bool => scalar;
    // 0: current_epoch, 1: current_keeper_num;
    mapping izar_config: u8 => u32;
    mapping nonces: Nonce => bool;

    struct Nonce {
        chain_id: u32,
        nonce: u128,
    }

    struct IzarRecvMsg {
        from_chain_id: u32,
        nonce: u128,
        to_addr: address,
        to_asset_addr: address,
        amount: u128,
    }

    struct IzarCrossMsg {
        to_chain_id: u32,
        to_addr: field,
        to_asset_addr: field,
        amount: u128,
        fee: u128,
    }

    inline contract_owner() -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline invalid_contract() -> address {
        return aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    }

    /* config setup */
    transition update_keeper (keepers: [address; 20]) {
        assert_eq(self.caller, contract_owner());
        return then finalize (keepers);
    }

    finalize update_keeper (keepers: [address; 20]) {
        let accpeted: u32 = 0u32;

        let arr: [u32; 3] = [0u32, 0u32, 0u32];

        for i: u8 in 0u8..20u8 {
            if keepers[i] != invalid_contract() {
                accpeted += 1u32;
            }
        }

        Mapping::set(izar_keeper, true, keepers);
        Mapping::set(izar_config, 1u8, accpeted);
    }

    function verify_sigs (keepers: [address; 20], signatures: [signature; 20], msg: IzarRecvMsg) -> (scalar, u32) {
        let accepted: u32 = 0u32;

        for i: u8 in 0u8..20u8 {
            if keepers[i] != invalid_contract() {
                let sig: signature = signatures[i];
                if sig.verify(keepers[i], msg) {
                    accepted += 1u32;
                }
            }
        }

        let result: scalar = Poseidon8::hash_to_scalar(keepers);

        return (result, accepted);
    }

    transition verify (signatures: [signature; 20], keepers: [address; 20], payload: IzarRecvMsg) -> address {
        let (result, accepted): (scalar, u32) = verify_sigs(keepers, signatures, payload);
        let nonce: Nonce = Nonce {
            chain_id: payload.from_chain_id,
            nonce: payload.nonce,
        };

        return payload.to_asset_addr then finalize (nonce, result, accepted);
    }

    finalize verify (nonce: Nonce, keeper_digest: scalar, accepted: u32) {
        // check nonce
        assert(!Mapping::get_or_use(nonces, nonce, false));

        // check keeper digest & accepted
        assert(keeper_digest == Mapping::get(izar_digest, true));
        let validator_num: u32 = Mapping::get(izar_config, 1u8);
        assert(accepted >= validator_num / 3u32 * 2u32); // TODO: check this

        // set nonce
        Mapping::set(nonces, nonce, true);
    }
}

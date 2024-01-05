program izar_protocol_v1.aleo {
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

    inline protocol_owner() -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline invalid_contract() -> address {
        return aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    }

    inline protocol_contract() -> address {
        return aleo1e5szs84jql2hn08ffxc7yn97wa8s9vk7jgshcddxmaekdxh85upsdt8p9g;
    }

    /* config setup */
    transition update_keeper (keepers: [address; 20]) {
        assert_eq(self.caller, protocol_owner());
        let digest: scalar = Poseidon8::hash_to_scalar(keepers);
        return then finalize (keepers, digest);
    }

    finalize update_keeper (keepers: [address; 20], digest: scalar) {
        let accpeted: u32 = 0u32;

        for i: u8 in 0u8..20u8 {
            if keepers[i] != invalid_contract() {
                accpeted += 1u32;
            }
        }

        Mapping::set(izar_keeper, true, keepers);
        Mapping::set(izar_config, 1u8, accpeted);
        Mapping::set(izar_digest, true, digest);
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

    transition verify (signatures: [signature; 20], keepers: [address; 20], payload: IzarRecvMsg) {
        assert_eq(payload.protocol_addr, protocol_contract());
        let (result, accepted): (scalar, u32) = verify_sigs(keepers, signatures, payload);
        let nonce: Nonce = Nonce {
            chain_id: payload.from_chain_id,
            nonce: payload.nonce,
        };

        return then finalize (nonce, result, accepted);
    }

    finalize verify (nonce: Nonce, keeper_digest: scalar, accepted: u32) {
        // check nonce
        assert(!Mapping::get_or_use(nonces, nonce, false));

        // check keeper digest & accepted
        assert(keeper_digest == Mapping::get(izar_digest, true));
        let num: u32 = Mapping::get(izar_config, 1u8);
        assert(accepted >= num - (num - 1u32) / 3u32);

        // set nonce
        Mapping::set(nonces, nonce, true);
    }
}

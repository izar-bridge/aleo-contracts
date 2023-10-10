program izar_protocol_v3.aleo {
    mapping izar_keeper: bool => Keepers20;
    mapping izar_digest: bool => scalar;
    // 0: current_epoch, 1: current_keeper_num;
    mapping izar_config: u8 => u32;
    mapping nonces: Nonce => bool;

    struct Nonce {
        chain_id: u32,
        nonce: u128,
    }

    inline contract_owner() -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline unvalid_contract() -> address {
        return aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;
    }

    /* config setup */
    transition set_epoch (epoch: u32) {
        assert_eq(self.caller, contract_owner());
        return then finalize (epoch);
    }

    finalize set_epoch (epoch: u32) {
        assert(epoch > Mapping::get_or_use(izar_config, 0u8, 0u32));
        Mapping::set(izar_config, 0u8, epoch);
    }

    transition update_keeper (keepers: Keepers20) {
        assert_eq(self.caller, contract_owner());
        return then finalize (keepers);
    }

    finalize update_keeper (keepers: Keepers20) {
        let accpeted: u32 = 0u32;

        if keepers.k0 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k1 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k2 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k3 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k4 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k5 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k6 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k7 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k8 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k9 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k10 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k11 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k12 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k13 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k14 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k15 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k16 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k17 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k18 != unvalid_contract() {
            accpeted += 1u32;
        }

        if keepers.k19 != unvalid_contract() {
            accpeted += 1u32;
        }

        Mapping::set(izar_keeper, true, keepers);
        Mapping::set(izar_config, 1u8, accpeted);
    }

    transition verify (from_chain_id: u32, signatures: Signatures20, keepers: Keepers20, payload: IzarRecvMsg) {
        let (result, accepted): (scalar, u32) = verify_sigs(keepers, signatures, payload);
        let nonce: Nonce = Nonce {
            chain_id: from_chain_id,
            nonce: payload.nonce,
        };

        return then finalize (nonce, result, accepted);
    }

    finalize verify (nonce: Nonce, keeper_digest: scalar, accepted: u32) {
        // check nonce
        assert(!Mapping::get_or_use(nonces, nonce, false));

        // check keeper digest & accepted
        assert(keeper_digest == Mapping::get(izar_digest, true));
        let valid_num: u32 = Mapping::get(izar_config, 1u8);
        assert(accepted >= valid_num / 3u32 * 2u32); // TODO: check this
    }

    struct Keepers20 {
        k0: address,
        k1: address,
        k2: address,
        k3: address,
        k4: address,
        k5: address,
        k6: address,
        k7: address,
        k8: address,
        k9: address,
        k10: address,
        k11: address,
        k12: address,
        k13: address,
        k14: address,
        k15: address,
        k16: address,
        k17: address,
        k18: address,
        k19: address,
    }

    struct Signatures20 {
        s0: signature,
        s1: signature,
        s2: signature,
        s3: signature,
        s4: signature,
        s5: signature,
        s6: signature,
        s7: signature,
        s8: signature,
        s9: signature,
        s10: signature,
        s11: signature,
        s12: signature,
        s13: signature,
        s14: signature,
        s15: signature,
        s16: signature,
        s17: signature,
        s18: signature,
        s19: signature,
    }

    struct IzarRecvMsg {
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

    function verify_sigs (keepers: Keepers20, signatures: Signatures20, msg: IzarRecvMsg) -> (scalar, u32) {
        let accepted: u32 = 0u32;

        if signatures.s0.verify(keepers.k0, msg) {
            accepted += 1u32;
        }
        if signatures.s2.verify(keepers.k2, msg) {
            accepted += 1u32;
        }
        if signatures.s3.verify(keepers.k3, msg) {
            accepted += 1u32;
        }
        if signatures.s4.verify(keepers.k4, msg) {
            accepted += 1u32;
        }
        if signatures.s5.verify(keepers.k5, msg) {
            accepted += 1u32;
        }
        if signatures.s6.verify(keepers.k6, msg) {
            accepted += 1u32;
        }
        if signatures.s7.verify(keepers.k7, msg) {
            accepted += 1u32;
        }
        if signatures.s8.verify(keepers.k8, msg) {
            accepted += 1u32;
        }
        if signatures.s9.verify(keepers.k9, msg) {
            accepted += 1u32;
        }
        if signatures.s10.verify(keepers.k10, msg) {
            accepted += 1u32;
        }
        if signatures.s11.verify(keepers.k11, msg) {
            accepted += 1u32;
        }
        if signatures.s12.verify(keepers.k12, msg) {
            accepted += 1u32;
        }
        if signatures.s13.verify(keepers.k13, msg) {
            accepted += 1u32;
        }
        if signatures.s14.verify(keepers.k14, msg) {
            accepted += 1u32;
        }
        if signatures.s15.verify(keepers.k15, msg) {
            accepted += 1u32;
        }
        if signatures.s16.verify(keepers.k16, msg) {
            accepted += 1u32;
        }
        if signatures.s17.verify(keepers.k17, msg) {
            accepted += 1u32;
        }
        if signatures.s18.verify(keepers.k18, msg) {
            accepted += 1u32;
        }
        if signatures.s19.verify(keepers.k19, msg) {
            accepted += 1u32;
        }

        let result: scalar = Poseidon8::hash_to_scalar(keepers);

        return (result, accepted);
    }
}

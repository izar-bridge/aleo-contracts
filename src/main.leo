program izar_v2.aleo {
    mapping balance: Account => u128;
    mapping token_exist: u32 => bool;
    mapping token_metas: u32 => IzarTokenMeta;

    struct Account {
        addr: address,
        token_id: u32,
    }

    struct IzarTokenMeta {
        token_id: u32,
        token_name: u128,
        chain_id: u32,
    }

    struct EthAddr {
        a0: u32,
        a1: u32,
        a2: u32,
        a3: u32,
        a4: u32,
    }

    record IzarToken {
        owner: address,
        amount: u128,
        token_id: u32,
    }

    record CrossCredits {
        owner: address,
        amount: u128,
        to_chain_id: u32,
        to_asset_addr: EthAddr,
        to_addr: EthAddr,
        from_addr: address,
    }

    inline contract_owner () -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    /* register new token */
    transition register_new_token (token_name: u128, token_id: u32, chain_id: u32) {
        assert_eq(self.caller, contract_owner());
        let metadata: IzarTokenMeta = IzarTokenMeta {
            token_id: token_id,
            token_name: token_name,
            chain_id: chain_id,
        };
        return then finalize (metadata, token_id);
    }

    finalize register_new_token (metadata: IzarTokenMeta, token_id: u32) {
        let exist: bool = Mapping::get_or_use(token_exist, token_id, false);

        assert(!exist);

        Mapping::set(token_exist, token_id, true);
        Mapping::set(token_metas, token_id, metadata);
    }

    /* mint token */
    transition receive_public (nonce: u128, addr: address, amount: u128, token_id: u32, sig1: Signature, sig2: Signature, msg: Msg8, from_chain_id: u32) {
        let flag1: bool = verify_msg8(sig1, get_keeper1(), msg, get_keeper1_group()) && verify_msg8(sig2, get_keeper2(), msg, get_keeper2_group());
        let flag2: bool = verify_msg8(sig2, get_keeper1(), msg, get_keeper1_group()) && verify_msg8(sig1, get_keeper2(), msg, get_keeper2_group());
        assert(flag1 || flag2);
        let tx_nonce: TxNonce = TxNonce {
            chain_id: from_chain_id,
            nonce: nonce,
        };

        return then finalize (tx_nonce, addr, amount, token_id);
    }

    finalize receive_public (nonce: TxNonce, addr: address, amount: u128, token_id: u32) {
        // check nonce
        assert(!Mapping::get_or_use(tx_nonces, nonce, false));

        // check token exist
        assert(Mapping::get_or_use(token_exist, token_id, false));

        // mint public
        let caller_account: Account = Account {
            addr: addr,
            token_id: token_id,
        };
        let cur_amount: u128 = Mapping::get_or_use(balance, caller_account, 0u128);
        Mapping::set(balance, caller_account, cur_amount + amount);

        // set nonce
        Mapping::set(tx_nonces, nonce, true);
    }

    transition receive_private (nonce: u128, addr: address, amount: u128, token_id: u32, sig1: Signature, sig2: Signature, msg: Msg8, from_chain_id: u32) -> IzarToken {
        let flag1: bool = verify_msg8(sig1, get_keeper1(), msg, get_keeper1_group()) && verify_msg8(sig2, get_keeper2(), msg, get_keeper2_group());
        let flag2: bool = verify_msg8(sig2, get_keeper1(), msg, get_keeper1_group()) && verify_msg8(sig1, get_keeper2(), msg, get_keeper2_group());
        assert(flag1 || flag2);

        let tx_nonce: TxNonce = TxNonce {
            chain_id: from_chain_id,
            nonce: nonce,
        };

        return IzarToken {
            owner: self.caller,
            amount: amount,
            token_id: token_id,
        } then finalize (tx_nonce, token_id);
    }

    finalize receive_private (nonce: TxNonce, token_id: u32) {
        // check nonce
        assert(!Mapping::get_or_use(tx_nonces, nonce, false));

        // check token exist
        assert(Mapping::get_or_use(token_exist, token_id, false));

        // update nonce
        Mapping::set(tx_nonces, nonce, true);
    }

    /* cross and burn token */
    transition cross_public (public to_chain_id: u32, public to_asset_addr: EthAddr, public to_addr: EthAddr, public token_id: u32, public amount: u128, public fee: u128) {
        assert(amount > fee);

        return then finalize (self.caller, token_id, amount, fee, to_chain_id);
    }

    finalize cross_public (sender: address, token_id: u32, amount: u128, fee: u128, to_chain_id: u32) {
        let sender_account: Account = Account {
            addr: sender,
            token_id: token_id,
        };

        // check token id is from chain id
        let exist: bool = Mapping::get_or_use(token_exist, token_id, false);
        assert(exist);

        // burn
        let cur_amount: u128 = Mapping::get_or_use(balance, sender_account, 0u128);
        assert(cur_amount >= amount);
        Mapping::set(balance, sender_account, cur_amount - amount);

        // tranfer fee to bridge
        let contract_account: Account = Account {
            addr: contract_owner(),
            token_id: token_id,
        };
        let contract_amount: u128 = Mapping::get_or_use(balance, contract_account, 0u128);
        Mapping::set(balance, contract_account, contract_amount + fee);
    }

    transition cross_private (to_chain_id: u32, to_asset_addr: EthAddr, to_addr: EthAddr, token: IzarToken, amount: u128, fee: u128) -> (CrossCredits, CrossCredits, IzarToken, IzarToken) {
        assert(token.amount > fee);
        let keeper1: address = get_keeper1();
        let keeper2: address = get_keeper2();

        let keeper1_credits: CrossCredits = CrossCredits {
            owner: keeper1,
            amount: token.amount - fee,
            to_chain_id: to_chain_id,
            to_addr: to_addr,
            to_asset_addr: to_asset_addr,
            from_addr: self.caller,
        };

        let keeper2_credits: CrossCredits = CrossCredits {
            owner: keeper2,
            amount: token.amount - fee,
            to_chain_id: to_chain_id,
            to_addr: to_addr,
            to_asset_addr: to_asset_addr,
            from_addr: self.caller,
        };

        let remaining_balance: IzarToken = IzarToken {
            owner: token.owner,
            amount: token.amount - fee,
            token_id: token.token_id,
        };
        let fee_balance: IzarToken = IzarToken {
            owner: contract_owner(),
            amount: fee,
            token_id: token.token_id,
        };

        return (keeper1_credits, keeper2_credits, remaining_balance, fee_balance);
    }

    /* Transfer */
    transition transfer_public (public receiver: address, public amount: u128, public token_id: u32) {
        let account: Account = Account {
            addr: self.caller,
            token_id: token_id,
        };

        let receiver_account: Account = Account {
            addr: receiver,
            token_id: token_id,
        };

        return then finalize (account, receiver_account, amount);
    }

    finalize transfer_public (caller: Account, receiver: Account, amount: u128) {
        // check token exist
        assert(Mapping::get_or_use(token_exist, caller.token_id, false));
        // check balance
        let cur_amount: u128 = Mapping::get_or_use(balance, caller, 0u128);
        assert(cur_amount >= amount);

        // transfer
        Mapping::set(balance, caller, cur_amount - amount);
        let receiver_amount: u128 = Mapping::get_or_use(balance, receiver, 0u128);
        Mapping::set(balance, receiver, receiver_amount + amount);
    }

    transition transfer_private (token: IzarToken, receiver: address, token_id: u32, amount: u128) -> (IzarToken, IzarToken) {
        // check balance
        assert(token.amount >= amount);

        let remaining_balance: IzarToken = IzarToken {
            owner: token.owner,
            amount: token.amount - amount,
            token_id: token.token_id,
        };

        let receiver_balance: IzarToken = IzarToken {
            owner: receiver,
            amount: amount,
            token_id: token.token_id,
        };

        return (remaining_balance, receiver_balance);
    }

    transition transfer_private_to_public (token: IzarToken, public receiver: address, public amount: u128) -> IzarToken {
        // check balance
        assert(token.amount >= amount);

        let remaining_balance: IzarToken = IzarToken {
            owner: token.owner,
            amount: token.amount - amount,
            token_id: token.token_id,
        };

        let receiver_account: Account = Account {
            addr: receiver,
            token_id: token.token_id,
        };

        return then finalize (receiver_account, amount);
    }

    finalize transfer_private_to_public (receiver: Account, amount: u128) {
        // check token exist
        assert(Mapping::get_or_use(token_exist, receiver.token_id, false));
        let cur_amount: u128 = Mapping::get_or_use(balance, receiver, 0u128);
        Mapping::set(balance, receiver, cur_amount + amount);
    }

    transition transfer_public_to_private (public receiver: address, public amount: u128, public token_id: u32) -> IzarToken {
        let transferred: IzarToken = IzarToken {
            owner: receiver,
            amount: amount,
            token_id: token_id,
        };

        let remain_account: Account = Account {
            addr: self.caller,
            token_id: token_id,
        };

        return transferred then finalize (remain_account, amount);
    }

    finalize transfer_public_to_private (sender: Account, amount: u128) {
        // check token exist
        assert(Mapping::get_or_use(token_exist, sender.token_id, false));
        let cur_amount: u128 = Mapping::get_or_use(balance, sender, 0u128);
        assert(cur_amount >= amount);
        Mapping::set(balance, sender, cur_amount - amount);
    }


    ///  Izar Bridge
    ///
    ///
    struct TxNonce {
        chain_id: u32,
        nonce: u128,
    }

    mapping tx_nonces: TxNonce => bool;

    inline get_bridge_addr () -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline get_keeper1 () -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline get_keeper2 () -> address {
        return aleo13xju8vdz03rh0cv363cemawqm7upffll7642q7prhg5ngveu2cgq9yl40k;
    }

    inline get_keeper1_group() -> group {
        return 3083739699999321821309501426991277829236821275796995707528979037100686121416group;
    }

    inline get_keeper2_group() -> group {
        return 8443908915153863857408439068119195595786438822177699178467508515615387023687group;
    }

    /// Izar Sign
    ///
    ///
    struct Signature {
        challenge: scalar,
        response: scalar,
        pk_sig: group,
        pr_sig: group,
        sk_prf: scalar,
    }

    struct Msg8 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
    }

    struct Msg16 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
        m8: field,
        m9: field,
        m10: field,
        m11: field,
        m12: field,
        m13: field,
        m14: field,
        m15: field,
    }

    struct Msg32 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
        m8: field,
        m9: field,
        m10: field,
        m11: field,
        m12: field,
        m13: field,
        m14: field,
        m15: field,
        m16: field,
        m17: field,
        m18: field,
        m19: field,
        m20: field,
        m21: field,
        m22: field,
        m23: field,
        m24: field,
        m25: field,
        m26: field,
        m27: field,
        m28: field,
        m29: field,
        m30: field,
        m31: field,
    }

    inline verify_msg8 (sig: Signature, addr: address, msg: Msg8, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }

    inline verify_msg16 (sig: Signature, addr: address, msg: Msg16, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }

    inline verify_msg32 (sig: Signature, addr: address, msg: Msg32, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }
}

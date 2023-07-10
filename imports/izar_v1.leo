program izar_v1.aleo {
    // On-chain storage of an `account` map, with `address` as the key,
    // and `u64` as the value.
    mapping account: address => u128;
    mapping confirmed_eth_tx: u128 => bool;

    record zkETH {
        // The zkETH owner.
        owner: address,
        // The zkETH amount.
        amount: u128,
    }

    record CrossCredits {
        owner: address,
        amount: u128,
        to_chain_id: u32,
        to_asset_addr: EthAddr,
        to_addr: EthAddr,
        from_addr: address,
    }

    // eth address is 20 bytes
    struct EthAddr {
        a0: u32,
        a1: u32,
        a2: u32,
        a3: u32,
        a4: u32,
    }

    struct Signature {
        challenge: scalar,
        response: scalar,
        pk_sig: group,
        pr_sig: group,
        sk_prf: scalar,
    }

    struct Message {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
    }

    inline verify_sig (sig: Signature, addr: address, msg: Message, addr_g: group) -> bool {
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

    /* Cross */
    transition cross_public (public to_chain_id: u32, public to_asset_addr: EthAddr, public to_addr: EthAddr, public amount: u128, public fee: u128) {
        assert(amount > fee);
        return then finalize(to_chain_id, self.caller, amount, fee);
    }

    finalize cross_public (to_chain_id: u32, sender: address, amount: u128, fee: u128) {
        // burn
        let current_amount: u128 = Mapping::get_or_use(account, sender, 0u128);
        assert(current_amount >= amount);
        Mapping::set(account, sender, current_amount - amount);

        // transfer fee to bridge
        let bridge_amount: u128 = Mapping::get_or_use(account, get_bridge_addr(), 0u128);
        Mapping::set(account, get_bridge_addr(), bridge_amount + fee);
    }

    transition cross_private (to_chain_id: u32, to_asset_addr: EthAddr, to_addr: EthAddr, balance: zkETH, amount: u128, fee: u128) -> (CrossCredits, CrossCredits, zkETH){
        assert(balance.amount > fee);
        let keeper1: address = get_keeper1();
        let keeper2: address = get_keeper2();
        let keeper1_credits: CrossCredits = CrossCredits {
            owner: keeper1,
            amount: balance.amount - fee,
            to_chain_id: to_chain_id,
            to_asset_addr: to_asset_addr,
            to_addr: to_addr,
            from_addr: self.caller,
        };
        let keeper2_credits: CrossCredits = CrossCredits {
            owner: keeper2,
            amount: balance.amount - fee,
            to_chain_id: to_chain_id,
            to_asset_addr: to_asset_addr,
            to_addr: to_addr,
            from_addr: self.caller,
        };
        let remaining_balance: zkETH = zkETH {
            owner: balance.owner,
            amount: balance.amount - amount,
        };
        return (keeper1_credits, keeper2_credits, remaining_balance) then finalize (to_chain_id, fee);
    }

    finalize cross_private (to_chain_id: u32, fee: u128) {
        // transfer fee to bridge
        let bridge_amount: u128 = Mapping::get_or_use(account, get_bridge_addr(), 0u128);
        Mapping::set(account, get_bridge_addr(), bridge_amount + fee);
    }

    /* onReceive */
    transition receive_public (nonce: u128, to_addr: address, amount: u128, sig1: Signature, sig2: Signature, msg: Message) {
        let flag1: bool = verify_sig(sig1, get_keeper1(), msg, get_keeper1_group()) && verify_sig(sig2, get_keeper2(), msg, get_keeper2_group());
        let flag2: bool = verify_sig(sig2, get_keeper1(), msg, get_keeper1_group()) && verify_sig(sig1, get_keeper2(), msg, get_keeper2_group());
        assert(flag1 || flag2);
        return then finalize(nonce, to_addr, amount);
    }

    finalize receive_public (nonce: u128, to_addr: address, amount: u128) {
        // check nonce
        assert(!Mapping::get_or_use(confirmed_eth_tx, nonce, false));

        // mint
        let current_amount: u128 = Mapping::get_or_use(account, to_addr, 0u128);
        Mapping::set(account, to_addr, current_amount + amount);

        // update nonce
        Mapping::set(confirmed_eth_tx, nonce, true);
    }

    transition receive_private (nonce: u128, to_addr: address, amount: u128, sig1: Signature, sig2: Signature, msg: Message) -> zkETH  {
        let flag1: bool = verify_sig(sig1, get_keeper1(), msg, get_keeper1_group()) && verify_sig(sig2, get_keeper2(), msg, get_keeper2_group());
        let flag2: bool = verify_sig(sig2, get_keeper1(), msg, get_keeper1_group()) && verify_sig(sig1, get_keeper2(), msg, get_keeper2_group());
        assert(flag1 || flag2);
        return zkETH {
            owner: to_addr,
            amount: amount,
        } then finalize(nonce);
    }

    finalize receive_private (nonce: u128) {
        // check nonce
        assert(!Mapping::get_or_use(confirmed_eth_tx, nonce, false));

        // update nonce
        Mapping::set(confirmed_eth_tx, nonce, true);
    }

    /* Burn */
    transition burn_public(public amount: u128) {
        return then finalize(self.caller, amount);
    }

    finalize burn_public(public sender: address, public amount: u128) {
        let current_amount: u128 = Mapping::get_or_use(account, sender, 0u128);
        assert(current_amount >= amount);
        Mapping::set(account, sender, current_amount - amount);
    }

    transition burn_private(sender: zkETH, amount: u128) -> zkETH {
        let difference: u128 = sender.amount - amount;

        let remaining: zkETH = zkETH {
            owner: sender.owner,
            amount: difference,
        };

        return remaining;
    }


    /* Transfer */
    transition transfer_public(public receiver: address, public amount: u128) {
        return then finalize(self.caller, receiver, amount);
    }

    finalize transfer_public(public sender: address, public receiver: address, public amount: u128) {
        let sender_amount: u128 = Mapping::get_or_use(account, sender, 0u128);
        Mapping::set(account, sender, sender_amount - amount);

        let receiver_amount: u128 = Mapping::get_or_use(account, receiver, 0u128);
        Mapping::set(account, receiver, receiver_amount + amount);
    }

    transition transfer_private(sender: zkETH, receiver: address, amount: u128) -> (zkETH, zkETH) {
        let difference: u128 = sender.amount - amount;

        let remaining: zkETH = zkETH {
            owner: sender.owner,
            amount: difference,
        };

        let transferred: zkETH = zkETH {
            owner: receiver,
            amount: amount,
        };

        return (remaining, transferred);
    }

    transition transfer_private_to_public(sender: zkETH, public receiver: address, public amount: u128) -> zkETH {
        let difference: u128 = sender.amount - amount;

        let remaining: zkETH = zkETH {
            owner: sender.owner,
            amount: difference,
        };

        return remaining then finalize(receiver, amount);
    }

    finalize transfer_private_to_public(public receiver: address, public amount: u128) {
        let current_amount: u128 = Mapping::get_or_use(account, receiver, 0u128);
        Mapping::set(account, receiver, current_amount + amount);
    }

    transition transfer_public_to_private(public receiver: address, public amount: u128) -> zkETH {
        let transferred: zkETH = zkETH {
            owner: receiver,
            amount: amount,
        };

        return transferred then finalize(self.caller, amount);
    }

    finalize transfer_public_to_private(public sender: address, public amount: u128) {
        let current_amount: u128 = Mapping::get_or_use(account, sender, 0u128);
        Mapping::set(account, sender, current_amount - amount);
    }

}


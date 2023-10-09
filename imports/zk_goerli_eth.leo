program zk_goerli_eth.aleo {
    mapping account: address => u128;
    mapping contract_ownership: bool => address;
    mapping allowance: AllowPair => u128;
    mapping initialed: bool => bool;

    record token {
        owner: address,
        amount: u128,
    }

    struct AllowPair {
        holder: address,
        spender: address,
    }

    /* permission */
    transition initial(holder: address) {
        return then finalize (holder);
    }

    finalize initial(holder: address) {
        let is_initial: bool = Mapping::get_or_use(initialed, true, false);
        assert_eq(is_initial, false);

        Mapping::set(contract_ownership, true, holder);
    }

    transition transfer_ownership (recipient: address) {
        return then finalize (recipient, self.caller);
    }

    finalize transfer_ownership (recipient: address, caller: address) {
        let is_initial: bool = Mapping::get_or_use(initialed, true, false);
        assert_eq(is_initial, true);

        let current_owner: address = Mapping::get(contract_ownership, true);
        assert_eq(current_owner, caller);

        Mapping::set(contract_ownership, true, recipient);
    }

    /* allowance */

    transition approve (spender: address, amount: u128) {
        // TODO: when leo update the compiler, we can use `self.singer` instead of `self.caller`
        return then finalize (self.caller, spender, amount);
    }

    finalize approve (holder: address, spender: address, amount: u128) {
        let pair: AllowPair = AllowPair {
            holder,
            spender,
        };
        Mapping::set(allowance, pair, amount);
    }

    transition transfer_from (from: address, to: address, amount: u128) {
        return then finalize (self.caller, from, to, amount);
    }

    finalize transfer_from (spender: address, from: address, to: address, amount: u128) {
        let pair: AllowPair = AllowPair {
            holder: from,
            spender,
        };
        // set allowance
        let current_allow: u128 = Mapping::get_or_use(allowance, pair, 0u128);
        Mapping::set(allowance, pair, current_allow - amount);

        // transfer
        let current_from: u128 = Mapping::get_or_use(account, from, 0u128);
        Mapping::set(account, from, current_from - amount);
        let current_to: u128 = Mapping::get_or_use(account, to, 0u128);
        Mapping::set(account, to, current_to - amount);
    }

    /* mint & burn */

    transition mint_public(public receiver: address, public amount: u128) {
        return then finalize(receiver, amount, self.caller);
    }

    finalize mint_public(public receiver: address, public amount: u128, public caller: address) {
        let current_owner: address = Mapping::get(contract_ownership, true);
        assert_eq(current_owner, caller);
        let current_amount: u128 = Mapping::get_or_use(account, receiver, 0u128);
        Mapping::set(account, receiver, current_amount + amount);
    }

    transition mint_private(receiver: address, amount: u128) -> token {
        return token {
            owner: receiver,
            amount: amount,
        } then finalize (self.caller);
    }

    finalize mint_private (public caller: address) {
        let current_owner: address = Mapping::get(contract_ownership, true);
        assert_eq(current_owner, caller);
    }

    transition burn_public (public receiver: address, public amount: u128) {
        return then finalize(receiver, amount, self.caller);
    }

    finalize burn_public (public receiver: address, public amount: u128, public caller: address) {
        let current_owner: address = Mapping::get(contract_ownership, true);
        assert_eq(current_owner, caller);

        let current_amount: u128 = Mapping::get_or_use(account, receiver, 0u128);
        Mapping::set(account, receiver, current_amount - amount);
    }

    transition burn_private (receiver: address, note: token, amount: u128) -> token {
        return token {
            owner: note.owner,
            amount: note.amount - amount,
        } then finalize (self.caller);
    }

    finalize burn_private (public caller: address) {
        let current_owner: address = Mapping::get(contract_ownership, true);
        assert_eq(current_owner, caller);
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

    transition transfer_private(sender: token, receiver: address, amount: u128) -> (token, token) {
        let difference: u128 = sender.amount - amount;

        let remaining: token = token {
            owner: sender.owner,
            amount: difference,
        };

        let transferred: token = token {
            owner: receiver,
            amount: amount,
        };

        return (remaining, transferred);
    }

    transition transfer_private_to_public(sender: token, public receiver: address, public amount: u128) -> token {
        let difference: u128 = sender.amount - amount;

        let remaining: token = token {
            owner: sender.owner,
            amount: difference,
        };

        return remaining then finalize(receiver, amount);
    }

    finalize transfer_private_to_public(public receiver: address, public amount: u128) {
        let current_amount: u128 = Mapping::get_or_use(account, receiver, 0u128);
        Mapping::set(account, receiver, current_amount + amount);
    }

    transition transfer_public_to_private(public receiver: address, public amount: u128) -> token {
        let transferred: token = token {
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

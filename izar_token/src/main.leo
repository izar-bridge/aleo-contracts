program izar_token.aleo {
    mapping accounts: Account => u128;
    mapping token_meta: field => IzarTokenMeta;
    mapping contract_owner: bool => address;
    mapping initialed: bool => bool;

    struct Account {
        holder: address,
        token_id: field,
    }

    // token_id = hash_bhp256(metadata)
    struct IzarTokenMeta {
        from_chain_id: u32,
        from_asset_addr: field,
    }

    record IzarToken {
        owner: address,
        amount: u128,
        token_id: field,
    }

    transition initial (owner: address) {
        return then finalize(owner);
    }

    finalize initial (owner: address) {
        let is_initailized: bool = Mapping::get_or_use(initialed, true, false);
        assert(!is_initailized);

        Mapping::set(contract_owner, true, owner);
        Mapping::set(initialed, true, true);
    }

    transition transfer_ownership (new_owner: address) {
        return then finalize(self.caller, new_owner);
    }

    finalize transfer_ownership (caller: address, new_owner: address) {
        let is_initailized: bool = Mapping::get_or_use(initialed, true, false);
        assert(is_initailized);

        let older: address = Mapping::get(contract_owner, true);
        assert_eq(older, caller);

        Mapping::set(contract_owner, true, new_owner);
    }

    transition regist_token (metadata: IzarTokenMeta) {
        return then finalize(metadata, self.caller);
    }

    finalize regist_token (metadata: IzarTokenMeta, caller: address) {
        let is_initailized: bool = Mapping::get_or_use(initialed, true, false);
        assert(is_initailized);

        let current_owner: address = Mapping::get(contract_owner, true);
        assert_eq(current_owner, caller);

        let token_id: field = BHP256::hash_to_field(metadata);

        assert(!Mapping::contains(token_meta, token_id));

        Mapping::set(token_meta, token_id, metadata);
    }

    transition verify_token (token_id: field, from_chain_id: u32, from_asset_addr: field) {
        return then finalize(token_id, from_chain_id, from_asset_addr);
    }

    finalize verify_token (token_id: field, from_chain_id: u32, from_asset_addr: field) {
        let metadata: IzarTokenMeta = Mapping::get(token_meta, token_id);

        assert_eq(metadata.from_chain_id, from_chain_id);
        assert_eq(metadata.from_asset_addr, from_asset_addr);
    }

    transition mint_public(public receiver: address, public amount: u128, public token_id: field) {
        let account: Account = Account {
            holder: receiver,
            token_id: token_id,
        };
        return then finalize(account, amount, self.caller);
    }

    finalize mint_public(public receiver: Account, public amount: u128, public caller: address) {
        let current_owner: address = Mapping::get(contract_owner, true);
        assert_eq(current_owner, caller);

        // check token exist
        assert(Mapping::contains(token_meta, receiver.token_id));

        let current_amount: u128 = Mapping::get_or_use(accounts, receiver, 0u128);
        Mapping::set(accounts, receiver, current_amount + amount);
    }

    transition mint_private(receiver: address, amount: u128, token_id: field) -> IzarToken {
        return IzarToken {
            owner: receiver,
            amount: amount,
            token_id: token_id,
        } then finalize (self.caller, token_id);
    }

    finalize mint_private (caller: address, token_id: field) {
        let current_owner: address = Mapping::get(contract_owner, true);
        assert_eq(current_owner, caller);

        // check token exist
        assert(Mapping::contains(token_meta, token_id));
    }

    transition burn_public (public receiver: address, public amount: u128, public token_id: field) {
        let receiver_account: Account = Account {
            holder: receiver,
            token_id: token_id,
        };
        return then finalize(receiver_account, amount, self.caller);
    }

    finalize burn_public (receiver: Account, amount: u128, caller: address) {
        let current_owner: address = Mapping::get(contract_owner, true);
        assert_eq(current_owner, caller);

        // check token exist
        assert(Mapping::contains(token_meta, receiver.token_id));

        let current_amount: u128 = Mapping::get_or_use(accounts, receiver, 0u128);
        Mapping::set(accounts, receiver, current_amount - amount);
    }

    transition burn_private (receiver: address, token: IzarToken, amount: u128) -> IzarToken {
        return IzarToken {
            owner: token.owner,
            amount: token.amount - amount,
            token_id: token.token_id,
        } then finalize (self.caller, token.token_id);
    }

    finalize burn_private (caller: address, token_id: field) {
        let current_owner: address = Mapping::get(contract_owner, true);
        assert_eq(current_owner, caller);

        // check token exist
        assert(Mapping::contains(token_meta, token_id));
    }

    transition transfer_public(public receiver: address, public amount: u128, public token_id: field) {
        let sender_account: Account = Account {
            holder: self.caller,
            token_id: token_id,
        };
        let receiver_account: Account = Account {
            holder: receiver,
            token_id: token_id,
        };
        return then finalize(sender_account, receiver_account, amount);
    }

    finalize transfer_public(public sender: Account, public receiver: Account, public amount: u128) {
        // check token exist
        assert(Mapping::contains(token_meta, receiver.token_id));

        let sender_amount: u128 = Mapping::get_or_use(accounts, sender, 0u128);
        Mapping::set(accounts, sender, sender_amount - amount);

        let receiver_amount: u128 = Mapping::get_or_use(accounts, receiver, 0u128);
        Mapping::set(accounts, receiver, receiver_amount + amount);
    }

    transition transfer_private(token: IzarToken, receiver: address, amount: u128) -> (IzarToken, IzarToken) {
        let difference: u128 = token.amount - amount;

        let remaining: IzarToken = IzarToken {
            owner: token.owner,
            amount: difference,
            token_id: token.token_id,
        };

        let transferred: IzarToken = IzarToken {
            owner: receiver,
            amount: amount,
            token_id: token.token_id,
        };
        // no need to check token exist
        return (remaining, transferred);
    }

    transition transfer_private_to_public(token: IzarToken, public receiver: address, public amount: u128) -> IzarToken {
        let difference: u128 = token.amount - amount;

        let remaining: IzarToken = IzarToken {
            owner: token.owner,
            amount: difference,
            token_id: token.token_id,
        };

        let receiver_account: Account = Account {
            holder: receiver,
            token_id: token.token_id,
        };

        return remaining then finalize(receiver_account, amount);
    }

    finalize transfer_private_to_public(receiver: Account, amount: u128) {
        // no need to check token exist
        let current_amount: u128 = Mapping::get_or_use(accounts, receiver, 0u128);
        Mapping::set(accounts, receiver, current_amount + amount);
    }

    transition transfer_public_to_private(public receiver: address, public amount: u128, public token_id: field) -> IzarToken {
        let transferred: IzarToken = IzarToken {
            owner: receiver,
            amount: amount,
            token_id: token_id,
        };

        let sender_account: Account = Account {
            holder: self.caller,
            token_id: token_id,
        };

        return transferred then finalize(sender_account, amount);
    }

    finalize transfer_public_to_private(sender: Account, amount: u128) {
        // check token exist
        assert(Mapping::contains(token_meta, sender.token_id));

        let current_amount: u128 = Mapping::get_or_use(accounts, sender, 0u128);
        Mapping::set(accounts, sender, current_amount - amount);
    }
}

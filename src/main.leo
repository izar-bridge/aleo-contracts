import zk_sepolia_eth.leo;
import izar_protocol_v3.leo;

// The 'izar_protocol_v3' program.
program izar_sepolia_proxy_v1.aleo {
    inline proxy_owner () -> address  {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    transition receive_payload (signatures: Signatures3, keepers: Keepers3, payload: IzarRecvMsg) {
        izar_protocol_v3.leo/verify(signatures, keepers, payload);
        zk_sepolia_eth.leo/mint_public(payload.to_addr, payload.amount);

        return then finalize(self.caller);
    }

    // !NOTICE: IT'S A LEO COMPILER BUG
    finalize receive_payload (caller: address) {
        // add some noise
        let a: u32 = 1u32;
    }

    transition cross_public(public payload: IzarCrossMsg) {
        // tranfer fee to fee account
        zk_sepolia_eth.leo/transfer_public(proxy_owner(), payload.fee);
        // burn token
        zk_sepolia_eth.leo/burn_public(self.signer, payload.amount - payload.fee); // TODO: when leo update the compiler, we can use `self.singer` instead of `self.caller`

        return then finalize(self.caller);
    }

    // !NOTICE: IT'S A LEO COMPILER BUG
    finalize cross_public(caller: address) {
        // add some noise
        let a: u32 = 1u32;
    }

    // TODO: is needed to use multisig to call this function？
    transition upgrade (public new_contract: address) {
        assert_eq(self.caller, proxy_owner());
        zk_sepolia_eth.leo/transfer_ownership(new_contract);
    }
}

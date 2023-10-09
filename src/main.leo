import zk_sepolia_eth.leo;
import izar_protocol_v3.leo;

// The 'izar_protocol_v3' program.
program izar_sepolia_proxy_v1.aleo {
    inline fee_account () -> address  {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    transition receive_payload (from_chain_id: u32, signatures: Signatures20, keepers: Keepers20, payload: IzarRecvMsg, mode: bool) {
        izar_protocol_v3.leo/verify(from_chain_id, signatures, keepers, payload);
        // mint token by mode
        if mode {
            zk_sepolia_eth.leo/mint_public(payload.to_addr, payload.amount);
        } else {
            zk_sepolia_eth.leo/mint_private(payload.to_addr, payload.amount);
        }
        return;
    }

    transition cross_public(public payload: IzarCrossMsg) {
        // tranfer fee to fee account
        zk_sepolia_eth.leo/transfer_public(fee_account(), payload.fee);
        // burn token
        zk_sepolia_eth.leo/burn_public(self.caller, payload.amount - payload.fee); // TODO: when leo update the compiler, we can use `self.singer` instead of `self.caller`

        return;
    }
}

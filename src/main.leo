import zk_sepolia_eth.leo;
import izar_protocol_v3.leo;

// The 'izar_protocol_v3' program.
program izar_sepolia_proxy_v1.aleo {
    inline proxy_owner () -> address  {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    inline program_address() -> address {
        return aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    }

    transition receive_payload (signatures: [signature; 20], keepers: [address; 20], payload: IzarRecvMsg) {
        izar_protocol_v3.leo/verify(signatures, keepers, payload);
        zk_sepolia_eth.leo/mint_public(payload.to_addr, payload.amount);
    }

    transition cross_public(public payload: IzarCrossMsg) {
        // tranfer fee to fee account
        zk_sepolia_eth.leo/transfer_public(proxy_owner(), payload.fee);
        // burn token
        zk_sepolia_eth.leo/burn_public(self.caller, payload.amount - payload.fee);
    }

    transition upgrade (public new_contract: address) {
        assert_eq(self.caller, proxy_owner());
        zk_sepolia_eth.leo/transfer_ownership(new_contract);
    }
}

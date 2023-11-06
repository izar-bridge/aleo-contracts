import zk_sepolia_eth.aleo;
import izar_protocol_v3.aleo;
program izar_sepolia_proxy_v1.aleo;













function receive_payload:
    input r0 as Signatures3.private;
    input r1 as Keepers3.private;
    input r2 as IzarRecvMsg.private;
    call izar_protocol_v3.aleo/verify r0 r1 r2 into r3;
    call zk_sepolia_eth.aleo/mint_public r2.to_addr r2.amount into r4;
    async receive_payload r3 r4 into r5;
    output r5 as izar_sepolia_proxy_v1.aleo/receive_payload.future;

finalize receive_payload:
    input r0 as izar_protocol_v3.aleo/verify.future;
    input r1 as zk_sepolia_eth.aleo/mint_public.future;
    await r0;
    await r1;


function cross_public:
    input r0 as IzarCrossMsg.public;
    call zk_sepolia_eth.aleo/transfer_public aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns r0.fee into r1;
    sub r0.amount r0.fee into r2;
    call zk_sepolia_eth.aleo/burn_public self.signer r2 into r3;
    async cross_public r1 r3 into r4;
    output r4 as izar_sepolia_proxy_v1.aleo/cross_public.future;

finalize cross_public:
    input r0 as zk_sepolia_eth.aleo/transfer_public.future;
    input r1 as zk_sepolia_eth.aleo/burn_public.future;
    await r0;
    await r1;


function upgrade:
    input r0 as address.public;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    call zk_sepolia_eth.aleo/transfer_ownership r0 into r1;
    async upgrade r1 into r2;
    output r2 as izar_sepolia_proxy_v1.aleo/upgrade.future;

finalize upgrade:
    input r0 as zk_sepolia_eth.aleo/transfer_ownership.future;
    await r0;

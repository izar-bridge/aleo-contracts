import zk_sepolia_eth.aleo;
import izar_protocol_v3.aleo;
program izar_sepolia_proxy_v1.aleo;




struct Nonce:
    chain_id as u32;
    nonce as u128;

struct Keepers20:
    k0 as address;
    k1 as address;
    k2 as address;
    k3 as address;
    k4 as address;
    k5 as address;
    k6 as address;
    k7 as address;
    k8 as address;
    k9 as address;
    k10 as address;
    k11 as address;
    k12 as address;
    k13 as address;
    k14 as address;
    k15 as address;
    k16 as address;
    k17 as address;
    k18 as address;
    k19 as address;

struct Signatures20:
    s0 as signature;
    s1 as signature;
    s2 as signature;
    s3 as signature;
    s4 as signature;
    s5 as signature;
    s6 as signature;
    s7 as signature;
    s8 as signature;
    s9 as signature;
    s10 as signature;
    s11 as signature;
    s12 as signature;
    s13 as signature;
    s14 as signature;
    s15 as signature;
    s16 as signature;
    s17 as signature;
    s18 as signature;
    s19 as signature;

struct Keepers3:
    k0 as address;
    k1 as address;
    k2 as address;

struct Signatures3:
    s0 as signature;
    s1 as signature;
    s2 as signature;

struct IzarRecvMsg:
    from_chain_id as u32;
    nonce as u128;
    to_addr as address;
    to_asset_addr as address;
    amount as u128;

struct IzarCrossMsg:
    to_chain_id as u32;
    to_addr as field;
    to_asset_addr as field;
    amount as u128;
    fee as u128;









function receive_payload:
    input r0 as Signatures3.private;
    input r1 as Keepers3.private;
    input r2 as IzarRecvMsg.private;
    call izar_protocol_v3.aleo/verify r0 r1 r2 into r3;
    call zk_sepolia_eth.aleo/mint_public r2.to_addr r2.amount into r4;
    async receive_payload r3 r4 self.caller into r5;
    output r5 as izar_sepolia_proxy_v1.aleo/receive_payload.future;

finalize receive_payload:
    input r0 as izar_protocol_v3.aleo/verify.future;
    input r1 as zk_sepolia_eth.aleo/mint_public.future;
    input r2 as address.public;
    await r0;
    await r1;


function cross_public:
    input r0 as IzarCrossMsg.public;
    call zk_sepolia_eth.aleo/transfer_public aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns r0.fee into r1;
    sub r0.amount r0.fee into r2;
    call zk_sepolia_eth.aleo/burn_public self.signer r2 into r3;
    async cross_public r1 r3 self.caller into r4;
    output r4 as izar_sepolia_proxy_v1.aleo/cross_public.future;

finalize cross_public:
    input r0 as zk_sepolia_eth.aleo/transfer_public.future;
    input r1 as zk_sepolia_eth.aleo/burn_public.future;
    input r2 as address.public;
    await r0;
    await r1;


function upgrade:
    input r0 as address.public;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    call zk_sepolia_eth.aleo/transfer_ownership r0 into r1;

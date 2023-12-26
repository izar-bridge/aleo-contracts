import izar_protocol_v1.aleo;
import izar_token.aleo;
program izar_token_proxy_v1.aleo;





struct Nonce:
    chain_id as u32;
    nonce as u128;

struct Account:
    holder as address;
    token_id as u32;

struct IzarRecvMsg:
    from_chain_id as u32;
    nonce as u128;
    to_addr as address;
    to_asset_addr as address;
    protocol_addr as address;
    amount as u128;
    token_id as u32;

struct IzarCrossMsg:
    to_chain_id as u32;
    to_addr as field;
    to_asset_addr as field;
    token_id as u32;
    amount as u128;
    fee as u128;



function receive_payload:
    input r0 as [signature; 20u32].private;
    input r1 as [address; 20u32].private;
    input r2 as IzarRecvMsg.private;
    call izar_protocol_v1.aleo/verify r0 r1 r2 into r3;
    call izar_token.aleo/mint_public r2.to_addr r2.amount r2.token_id into r4;
    async receive_payload r3 r4 into r5;
    output r5 as izar_token_proxy_v1.aleo/receive_payload.future;

finalize receive_payload:
    input r0 as izar_protocol_v1.aleo/verify.future;
    input r1 as izar_token.aleo/mint_public.future;
    await r0;
    await r1;


function cross_public:
    input r0 as IzarCrossMsg.public;
    sub r0.amount r0.fee into r1;
    call izar_token.aleo/burn_public self.caller r1 r0.token_id into r2;
    call izar_token.aleo/mint_public aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns r0.fee r0.token_id into r3;
    async cross_public r2 r3 into r4;
    output r4 as izar_token_proxy_v1.aleo/cross_public.future;

finalize cross_public:
    input r0 as izar_token.aleo/burn_public.future;
    input r1 as izar_token.aleo/mint_public.future;
    await r0;
    await r1;


function upgrade:
    input r0 as address.public;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    call izar_token.aleo/transfer_ownership r0 into r1;
    async upgrade r1 into r2;
    output r2 as izar_token_proxy_v1.aleo/upgrade.future;

finalize upgrade:
    input r0 as izar_token.aleo/transfer_ownership.future;
    await r0;

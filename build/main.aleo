import izar_protocol_v1.aleo;
import izar_token.aleo;
program izar_token_proxy_v1.aleo;



struct Nonce:
    chain_id as u32;
    nonce as u128;

struct IzarRecvMsg:
    protocol_addr as address;
    nonce as u128;
    to_addr as address;
    from_chain_id as u32;
    from_asset_addr as field;
    token_id as u32;
    amount as u128;

struct IzarCrossMsg:
    to_chain_id as u32;
    to_addr as field;
    to_asset_addr as field;
    token_id as u32;
    amount as u128;
    fee as u128;


struct Account:
    holder as address;
    token_id as u32;

struct IzarTokenMeta:
    token_id as u32;
    from_chain_id as u32;
    from_asset_addr as field;






function receive_payload:
    input r0 as [signature; 20u32].private;
    input r1 as [address; 20u32].private;
    input r2 as IzarRecvMsg.private;
    call izar_token.aleo/verify_token r2.token_id r2.from_chain_id r2.from_asset_addr into r3;
    call izar_protocol_v1.aleo/verify r0 r1 r2 into r4;
    call izar_token.aleo/mint_public r2.to_addr r2.amount r2.token_id into r5;
    async receive_payload r3 r4 r5 into r6;
    output r6 as izar_token_proxy_v1.aleo/receive_payload.future;

finalize receive_payload:
    input r0 as izar_token.aleo/verify_token.future;
    input r1 as izar_protocol_v1.aleo/verify.future;
    input r2 as izar_token.aleo/mint_public.future;
    await r0;
    await r1;
    await r2;


function cross_public:
    input r0 as IzarCrossMsg.public;
    call izar_token.aleo/verify_token r0.token_id r0.to_chain_id r0.to_asset_addr into r1;
    call izar_token.aleo/burn_public self.caller r0.amount r0.token_id into r2;
    call izar_token.aleo/mint_public aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns r0.fee r0.token_id into r3;
    async cross_public r1 r2 r3 into r4;
    output r4 as izar_token_proxy_v1.aleo/cross_public.future;

finalize cross_public:
    input r0 as izar_token.aleo/verify_token.future;
    input r1 as izar_token.aleo/burn_public.future;
    input r2 as izar_token.aleo/mint_public.future;
    await r0;
    await r1;
    await r2;


function upgrade:
    input r0 as address.public;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    call izar_token.aleo/transfer_ownership r0 into r1;
    async upgrade r1 into r2;
    output r2 as izar_token_proxy_v1.aleo/upgrade.future;

finalize upgrade:
    input r0 as izar_token.aleo/transfer_ownership.future;
    await r0;


function proxy_regist_token:
    input r0 as IzarTokenMeta.private;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    call izar_token.aleo/regist_token r0 into r1;
    async proxy_regist_token r1 into r2;
    output r2 as izar_token_proxy_v1.aleo/proxy_regist_token.future;

finalize proxy_regist_token:
    input r0 as izar_token.aleo/regist_token.future;
    await r0;

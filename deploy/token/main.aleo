program izar_token.aleo;

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

record IzarToken:
    owner as address.private;
    amount as u128.private;
    token_id as u32.private;


mapping accounts:
	key as Account.public;
	value as u128.public;


mapping contract_owner:
	key as boolean.public;
	value as address.public;


mapping initialed:
	key as boolean.public;
	value as boolean.public;

function initial:
    input r0 as address.private;
    async initial r0 into r1;
    output r1 as izar_token.aleo/initial.future;

finalize initial:
    input r0 as address.public;
    get.or_use initialed[true] false into r1;
    not r1 into r2;
    assert.eq r2 true;
    set r0 into contract_owner[true];
    set true into initialed[true];


function transfer_ownership:
    input r0 as address.private;
    async transfer_ownership self.caller r0 into r1;
    output r1 as izar_token.aleo/transfer_ownership.future;

finalize transfer_ownership:
    input r0 as address.public;
    input r1 as address.public;
    get.or_use initialed[true] false into r2;
    assert.eq r2 true;
    get contract_owner[true] into r3;
    assert.eq r3 r0;
    set r1 into contract_owner[true];


function mint_public:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as u32.public;
    cast r0 r2 into r3 as Account;
    async mint_public r3 r1 self.caller into r4;
    output r4 as izar_token.aleo/mint_public.future;

finalize mint_public:
    input r0 as Account.public;
    input r1 as u128.public;
    input r2 as address.public;
    get contract_owner[true] into r3;
    assert.eq r3 r2;
    get.or_use accounts[r0] 0u128 into r4;
    add r4 r1 into r5;
    set r5 into accounts[r0];


function mint_private:
    input r0 as address.private;
    input r1 as u128.private;
    input r2 as u32.private;
    cast r0 r1 r2 into r3 as IzarToken.record;
    async mint_private self.caller into r4;
    output r3 as IzarToken.record;
    output r4 as izar_token.aleo/mint_private.future;

finalize mint_private:
    input r0 as address.public;
    get contract_owner[true] into r1;
    assert.eq r1 r0;


function burn_public:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as u32.public;
    cast r0 r2 into r3 as Account;
    async burn_public r3 r1 self.caller into r4;
    output r4 as izar_token.aleo/burn_public.future;

finalize burn_public:
    input r0 as Account.public;
    input r1 as u128.public;
    input r2 as address.public;
    get contract_owner[true] into r3;
    assert.eq r3 r2;
    get.or_use accounts[r0] 0u128 into r4;
    sub r4 r1 into r5;
    set r5 into accounts[r0];


function burn_private:
    input r0 as address.private;
    input r1 as IzarToken.record;
    input r2 as u128.private;
    sub r1.amount r2 into r3;
    cast r1.owner r3 r1.token_id into r4 as IzarToken.record;
    async burn_private self.caller into r5;
    output r4 as IzarToken.record;
    output r5 as izar_token.aleo/burn_private.future;

finalize burn_private:
    input r0 as address.public;
    get contract_owner[true] into r1;
    assert.eq r1 r0;


function transfer_public:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as u32.public;
    cast self.caller r2 into r3 as Account;
    cast r0 r2 into r4 as Account;
    async transfer_public r3 r4 r1 into r5;
    output r5 as izar_token.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as Account.public;
    input r1 as Account.public;
    input r2 as u128.public;
    get.or_use accounts[r0] 0u128 into r3;
    sub r3 r2 into r4;
    set r4 into accounts[r0];
    get.or_use accounts[r1] 0u128 into r5;
    add r5 r2 into r6;
    set r6 into accounts[r1];


function transfer_private:
    input r0 as IzarToken.record;
    input r1 as address.private;
    input r2 as u128.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 r0.token_id into r4 as IzarToken.record;
    cast r1 r2 r0.token_id into r5 as IzarToken.record;
    output r4 as IzarToken.record;
    output r5 as IzarToken.record;


function transfer_private_to_public:
    input r0 as IzarToken.record;
    input r1 as address.public;
    input r2 as u128.public;
    sub r0.amount r2 into r3;
    cast r0.owner r3 r0.token_id into r4 as IzarToken.record;
    cast r1 r0.token_id into r5 as Account;
    async transfer_private_to_public r5 r2 into r6;
    output r4 as IzarToken.record;
    output r6 as izar_token.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as Account.public;
    input r1 as u128.public;
    get.or_use accounts[r0] 0u128 into r2;
    add r2 r1 into r3;
    set r3 into accounts[r0];


function transfer_public_to_private:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as u32.public;
    cast r0 r1 r2 into r3 as IzarToken.record;
    cast self.caller r2 into r4 as Account;
    async transfer_public_to_private r4 r1 into r5;
    output r3 as IzarToken.record;
    output r5 as izar_token.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as Account.public;
    input r1 as u128.public;
    get.or_use accounts[r0] 0u128 into r2;
    sub r2 r1 into r3;
    set r3 into accounts[r0];

program zk_goerli_eth.aleo;

record token:
    owner as address.private;
    amount as u128.private;


mapping account:
	key as address.public;
	value as u128.public;


mapping contract_ownership:
	key as boolean.public;
	value as address.public;


mapping initialed:
	key as boolean.public;
	value as boolean.public;

function initial:
    input r0 as address.private;
    async initial r0 into r1;
    output r1 as zk_goerli_eth.aleo/initial.future;

finalize initial:
    input r0 as address.public;
    get.or_use initialed[true] false into r1;
    assert.eq r1 false;
    set r0 into contract_ownership[true];
    set true into initialed[true];


function transfer_ownership:
    input r0 as address.private;
    async transfer_ownership r0 self.caller into r1;
    output r1 as zk_goerli_eth.aleo/transfer_ownership.future;

finalize transfer_ownership:
    input r0 as address.public;
    input r1 as address.public;
    get.or_use initialed[true] false into r2;
    assert.eq r2 true;
    get contract_ownership[true] into r3;
    assert.eq r3 r1;
    set r0 into contract_ownership[true];


function mint_public:
    input r0 as address.public;
    input r1 as u128.public;
    async mint_public r0 r1 self.caller into r2;
    output r2 as zk_goerli_eth.aleo/mint_public.future;

finalize mint_public:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as address.public;
    get contract_ownership[true] into r3;
    assert.eq r3 r2;
    get.or_use account[r0] 0u128 into r4;
    add r4 r1 into r5;
    set r5 into account[r0];


function mint_private:
    input r0 as address.private;
    input r1 as u128.private;
    cast r0 r1 into r2 as token.record;
    async mint_private self.caller into r3;
    output r2 as token.record;
    output r3 as zk_goerli_eth.aleo/mint_private.future;

finalize mint_private:
    input r0 as address.public;
    get contract_ownership[true] into r1;
    assert.eq r1 r0;


function burn_public:
    input r0 as address.public;
    input r1 as u128.public;
    async burn_public r0 r1 self.caller into r2;
    output r2 as zk_goerli_eth.aleo/burn_public.future;

finalize burn_public:
    input r0 as address.public;
    input r1 as u128.public;
    input r2 as address.public;
    get contract_ownership[true] into r3;
    assert.eq r3 r2;
    get.or_use account[r0] 0u128 into r4;
    sub r4 r1 into r5;
    set r5 into account[r0];


function burn_private:
    input r0 as address.private;
    input r1 as token.record;
    input r2 as u128.private;
    sub r1.amount r2 into r3;
    cast r1.owner r3 into r4 as token.record;
    async burn_private self.caller into r5;
    output r4 as token.record;
    output r5 as zk_goerli_eth.aleo/burn_private.future;

finalize burn_private:
    input r0 as address.public;
    get contract_ownership[true] into r1;
    assert.eq r1 r0;


function transfer_public:
    input r0 as address.public;
    input r1 as u128.public;
    async transfer_public self.caller r0 r1 into r2;
    output r2 as zk_goerli_eth.aleo/transfer_public.future;

finalize transfer_public:
    input r0 as address.public;
    input r1 as address.public;
    input r2 as u128.public;
    get.or_use account[r0] 0u128 into r3;
    sub r3 r2 into r4;
    set r4 into account[r0];
    get.or_use account[r1] 0u128 into r5;
    add r5 r2 into r6;
    set r6 into account[r1];


function transfer_private:
    input r0 as token.record;
    input r1 as address.private;
    input r2 as u128.private;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as token.record;
    cast r1 r2 into r5 as token.record;
    output r4 as token.record;
    output r5 as token.record;


function transfer_private_to_public:
    input r0 as token.record;
    input r1 as address.public;
    input r2 as u128.public;
    sub r0.amount r2 into r3;
    cast r0.owner r3 into r4 as token.record;
    async transfer_private_to_public r1 r2 into r5;
    output r4 as token.record;
    output r5 as zk_goerli_eth.aleo/transfer_private_to_public.future;

finalize transfer_private_to_public:
    input r0 as address.public;
    input r1 as u128.public;
    get.or_use account[r0] 0u128 into r2;
    add r2 r1 into r3;
    set r3 into account[r0];


function transfer_public_to_private:
    input r0 as address.public;
    input r1 as u128.public;
    cast r0 r1 into r2 as token.record;
    async transfer_public_to_private self.caller r1 into r3;
    output r2 as token.record;
    output r3 as zk_goerli_eth.aleo/transfer_public_to_private.future;

finalize transfer_public_to_private:
    input r0 as address.public;
    input r1 as u128.public;
    get.or_use account[r0] 0u128 into r2;
    sub r2 r1 into r3;
    set r3 into account[r0];

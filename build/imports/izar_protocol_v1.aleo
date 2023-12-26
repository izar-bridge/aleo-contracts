program izar_protocol_v1.aleo;

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


mapping izar_keeper:
	key as boolean.public;
	value as [address; 20u32].public;


mapping izar_digest:
	key as boolean.public;
	value as scalar.public;


mapping izar_config:
	key as u8.public;
	value as u32.public;


mapping nonces:
	key as Nonce.public;
	value as boolean.public;







function update_keeper:
    input r0 as [address; 20u32].private;
    assert.eq self.caller aleo1yu6ssnehj4plgznatenfut3hkrfus26kqd226k99wfx79jqmsuxqfernns;
    hash.psd8 r0 into r1 as scalar;
    async update_keeper r0 r1 into r2;
    output r2 as izar_protocol_v1.aleo/update_keeper.future;

finalize update_keeper:
    input r0 as [address; 20u32].public;
    input r1 as scalar.public;
    is.neq r0[0u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r2;
    add 0u32 1u32 into r3;
    ternary r2 r3 0u32 into r4;
    is.neq r0[1u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r5;
    add r4 1u32 into r6;
    ternary r5 r6 r4 into r7;
    is.neq r0[2u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r8;
    add r7 1u32 into r9;
    ternary r8 r9 r7 into r10;
    is.neq r0[3u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r11;
    add r10 1u32 into r12;
    ternary r11 r12 r10 into r13;
    is.neq r0[4u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r14;
    add r13 1u32 into r15;
    ternary r14 r15 r13 into r16;
    is.neq r0[5u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r17;
    add r16 1u32 into r18;
    ternary r17 r18 r16 into r19;
    is.neq r0[6u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r20;
    add r19 1u32 into r21;
    ternary r20 r21 r19 into r22;
    is.neq r0[7u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r23;
    add r22 1u32 into r24;
    ternary r23 r24 r22 into r25;
    is.neq r0[8u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r26;
    add r25 1u32 into r27;
    ternary r26 r27 r25 into r28;
    is.neq r0[9u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r29;
    add r28 1u32 into r30;
    ternary r29 r30 r28 into r31;
    is.neq r0[10u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r32;
    add r31 1u32 into r33;
    ternary r32 r33 r31 into r34;
    is.neq r0[11u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r35;
    add r34 1u32 into r36;
    ternary r35 r36 r34 into r37;
    is.neq r0[12u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r38;
    add r37 1u32 into r39;
    ternary r38 r39 r37 into r40;
    is.neq r0[13u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r41;
    add r40 1u32 into r42;
    ternary r41 r42 r40 into r43;
    is.neq r0[14u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r44;
    add r43 1u32 into r45;
    ternary r44 r45 r43 into r46;
    is.neq r0[15u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r47;
    add r46 1u32 into r48;
    ternary r47 r48 r46 into r49;
    is.neq r0[16u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r50;
    add r49 1u32 into r51;
    ternary r50 r51 r49 into r52;
    is.neq r0[17u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r53;
    add r52 1u32 into r54;
    ternary r53 r54 r52 into r55;
    is.neq r0[18u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r56;
    add r55 1u32 into r57;
    ternary r56 r57 r55 into r58;
    is.neq r0[19u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r59;
    add r58 1u32 into r60;
    ternary r59 r60 r58 into r61;
    set r0 into izar_keeper[true];
    set r61 into izar_config[1u8];
    set r1 into izar_digest[true];


closure verify_sigs:
    input r0 as [address; 20u32];
    input r1 as [signature; 20u32];
    input r2 as IzarRecvMsg;
    is.neq r0[0u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r3;
    sign.verify r1[0u32] r0[0u32] r2 into r4;
    add 0u32 1u32 into r5;
    ternary r4 r5 0u32 into r6;
    ternary r3 r6 0u32 into r7;
    is.neq r0[1u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r8;
    sign.verify r1[1u32] r0[1u32] r2 into r9;
    add r7 1u32 into r10;
    ternary r9 r10 r7 into r11;
    ternary r8 r11 r7 into r12;
    is.neq r0[2u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r13;
    sign.verify r1[2u32] r0[2u32] r2 into r14;
    add r12 1u32 into r15;
    ternary r14 r15 r12 into r16;
    ternary r13 r16 r12 into r17;
    is.neq r0[3u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r18;
    sign.verify r1[3u32] r0[3u32] r2 into r19;
    add r17 1u32 into r20;
    ternary r19 r20 r17 into r21;
    ternary r18 r21 r17 into r22;
    is.neq r0[4u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r23;
    sign.verify r1[4u32] r0[4u32] r2 into r24;
    add r22 1u32 into r25;
    ternary r24 r25 r22 into r26;
    ternary r23 r26 r22 into r27;
    is.neq r0[5u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r28;
    sign.verify r1[5u32] r0[5u32] r2 into r29;
    add r27 1u32 into r30;
    ternary r29 r30 r27 into r31;
    ternary r28 r31 r27 into r32;
    is.neq r0[6u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r33;
    sign.verify r1[6u32] r0[6u32] r2 into r34;
    add r32 1u32 into r35;
    ternary r34 r35 r32 into r36;
    ternary r33 r36 r32 into r37;
    is.neq r0[7u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r38;
    sign.verify r1[7u32] r0[7u32] r2 into r39;
    add r37 1u32 into r40;
    ternary r39 r40 r37 into r41;
    ternary r38 r41 r37 into r42;
    is.neq r0[8u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r43;
    sign.verify r1[8u32] r0[8u32] r2 into r44;
    add r42 1u32 into r45;
    ternary r44 r45 r42 into r46;
    ternary r43 r46 r42 into r47;
    is.neq r0[9u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r48;
    sign.verify r1[9u32] r0[9u32] r2 into r49;
    add r47 1u32 into r50;
    ternary r49 r50 r47 into r51;
    ternary r48 r51 r47 into r52;
    is.neq r0[10u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r53;
    sign.verify r1[10u32] r0[10u32] r2 into r54;
    add r52 1u32 into r55;
    ternary r54 r55 r52 into r56;
    ternary r53 r56 r52 into r57;
    is.neq r0[11u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r58;
    sign.verify r1[11u32] r0[11u32] r2 into r59;
    add r57 1u32 into r60;
    ternary r59 r60 r57 into r61;
    ternary r58 r61 r57 into r62;
    is.neq r0[12u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r63;
    sign.verify r1[12u32] r0[12u32] r2 into r64;
    add r62 1u32 into r65;
    ternary r64 r65 r62 into r66;
    ternary r63 r66 r62 into r67;
    is.neq r0[13u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r68;
    sign.verify r1[13u32] r0[13u32] r2 into r69;
    add r67 1u32 into r70;
    ternary r69 r70 r67 into r71;
    ternary r68 r71 r67 into r72;
    is.neq r0[14u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r73;
    sign.verify r1[14u32] r0[14u32] r2 into r74;
    add r72 1u32 into r75;
    ternary r74 r75 r72 into r76;
    ternary r73 r76 r72 into r77;
    is.neq r0[15u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r78;
    sign.verify r1[15u32] r0[15u32] r2 into r79;
    add r77 1u32 into r80;
    ternary r79 r80 r77 into r81;
    ternary r78 r81 r77 into r82;
    is.neq r0[16u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r83;
    sign.verify r1[16u32] r0[16u32] r2 into r84;
    add r82 1u32 into r85;
    ternary r84 r85 r82 into r86;
    ternary r83 r86 r82 into r87;
    is.neq r0[17u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r88;
    sign.verify r1[17u32] r0[17u32] r2 into r89;
    add r87 1u32 into r90;
    ternary r89 r90 r87 into r91;
    ternary r88 r91 r87 into r92;
    is.neq r0[18u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r93;
    sign.verify r1[18u32] r0[18u32] r2 into r94;
    add r92 1u32 into r95;
    ternary r94 r95 r92 into r96;
    ternary r93 r96 r92 into r97;
    is.neq r0[19u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r98;
    sign.verify r1[19u32] r0[19u32] r2 into r99;
    add r97 1u32 into r100;
    ternary r99 r100 r97 into r101;
    ternary r98 r101 r97 into r102;
    hash.psd8 r0 into r103 as scalar;
    output r103 as scalar;
    output r102 as u32;


function verify:
    input r0 as [signature; 20u32].private;
    input r1 as [address; 20u32].private;
    input r2 as IzarRecvMsg.private;
    assert.eq r2.protocol_addr aleo1e5szs84jql2hn08ffxc7yn97wa8s9vk7jgshcddxmaekdxh85upsdt8p9g;
    call verify_sigs r1 r0 r2 into r3 r4;
    cast r2.from_chain_id r2.nonce into r5 as Nonce;
    async verify r5 r3 r4 into r6;
    output r6 as izar_protocol_v1.aleo/verify.future;

finalize verify:
    input r0 as Nonce.public;
    input r1 as scalar.public;
    input r2 as u32.public;
    get.or_use nonces[r0] false into r3;
    not r3 into r4;
    assert.eq r4 true;
    get izar_digest[true] into r5;
    is.eq r1 r5 into r6;
    assert.eq r6 true;
    get izar_config[1u8] into r7;
    sub r7 1u32 into r8;
    div r8 3u32 into r9;
    sub r7 r9 into r10;
    gte r2 r10 into r11;
    assert.eq r11 true;
    set true into nonces[r0];

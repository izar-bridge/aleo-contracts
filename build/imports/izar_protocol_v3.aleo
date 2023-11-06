program izar_protocol_v3.aleo;

struct Nonce:
    chain_id as u32;
    nonce as u128;

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
    async update_keeper r0 into r1;
    output r1 as izar_protocol_v3.aleo/update_keeper.future;

finalize update_keeper:
    input r0 as [address; 20u32].public;
    is.neq r0[0u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r1;
    add 0u32 1u32 into r2;
    ternary r1 r2 0u32 into r3;
    is.neq r0[1u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r4;
    add r3 1u32 into r5;
    ternary r4 r5 r3 into r6;
    is.neq r0[2u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r7;
    add r6 1u32 into r8;
    ternary r7 r8 r6 into r9;
    is.neq r0[3u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r10;
    add r9 1u32 into r11;
    ternary r10 r11 r9 into r12;
    is.neq r0[4u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r13;
    add r12 1u32 into r14;
    ternary r13 r14 r12 into r15;
    is.neq r0[5u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r16;
    add r15 1u32 into r17;
    ternary r16 r17 r15 into r18;
    is.neq r0[6u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r19;
    add r18 1u32 into r20;
    ternary r19 r20 r18 into r21;
    is.neq r0[7u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r22;
    add r21 1u32 into r23;
    ternary r22 r23 r21 into r24;
    is.neq r0[8u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r25;
    add r24 1u32 into r26;
    ternary r25 r26 r24 into r27;
    is.neq r0[9u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r28;
    add r27 1u32 into r29;
    ternary r28 r29 r27 into r30;
    is.neq r0[10u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r31;
    add r30 1u32 into r32;
    ternary r31 r32 r30 into r33;
    is.neq r0[11u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r34;
    add r33 1u32 into r35;
    ternary r34 r35 r33 into r36;
    is.neq r0[12u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r37;
    add r36 1u32 into r38;
    ternary r37 r38 r36 into r39;
    is.neq r0[13u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r40;
    add r39 1u32 into r41;
    ternary r40 r41 r39 into r42;
    is.neq r0[14u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r43;
    add r42 1u32 into r44;
    ternary r43 r44 r42 into r45;
    is.neq r0[15u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r46;
    add r45 1u32 into r47;
    ternary r46 r47 r45 into r48;
    is.neq r0[16u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r49;
    add r48 1u32 into r50;
    ternary r49 r50 r48 into r51;
    is.neq r0[17u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r52;
    add r51 1u32 into r53;
    ternary r52 r53 r51 into r54;
    is.neq r0[18u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r55;
    add r54 1u32 into r56;
    ternary r55 r56 r54 into r57;
    is.neq r0[19u32] aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc into r58;
    add r57 1u32 into r59;
    ternary r58 r59 r57 into r60;
    set r0 into izar_keeper[true];
    set r60 into izar_config[1u8];


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
    call verify_sigs r1 r0 r2 into r3 r4;
    cast r2.from_chain_id r2.nonce into r5 as Nonce;
    async verify r5 r3 r4 into r6;
    output r6 as izar_protocol_v3.aleo/verify.future;

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
    div r7 3u32 into r8;
    mul r8 2u32 into r9;
    gte r2 r9 into r10;
    assert.eq r10 true;
    set true into nonces[r0];

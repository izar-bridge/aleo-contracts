// The 'izar' program.
program izar_sign.aleo {
    struct Signature {
        challenge: scalar,
        response: scalar,
        pk_sig: group,
        pr_sig: group,
        sk_prf: scalar,
    }

    struct Msg8 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
    }

    struct Msg16 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
        m8: field,
        m9: field,
        m10: field,
        m11: field,
        m12: field,
        m13: field,
        m14: field,
        m15: field,
    }

    struct Msg32 {
        m0: field,
        m1: field,
        m2: field,
        m3: field,
        m4: field,
        m5: field,
        m6: field,
        m7: field,
        m8: field,
        m9: field,
        m10: field,
        m11: field,
        m12: field,
        m13: field,
        m14: field,
        m15: field,
        m16: field,
        m17: field,
        m18: field,
        m19: field,
        m20: field,
        m21: field,
        m22: field,
        m23: field,
        m24: field,
        m25: field,
        m26: field,
        m27: field,
        m28: field,
        m29: field,
        m30: field,
        m31: field,
    }

    function verify_msg8 (sig: Signature, addr: address, msg: Msg8, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }

    function verify_msg16 (sig: Signature, addr: address, msg: Msg16, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }

    function verify_msg32 (sig: Signature, addr: address, msg: Msg32, addr_g: group) -> bool {
        let g_r: group = group::GEN * sig.response + sig.pk_sig * sig.challenge;

        let g_r_hash: scalar = Poseidon8::hash_to_scalar(g_r);
        let pk_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pk_sig);
        let pr_sig_hash: scalar = Poseidon8::hash_to_scalar(sig.pr_sig);
        let addr_hash: scalar = Poseidon8::hash_to_scalar(addr);
        let msg_hash: scalar = Poseidon8::hash_to_scalar(msg);

        let candidate_challenge: scalar = g_r_hash + pk_sig_hash + pr_sig_hash + addr_hash + msg_hash;

        let g_addr: group = sig.pk_sig + sig.pr_sig + group::GEN * sig.sk_prf;
        let flag1: bool = g_addr == addr_g;
        let flag2: bool = sig.challenge == candidate_challenge;
        return flag1 && flag2;
    }
}

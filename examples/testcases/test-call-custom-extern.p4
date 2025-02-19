// SPDX-License-Identifier: Apache-2.0
// Copyright 2021 Eotvos Lorand University, Budapest, Hungary

#include "common-boilerplate-pre.p4"

struct metadata {
}

struct headers {
    ethernet_t ethernet;
}

PARSER {
    state start {
        packet.extract(hdr.ethernet);
        transition accept;
    }
}

extern void dummy_crypto();
extern void dummy_crypto<T1>(in T1 data1);
extern void dummy_crypto<T1,T2>(in T1 data1, in T2 data2);

CTL_MAIN {
    apply {
        dummy_crypto();
        dummy_crypto({8w1});
        dummy_crypto({-8w1});
        dummy_crypto({8w1}, {8w1});
        dummy_crypto({-8w1}, {-8w1});
        dummy_crypto({16w1}, {32w1});
        dummy_crypto({-16w1}, {-32w1});

        dummy_crypto(8w1);
        dummy_crypto(8w0xAB);
        dummy_crypto(-8w1);

        dummy_crypto(16w1);
        dummy_crypto(16w0xABCD);
        dummy_crypto(-16w1);

        dummy_crypto(32w1);
        dummy_crypto(32w0xFEDCBA98);
        dummy_crypto(32w0x76543210);
        dummy_crypto(-32w1);
        dummy_crypto(32w0x1234);

        dummy_crypto(64w0xFEDCBA9876543210);

        // TODO properly implement these cases, too
        // dummy_crypto(hdr.ethernet.srcAddr);
        // dummy_crypto(hdr.ethernet.dstAddr);
        // dummy_crypto(hdr.ethernet.etherType);
        // dummy_crypto(hdr.ethernet);

        dummy_crypto({hdr.ethernet});
    }
}

CTL_EMIT {
    apply {
        packet.emit(hdr.ethernet);
    }
}

#include "common-boilerplate-post.p4"

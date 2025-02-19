#include "common-boilerplate-pre.p4"

struct metadata {
	bit<28> addr1;	
}

header dummy_t {
	bit<28> addr1;
	bit<4> padding;
}

struct headers {
    dummy_t dummy;
}

PARSER {
    state start {
        packet.extract(hdr.dummy);
        transition accept;
    }
}

CTL_MAIN {
	const bit<28> addr2 = 0x1234568;
	bit<28> addr3 = 1;

    action action1(bit<28> data) { hdr.dummy.addr1 = data + 28w1; }
    action action2()             { meta.addr1 = 0x1234678 + 28w1; }
    action action3()             { meta.addr1 = addr2 + 28w1; }
    action action4(bit<28> data) { addr3 = data + 28w1; }
    action action5(bit<28> data) { meta.addr1 = data + 28w1; }
    
    table t1 {
        actions = {
            action1;
            action2;
            action3;
            action4;
            action5;
        }

        key = {
            hdr.dummy.addr1: exact;
        }

        size = 3;

        const entries = {
            (0x1234567) : action1(0x1234568);
            (0x1234561) : action2();
            (0x1234562) : action1(addr2);
            (0x1234563) : action3();
            (0x1234564) : action4(0x1234567);
            (0x1234565) : action5(0x1234568);
        }
    }

    apply {
		t1.apply();
    }
}

CTL_EMIT {
    apply {
        packet.emit(hdr.dummy);
    }
}

#include "common-boilerplate-post.p4"

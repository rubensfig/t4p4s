#include "common-boilerplate-pre.p4"

header dummy_t {
    bit<2> f1;
    bit<2> f2;
    bit<4> padding;
}

struct metadata {
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
    action a() { 
	hdr.dummy.f1 = (bit<2>)3;
	hdr.dummy.f2 = (bit<2>)3; 
    }

    table dummy_table {
        key = {}
        actions = {
		a;
        }
    }

    apply {
       switch (dummy_table.apply().action_run) {
		default: {
			a();
		}
       }
    }
}


CTL_EMIT {
    apply {
        packet.emit(hdr.dummy);
    }
}

#include "common-boilerplate-post.p4"

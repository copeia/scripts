#!/usr/bin/env python

import dns.resolver

answers = dns.resolver.query('dnspython.org', 'A')
for rdata in answers:
    print 'Host', rdata.exchange, 'has preference', rdata.preference


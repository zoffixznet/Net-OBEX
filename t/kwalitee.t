#!/usr/bin/env perl

use Test::More;

eval { require Test::Kwalitee; Test::Kwalitee->import() };

BEGIN {
    unless ($ENV{RELEASE_TESTING})
    {
        use Test::More;
        plan(skip_all => 'these tests are for release candidate testing');
    }
}
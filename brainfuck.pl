#!/usr/bin/perl

use 5.010000;
use strict;
use warnings;

use CGI;
use Readonly;

# CGI setup, brainfuck code extraction from request
my $request = CGI->new();
my $brainfuckCode = $request->param("code");

# Brainfuck interpreter subprocedure.
sub run {
    my ($code, $loop, $dp, $ip, $time, @tape) = (
        shift, 0,     0,   0,   0,     (0)
    );
    
    for (; $ip < length $code; $ip++) {
        my $instr = substr($code, $ip, 1);
        
        if ($dp > 256) {
            print "Memory limit exceeded.";
            exit;
        }
        
        if ($time > 99999) {
            print "Time limit exceeded.";
            exit;
        }
        
        given ($instr) {
            when ('>') { $dp++ }
            when ('<') { $dp-- if $dp }
            when ('+') { $tape[$dp]++ }
            when ('-') { $tape[$dp]-- }
            when ('.') { print $tape[$dp] }
            when (',') { $tape[$dp] = 0 }
            when ('[') {
                $loop++ if $tape[$dp];
                if ($tape[$dp] == 0) {
                    $loop--;
                    while (substr($code, $ip, 1) ne ']') { $ip++; }
                }
            }
            when (']') {
                next if $loop == 1 && $tape[$dp] == 0;
                while ($loop > 0 && substr($code, $ip, 1) ne '[') { $ip--; }
                $ip--;
            }
        }
        
        $time++;
    }
}

# If there was no code parameter or CGI was requested
# using GET method, return status code 400
# (invalid request)

if(not defined $brainfuckCode) {
    print $request->header(-status => 400);
    print $request->start_html;
    print $request->h1("400: Invalid request");
    print $request->div("Expected 'code' POST parameter.");
    print $request->end_html;
} elsif($request->request_method() eq "GET") {
    print $request->header(-status => 400);
    print $request->start_html;
    print $request->h1("400: Invalid request");
    print $request->div("Expected request using POST method.");
    print $request->end_html;
} else {
    print $request->header("text/plain");
    print run($brainfuckCode);
}


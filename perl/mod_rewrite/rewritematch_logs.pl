#!/usr/bin/env perl

if ($#ARGV + 1 != 3 ) {
    print STDERR "\tUsage: rewritematch_logs.pl access_log rewrite_config outfile\n";
    exit 1;
}

open (LOGFILE, "$ARGV[0]") || die "  Error opening log file $ARGV[0].\n";
open (REWRITEFILE, "$ARGV[1]") || die "  Error opening rewrite config file $ARGV[1].\n";
open (OUTFILE, ">$ARGV[2]") || die "  Error opening output file $ARGV[2].\n";

@keywords = ();
while (chomp ($line = <REWRITEFILE>)) {
    if ($line =~ /^[^#].*HTTP_USER_AGENT[^ ] (.*) \[.*\].*$/) {
        push (@keywords, $1);
    }
}
close (REWRITEFILE);

$hits = 0;
while (<LOGFILE>) {
    chomp;
    s/\s+/ /go; #replace multiple spaces with one
    @logline = /^(\S+) (\S+) (\S+) \[(.+)\] \"(.+)\" (\S+) (\S+) \"(.*)\" \"(.*)\"/o;
    @match = ();
    foreach $keyword (@keywords) {
        if ($keyword =~ /^!/) {
            #exclusions
            $excludekeyword = substr ($keyword, 1);
            if ($logline[8] =~ /$excludekeyword/i) {
                #bail out and go to next log line. we matched a word that is excluded
                last;
            }
        }
        else {
            #inclusions
            if ($logline[8] =~ /$keyword/i) {
                #we matched an inclusion, mark it
                push (@match, $keyword);
            }
        }
    }
    if ($#match + 1 > 0) {
        #we've got matches, print'em
        print OUTFILE "$logline[8]\n";
        print OUTFILE "  " . join (' : ', @match) . "\n";
        print OUTFILE "\n";
        $hits++;
    }
}
print "Redirect Hits: $hits\n";
close (OUTFILE);
close (LOGFILE);

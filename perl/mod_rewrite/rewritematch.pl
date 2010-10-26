#!/usr/bin/env perl

if ($#ARGV + 1 != 3 ) {
    print STDERR "\tUsage: rewritematch.pl useragent_list rewrite_config outfile\n";
    exit 1;
}

open (UAFILE, "$ARGV[0]") || die "  Error opening log file $ARGV[0].\n";
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
while (<UAFILE>) {
    chomp;
    $useragent = $_;
    @match = ();
    foreach $keyword (@keywords) {
        if ($keyword =~ /^!/) {
            #exclusions
            $excludekeyword = substr ($keyword, 1);
            if ($useragent =~ /$excludekeyword/i) {
                #bail out and go to next log line. we matched a word that is excluded
                last;
            }
        }
        else {
            #inclusions
            if ($useragent =~ /$keyword/i) {
                #we matched an inclusion, mark it
                push (@match, $keyword);
            }
        }
    }
    if ($#match + 1 > 0) {
        #we've got matches, print'em
        print OUTFILE "$useragent\n";
        print OUTFILE "  " . join (' : ', @match) . "\n";
        print OUTFILE "\n";
        $hits++;
    }
}
print "Redirect Hits: $hits\n";
close (OUTFILE);
close (UAFILE);

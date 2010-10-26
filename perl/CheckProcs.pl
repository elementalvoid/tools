#!/usr/bin/perl

# CheckProcs.pl - a script to verify that the system is running a
# kernel which matches the installed CPUs and that hyperthreading is
# turned off.  Only for Linux.
#
# Phil Hollenback (philiph_at_pobox_dot_com)
# Telemetry Investments
# 6/18/04

`id -u` == 0 || die "must be run as root";

open(DmiFh, "/usr/sbin/dmidecode |") or
  die "problem running dmidecode";
$DmiNumProcs = 0;
$DmiNumSockets = 0;
while(<DmiFh>)
  {
    next unless /Central Processor/;
    # We've found a processor (or at least a socket), keep going
    while(<DmiFh>)
	{
	  # Keep walking the dmidecode output to find out if
	  # the socket has a processor in it.
	  last if /^Handle/;
	  next unless /Status/;
	  $DmiNumSockets += 1;
	  /Populated/ and $DmiNumProcs += 1;
	  last;
	}
  }
close DmiFh;

open(CpuInfoFh, "/proc/cpuinfo") || die "failed to open /proc/cpuinfo!";
$CpuInfoNumProcs = 0;
while(<CpuInfoFh>)
  {
    next unless /^processor.*:/;
    ($CpuInfoNumProcs) += (/^processor.*: (\d+)/);
  }
close CpuInfoFh;

print "dmidecode reports $DmiNumProcs processor(s), kernel reports $CpuInfoNumProcs processor(s).\n";
print "dmidecode reports $DmiNumSockets cpu socket(s) and $DmiNumProcs processor(s).\n";

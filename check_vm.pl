#!/usr/bin/perl
use JSON qw( decode_json );
use Data::Dump qw(dump);
use Math::Round qw(nearest);


$result = `pvesh get nodes/\`hostname\`/openvz/`;

my $nodes = decode_json($result);
my $statusStr = "";
my $status = 0;

foreach $node ( @{$nodes})
{
   $cpu	      = nearest(.1, $node->{cpu} / $node->{cpus} * 100);
   $disk      = nearest(.1, $node->{disk} / $node->{maxdisk} * 100);
   $mem       = nearest(.1, $node->{mem} / $node->{maxmem} * 100);

   $statusStr .= $node->{name}." : ";
   if ($node->{status} == 'running') {
      $statusStr .= $node->{name}." : ";
      $statusStr .= "CPU ".$cpu."% - ";
      $statusStr .= "Disk ".$disk."% - ";
      $statusStr .= "RAM ".$mem."%";
      $statusStr .= "\n";

      if(cpu > 90 || disk > 85 || mem > 90) {
	$status = 2;
      }
  } else {
      $statusStr .= $node->{name}." : STOPPED";
  }

}

print $statusStr;
exit $status;

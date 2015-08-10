#!/usr/bin/perl

@host_list=("147.2.207.114", "147.2.207.211", "147.2.207.210", "147.2.207.209", "147.2.207.163");

foreach (@host_list) {
    print "Server: $_ ;\n";
    system "sshpass -p susetesting ssh root\@$_ screen -ls" ;
}



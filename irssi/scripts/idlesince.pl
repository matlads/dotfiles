#!/usr/bin/perl

use strict;
use Irssi;
use Time::localtime;

use vars qw($VERSION %IRSSI);

$VERSION = "0.1";
%IRSSI = (
    authors     => "Leszek Matok",
    contact     => "lam\@lac.pl",
    name        => "idlesince",
    description => "Adds 'idle since' line to whois replies.",
    license     => "GPL",
    url         => "",
    changed     => "17.9.2002",
);

sub event_server_event {
    my ($server, $text, $sname) = @_;
    my @items = split(/ /,$text);
    
    my $idlesince = ctime(time()-$items[2]);
    $server->printformat($items[1], MSGLEVEL_CRAP, 'whois_idlesince',
	$items[1], $idlesince );
}

Irssi::theme_register([
    'whois_idlesince' => '{whois idlesince %|$1}'
]);
Irssi::signal_add_last('event 317', 'event_server_event');

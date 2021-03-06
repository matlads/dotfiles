#!/usr/bin/perl
#
# irssi beep with-command-script
# (C) 2003 Remco den Breeje
# inspired by Georg Lukas

# howtoinstall:
#  copy this file to ~/.irssi/scripts/
#  in irssi:
#   $/script load my_beep.pl
#  change the settings
#   $/set beep_msg_level HILIGHT
#   $/set beep_cmd beep 

use strict;
use vars qw($VERSION %IRSSI);
$VERSION = "0.10";
%IRSSI = (
    authors	=> "Remco den Breeje",
    contact	=> "stacium or stek (most of the time) @ quakenet.org",
    name	=> "my_beep",
    description	=> "runs arbitrary command instead of system beep, includes flood protection",
    license	=> "Public Domain",
    url		=> "http://www.xs4all.nl/~stacium/irssi/my_beep.html",
);

use Irssi;

my $can_I_beep = 1;
my ($timeout_tag);

sub beep_overflow_timeout() {
	$can_I_beep = 1;
}

sub my_beep() {
	my $beep_cmd = Irssi::settings_get_str("beep_cmd");
	if ($beep_cmd) {
		my $beep_flood = Irssi::settings_get_int('beep_flood');
		# check on given beep_flood
		if($beep_flood < 0) {
			Irssi::print("Warning! Wrong value for beep_flood (time in milisecs)");
			Irssi::signal_stop();
			return;
		}
		if (defined $timeout_tag) {
			Irssi::timeout_remove($timeout_tag);
			$timeout_tag= undef;
		}
		$timeout_tag = Irssi::timeout_add_once($beep_flood, 'beep_overflow_timeout', undef);
		if ($can_I_beep) {
			$can_I_beep = 0;
			system($beep_cmd);
		}
		Irssi::signal_stop();
	}
}

Irssi::settings_add_str("lookandfeel", "beep_cmd", "echo INeedToBeSet > /dev/null");
Irssi::settings_add_int("lookandfeel", "beep_flood", 2000);
Irssi::signal_add("beep", "my_beep");

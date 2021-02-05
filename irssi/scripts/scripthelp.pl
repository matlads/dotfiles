use strict;
use Irssi;

use vars qw($VERSION %IRSSI %HELP);
$VERSION = "0.10";
%IRSSI = (
	authors         => "Maciek \'fahren\' Freudenheim",
	contact         => "fahren\@bochnia.pl",
	name            => "Scripts help",
	description     => "Provides access to script\'s help",
	license         => "GNU GPLv2 or later",
	changed         => "2019-02-27"
);
$HELP{scripthelp} = "
Provides help for irssi's perl scripts.

All what you have to do is to add
\$HELP{commandname} = \"
    your help goes here
\";
to your script.
";

sub cmd_help {
	my ($args, $server, $win) = @_;

	# from scriptinfo.pl
	for (sort grep s/::$//, keys %Irssi::Script::) {
		no strict 'refs';
		my $help = ${ "Irssi::Script::${_}::HELP" }{$args};
		if ($help) {
			Irssi::signal_stop();
			Irssi::print("$help");
			return;
		}
	}		
}

Irssi::command_bind("help", "cmd_help");

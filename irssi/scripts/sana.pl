# CopyLeft Riku Voipio 2001
# Mofile Bot
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
        authors     => "Riku Voipio",
        contact     => "riku.voipio\@iki.fi",
        name        => "sana",
        description => "responds to \"!sana test\" command on channels/publics with a finnish/english translatioin given as parameter",
        license     => "GPLv2",
        url         => "http://nchip.ukkosenjyly.mine.nu/irssiscripts/",
    );



sub cmd_sana_priv {
        my ($server, $data, $nick, $mask ) =@_;
	return cmd_sana($server, $data, "", $mask, $nick);
}
sub cmd_sana {
        my ($server, $data, $nick, $mask, $target) =@_;
	if ($data=~/^!sana/){
		@foo=split(/\s+/,$data);
		$len=@foo;
		if ($len==1){
		    $foo[1]="aloittelija";
		}
		# Haxxor protection
		$word=$foo[1];
		$_=$word;
		$word=~s/[^a-zA-ZäöÄÖ]//g;	
		open(DAT, "lynx --dump http://212.213.217.194/cgi-bin/mofind.exe/dr1?word=".$word."|");
		$count=0;
		$sucks=0;
		$result="";
		foreach $line (<DAT>)
		{
			if ($line=~/\(.*\)/)
			{
				$_=$line;
				$line=~s/\s+/ /g;
				$_=$line;
				$line=~s/( $|^ )//g;
				$result.=$line.",";
			}
		}
		if (length($result)<2)
		{
 			$result="Ei löydy..";
		}
		 
		chop($result);
		$server->command("/notice ".$target." ".$result);
		close(DAT);
	}
}

Irssi::signal_add_last('message public', 'cmd_sana');
Irssi::signal_add_last('message private', 'cmd_sana_priv');
Irssi::print("Sanakirja info bot by nchip loaded.");



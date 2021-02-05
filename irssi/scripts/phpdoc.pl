# Copyright (C) March, 19th 2002  Author FoxMaSk <odemah@phpfr.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#Requirement : get the file funcsummary.txt from the CVS of http://php.net
use strict;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = "0.0.6";
%IRSSI = (
    authors => 'Foxmask',
    contact => 'odemah@phpfr.org ',
    name => 'PhpDoc',
    description => 'Display all functions of the famous language PHP which is used in the funcsummary.txt file in the CVS of http://php.net',
    license => 'GNU GPL',
    url => 'http://team.gcu-squad.org/~odemah/'
);

#PARMS

#file name that contains all function list and definition
my $doc_file       = "$ENV{HOME}/phpdoc/funcsummary.txt";
my $cmd_php        = "!man";
my @channel_php = ();
$channel_php[0] = "#phpfr";
$channel_php[1] = "#phpfrance";
my $mirror_php     = "http://phpnet.phpfr.org/manual/fr/";
#==========================END OF PARMS======================================

#init array
my @doc = ();
my $x = 0;

#The main function
sub doc_find {
    my ($server, $msg, $nick, $address, $target) = @_;
    
    my $keyword="";
    my $def="";
    my $cmd="";

    #split the *action* and the rest of the line
    ($cmd,$keyword) = split / /,$msg,2;
    
    #to query
    if (lc($cmd) eq $cmd_php and (lc($target) eq $channel_php[0] or lc($target) eq $channel_php[1]) ) {
        if ($keyword eq '') {
            if ( $server->channel_find($target)->nick_find($nick)->{voice} or $server->channel_find($target)->nick_find($nick)->{op} ) {
            $server->command("/msg -$server->{tag} $target $cmd_php: \002$cmd_php <function>\002 example $cmd_php mysql_connect");
	    	} else {
                $server->command("/msg $nick $cmd_php: \002$cmd_php <function>\002 example $cmd_php mysql_connect");
    		}
        }
        else {
         for ($x=0;$x < @doc;$x++) {
          	#ignore comment
                if ( $doc[$x] =~ /^(object|unknown|mixed|class|resource|void|bool|array|string|int) $keyword/)  { 
        	        $def = $doc[$x];
            	    chomp($def);
                    $def =~ s/\s+/ /g;
    	            $keyword =~ s/_/-/g ;
                    $def .= ". More Details on ".$mirror_php ."function.".$keyword.".php"; 
                	last;
                }   
            }

            if ( $def ne '' ) {
    	        $keyword =~ s/-/_/g ;
                #if the user is voice or op ; display the description in the channel
                if ( $server->channel_find($target)->nick_find($nick)->{voice} or $server->channel_find($target)->nick_find($nick)->{op} ) {
                    $server->command("/msg -$server->{tag} $target $def");
        		}
                #else display it to the $nick only
    	    	else {
                    $server->command("/msg $nick \002$keyword\002=$def");
        		}
            }            
                #definition not found ; so we tell it to $nick
            else { 
                $server->command("/msg $nick $keyword does not exist");
                Irssi::signal_stop();
            }
        }
    }
}


#load datas from funcsummary.txt file
sub load_doc {
    my $doc_line="";
    if (-e $doc_file) {
        @doc = ();
        Irssi::print("Loading doc from $doc_file");
        local *DOC; 
        open(DOC,"$doc_file");
        local $/ = "\n";
        while (<DOC>) {
            chomp();
            #ignore comment and get all lines beginning with ... :
            if ( /^(object|unknown|mixed|class|resource|void|bool|array|string|int)/)  { 
        	    #getting the line description
                $doc_line = $_;
                chomp($doc_line);
        	    #getting the line definition
                $doc_line .= <DOC>;
                chomp($doc_line);
                push(@doc,$doc_line);
            }
        }
        close DOC;
		Irssi::print("Loaded " . scalar(@doc) . " record(s)");
	} else {
		Irssi::print("Cannot load $doc_file");
	}
}

load_doc();

Irssi::signal_add_last('message public', 'doc_find');
Irssi::print("Php Doc Management $VERSION loaded!");


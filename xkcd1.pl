#!/opt/local/bin/perl -w

use WWW::Mechanize;
use WWW::Mechanize::Image;
use strict;
system("CLS");


print "Initilizing Script...\n";
my $mech = WWW::Mechanize->new();


foreach my $NUM (1..403) {

my $U="http://xkcd.com/$NUM/";
print "Loading image #$NUM\n";
$mech->get($U);
my $image = $mech->find_image( url_regex => qr/comics/i);
$mech->get($image->url());
print "Saving Image...\n";
$mech->save_content("C:/Documents and

Settings/Owner/Desktop/xkcd/$NUM.png");

}

print "Skipping 404 because of a sick joke...\n";
### Try going to http:://xkcd.com/404/, It was a funny joke until it broke my code... So I just had to make a quick change ###

foreach my $NUM (405..652) {

my $U="http://xkcd.com/$NUM/";
print "Loading image #$NUM\n";
$mech->get($U);
my $image = $mech->find_image( url_regex => qr/comics/i);
$mech->get($image->url());
print "Saving Image...\n";
$mech->save_content("C:/Documents and Settings/Owner/Desktop/xkcd/$NUM.png");
### You can change the path ^ to whatever you want, just make sure they are forward slashes and not backslashes ###
}
print "All Images Downloaded!\n";
print "Have a nice day! =)\n";



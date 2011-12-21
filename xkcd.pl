#!/opt/local/bin/perl
use strict;
use warnings;

use WWW::Mechanize;
use LWP::Simple;

prepareStructure();
downloadImages();

sub prepareStructure {

    if(!-d "comics") {
        system("mkdir comics");

        if(!-W "comics") {
            die "comics/ needs to be writable."
        }
    }

    if(!-e "xkcd.html") {
        system("touch xkcd.html");

        if(!-W "xkcd.html") {
            die "xkcd.html needs to be writable."
        }
    }
}

sub generateHTML {

    my $fn = $_[0];
    my $alt = $_[1];
    my $cn = $_[2];

    my $block = "
    <h1>#$cn - $alt<h1>
    <img src=./$fn>
    <br><br>
    ";

    system("echo '$block' >> xkcd.html");

}

sub downloadImages {

    my $totalComics = getNumberOfComics();
    my $m = WWW::Mechanize->new();

    my $comicNumber=getExistingComics();
    if($comicNumber==0) {
        $comicNumber++;
    }

    for(; $comicNumber<=$totalComics; $comicNumber++) {
        
        if($comicNumber==404) {
            $comicNumber++;
        }

        $m->get("http://xkcd.com/$comicNumber");

        my @comic = $m->find_image(url_regex => qr/http:\/\/imgs.xkcd.com\/comics/i);
        for my $comic ( @comic ) {

            my $url = $comic->url;
            my $fn = $url;
            $fn =~ s/http:\/\/imgs.xkcd.com\///g;
            my $alt = $comic->alt;

            if(!-e $fn) {
                print "Downloading Comic#$comicNumber...\n";

                LWP::Simple::getstore($url, $fn);
                generateHTML($fn, $alt, $comicNumber);
            }
        }

    }

    print "Update complete. Comics are stored in ./comics/ and HTML output in xkcd.html\n\n";
}

sub getExistingComics {
    my $dir='comics';
    my @comics=<$dir/*>;
    my $count = @comics;

    #Number of existing comics in ./comics/
    return $count;
}

sub getNumberOfComics {
    my $m = WWW::Mechanize->new();
    $m->get("http://xkcd.com");
    my $index = $m->text();
    if ($index =~ /http:\/\/xkcd.com\/(\d+)\//) {

        #Total number of Comics. 
        return $1;
    }
    return -1;
}

=head1 NAME

    xkcd - Saves all xkcd comics locally and generates an HTML file containing the 
    downloaded comics for easy viewing. 

=head1 DETAILS
    
    After the initial run of this script, all future times this script is ran it will 
    only download new comics.

=head1 REQUIREMENTS

    Required Modules:
    WWW::Mechanize, LWP::Simple

    Tested With:
    Perl v5.10.1

=head1 AUTHOR
    
    Josh Grochowski (josh[at]kastang[dot]com

=head1 COPYRIGHT

    Copyright (c) 2011 Josh Grochowski (josh[at]kastang[dot]com)
   
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
   
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
   
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

=cut


package Bundler;
use version; our $VERSION = version->declare('v0.0.29');
1;


__END__

=head1 NAME 

Bundler

=head1 Author

Alexey Melezhik / melezhik@gmail.com

=head1 SYNOPSIS

    This is CPANPLUS pluggin. Install/Remove all packages from given `bundle' file.
    Inspired by ruby bundler.

    # in cpanp client session
    /? bundle
    /bundle install # installing
    /bundle remove # removing

=head1 USAGE

    /? bundle
    /bundle [install|remove] [options]


=head1 Format of .bunlde file

every line of .bundle file have a form of `<MODULE-ITEM> [<MINIMAL-VERSION>] [# comments]'

=head1 MODULE-ITEM

what is module item, see parse_module method documentation on http://search.cpan.org/perldoc?CPANPLUS::Backend, in common case it should
be the name of CPAN module to install/remove

=head1 MINIMAL-VERSION

minimal version of module you want to install, if one have version higher or equal module wouldn't be installed.
If minimal version is not set, Bundler would update corresponding module.

=head1 Comments

may occur in and should be started with #

 # this is comment

=head1 Examples of .bundle file

update CGI module to latest version 

 CGI
 
update CGI module to latest version  if current version < 3.58

 CGI 3.58
 
install CGI module only if not installed

 CGI 0
 
install from given url path

 http://search.cpan.org/CPAN/authors/id/M/MA/MARKSTOS/CGI.pm-3.59.tar.gz

=head1 OPTIONS

 --bundle_file # path to bundle file
 --dry-run # dry-run mode - just to show what would happen and to do nothing


=head1 ACKNOWLEDGMENTS

 to the authors of bundler
 to the author of CPANPLUS

=head1 SEE ALSO

 http://search.cpan.org/perldoc?CPANPLUS 
 http://gembundler.com/
 
 

package Bundler;
use version; our $VERSION = version->declare('v0.0.28');
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
    
    # Install all packages form .bundle file in current directory 
    # or from file choosen by --bundle-file option.
    # See Bundler for details.

    /bundle [install|remove] [--bundle_file <path>] [--dry-run]

    # format of .bundle file :
       
       -------------------------------------- 
       # comments begin with `#' and skipped 
       CGI # conventional way
       http://search.cpan.org/CPAN/authors/id/M/MA/MARKSTOS/CGI.pm-3.58.tar.gz # by url
       CGI.pm-3.58.tar.gz # by distro name
       -------------------------------------

=head1 OPTIONS

 --bundle_file # path to bundle file
 --dry-run # dry-run mode - just show what would happen and would do nothing


=head1 TODO LIST

 support for versions in ruby bundler's way


=head1 ACKNOWLEDGMENTS

 to the authors of bundler
 to the author of CPANPLUS


=head1 SEE ALSO

 http://search.cpan.org/perldoc?CPANPLUS 
 http://gembundler.com/
 
 

package CPANPLUS::Shell::Default::Plugins::Bundler;
use CPAN::Version;

### return command => method mapping
sub plugins { ( bundle => 'bnd' ) }

### method called when the command '/myplugin1' is issued
sub bnd { 

 # /helloworld bob --nofoo --bar=2 joe
    
 my $class   = shift;    # CPANPLUS::Shell::Default::Plugins::HW
 my $shell   = shift;    # CPANPLUS::Shell::Default object
 my $cb      = shift;    # CPANPLUS::Backend object
 my $cmd     = shift;    # 'helloworld'
 my $input   = shift;    # 'bob joe'
 my $opts    = shift;    # { foo => 0, bar => 2 }
        
 $input ||= 'install';   s/\s//g for $input;
 my $mode = $opts->{'dry-run'} ? 'dry-run' : 'real';
 my $handler_id = $input.'::'.$mode;
 if (exists $handlers{$handler_id}){
   print "fire handler : $handler_id \n";
   _bundle_file_itterator(
      $opts->{'bundle_file'} || "$ENV{PWD}/.bundle",
      $handlers{$handler_id},
      $cb
   );
 }else{
   print "handler [$handler_id] not found \n";
 }
 
 return;
}


our %handlers;

$handlers{'install::dry-run'} = sub {
	    my $line = shift;
	    my $cb = shift;
	    my $m = $cb->parse_module(module => $line);
	     if ($m){
	       if ($m->installed_version){
	         my $action;
	         my $st = CPAN::Version->vcmp($m->package_version,$m->installed_version);
	          if ($st == 0){
	            $action = 'would KEEP current version '.($m->installed_version)
	           }elsif($st == 1){
	            $action = "would UPDATE from version ".($m->installed_version)." to version : ".($m->package_version)
	           }else{
	            $action = "would DOWNGRADE from version ".($m->installed_version)." to version : ".($m->package_version);
	           }
	          print "$line - $action \n";
	       }else{
	        print "$line - would INSTALL at version : ", $m->package_version, "\n";
	       }
	     }else{
	      print "[$line] - not found! \n";
	     }
	

};

$handlers{'install::real'} = sub {
	    my $line = shift;
	    my $cb = shift;
	    print "do real install of module [$line]\n";
	    print $cb->install(modules=>[$line]);

};

$handlers{'remove::dry-run'} = sub {
	    my $line = shift;
	    my $cb = shift;
	    	my $m = $cb->parse_module(module => $line);
	    	 if ($m){
	    	    if ($m->installed_version){
	              print "$line - would remove it \n";
	            }else{
	              print "$line - would DO*NOTHING, module is not installed \n";    
	            }
	        }else{
	          print "[$line] - not found! \n";
	       }

};

$handlers{'remove::real'} = sub {
	    my $line = shift;
	    my $cb = shift;
	       print "do real uninstall of module [$line]\n";
	       my $m = $cb->parse_module(module => $line);
	       if ($m){
	        $m->uninstall();
	       }
};


### method called when the command '/? myplugin1' is issued
sub bnd_help { 

    return <<MESSAGE;
    # Install all packages form .bundle file in current directory 
    # or from --bundle-file option.
    # Inspired by ruby bundler.
    # See CPANPLUS::Shell::Default::Plugins::Bundler for details.

    /bundle [install|remove] [--bundle_file path] [--dry-run]

    # format of .bundle file :
       
       -------------------------------------- 
       # comments begin with `#' and skipped 
       CGI # conventional way
       http://search.cpan.org/CPAN/authors/id/M/MA/MARKSTOS/CGI.pm-3.58.tar.gz # by url
       CGI.pm-3.58.tar.gz # by distro name
       -------------------------------------
       
MESSAGE

}


sub _bundle_file_itterator {

 my $bundle_file = shift;
 my $handler = shift;
 my $cb = shift;

 if (-f $bundle_file){
  print "found bundle file [$bundle_file] \n";
    if (open BUNDLE_F, $bundle_file){
	while (my $line = <BUNDLE_F>){
	    chomp $line;
	    next if $line=~/^#\s/;
	    next if $line=~/^#/;
	    s/\s//g for $line;
	    s/(.*?)#.*/$1/ for $line; # cutoff comments chunks
	    next unless $line=~/\S/;
	    $handler->($line,$cb);
	}
	close BUNDLE_F;
    }else{
	print "error: cannot open .bundle file [$bundle_file]: $!\n";
    }
 }else{
  print "error: .bundle file [$bundle_file] not found\n";
 }

}

1;

__END__

=head1 NAME 

CPANPLUS::Shell::Default::Plugins::Bundler

=head1 Author

Alexey Melezhik / melezhik@gmail.com

=head1 SYNOPSIS

    Install all packages form .bundle file in current directory,
    Inspired by ruby bundler.


=head1 USAGE

 
 # in cpanp client session
 /bundle # installing 
 /bundle install # installing
 /bundle remove 

=head1 OPTIONS

 --bundle_file
 --dry-run
   
    
    
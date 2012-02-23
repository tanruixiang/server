package My::Suite::Main;

@ISA = qw(My::Suite);

sub skip_combinations {
  my @combinations;

  # disable innodb/xtradb combinatons for configurations that were not built
  push @combinations, 'innodb_plugin' unless $ENV{HA_INNODB_SO};
  push @combinations, 'xtradb_plugin' unless $ENV{HA_XTRADB_SO};
  push @combinations, 'xtradb' unless $::mysqld_variables{'innodb'} eq "ON";

  my %skip = ( 'include/have_innodb.combinations' => [ @combinations ]);

  # as a special case, disable certain include files as a whole
  $skip{'include/not_embedded.inc'} = 'Not run for embedded server'
             if $::opt_embedded_server;

  $skip{'include/have_debug.inc'} = 'Requires debug build'
             unless defined $::mysqld_variables{'debug-dbug'};

  $skip{'include/not_windows.inc'} = 'Requires not Windows' if IS_WINDOWS;

  # disable tests that use ipv6, if unsupported
  use Socket;
  $skip{'include/check_ipv6.inc'} = 'No IPv6'
             unless socket SOCK, PF_INET6, SOCK_STREAM, getprotobyname('tcp');
  close SOCK;

  %skip;
}


bless { };


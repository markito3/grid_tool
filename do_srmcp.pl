#!/usr/bin/env perl

# load perl modules
use DBI;

# connect to the database
$host = 'halldweb1.jlab.org';
$user = 'farmer';
$password = '';
$database = 'farming';

print "Connecting to $user\@$host, using $database.\n";
$dbh_db = DBI->connect("DBI:mysql:$database:$host", $user, $password);
if (defined $dbh_db) {
    print "Connection successful\n";
} else {
    die "Could not connect to the database server, exiting.\n";
}

$sql = "SELECT run, file from dc2_uconn_rest WHERE submitted = 0 order by run, file limit 100;";
make_query($dbh_db, \$sth);
open(FILEJOB, "> /tmp/copyjob.txt");
print "forming request for (run, file) = ";
while (@row = $sth->fetchrow_array) {
    $run = $row[0];
    $file = $row[1];
    print "($run,$file)";
    $sql = "UPDATE dc2_uconn_rest set submitted = 1 where run = $run and file = $file;";
    make_query($dbh_db, \$sth_update);
    $run_pad = sprintf("%05d", $run);
	$file_pad = sprintf("%07d", $file);
    print FILEJOB "srm://grinch.phys.uconn.edu/Gluex/test/dana_rest_${run_pad}_${file_pad}.hddm file:////volatile/halld/data_challenge/uconn/rest/dana_rest_${run_pad}_${file_pad}.hddm\n";
}
close(FILE_JOB);
print "\n";
system "echo gtpr = \$GLOBUS_TCP_PORT_RANGE";
system "echo gtsr = \$GLOBUS_TCP_SOURCE_RANGE";
system "srmcp -debug -copyjobfile=/tmp/copyjob.txt";

exit;

sub make_query {    

    my($dbh, $sth_ref) = @_;
    $$sth_ref = $dbh->prepare($sql)
        or die "Can't prepare $sql: $dbh->errstr\n";
    
    $rv = $$sth_ref->execute
        or die "Can't execute the query $sql\n error: $sth->errstr\n";
    
    return 0;

}

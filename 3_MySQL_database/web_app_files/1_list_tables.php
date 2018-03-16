<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to list all tables
$query = 'SHOW TABLES';
$response = mysqli_query($conn, $query)
	or die('Search request/query failed: ' . mysqli_error());

print "The tables in Sammy's database are:<br>";

// HTML code
print '<ol>';
while ($tuple = mysqli_fetch_row($response)) {
   print '<li>'.$tuple[0].'</li>';
}
print '</ol>';

// Free the memory associated with the result/response
mysqli_free_result($response);

// Close connection
mysqli_close($conn);
?>
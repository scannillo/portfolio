<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to list all bookers
$query = 'SELECT * FROM Booker';
$result = mysqli_query($conn, $query)
	or die('Search request/query failed. ' . mysqli_error());

print "All the bookers on this app are :<br>";

// HTML code
while ($tuple = mysqli_fetch_row($result)) {
	print '<ul>';  
	print '<li> Booker Name: '.$tuple[0];
	print '<li> Booker Email: '.$tuple[1];
	print '<li> Booker Phone: '.$tuple[2];
	print '<li> Booker Rating: '.$tuple[3];
	print '<li> Cover charge policy?: '.$tuple[4];
	print '<li> Requires ticket sales?: '.$tuple[4];
	print '</ul>';
}

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to list bookers based on rating
$inputRating = $_REQUEST['inputRating'];

$query = "SELECT Booker.BookerName
			FROM Booker
			WHERE Booker.BookerRating > $inputRating";

$result = mysqli_query($conn, $query)
  or die('Search request/query failed. ' . mysqli_error($conn));

print "The bookers who rate over $inputRating are :<br>";

// Printing in HTML
print '<ul>';
while ($tuple = mysqli_fetch_row($result)) {
   print '<li>'.$tuple[0].'</li>';
}
print '</ul>';

// Return the number of rows in result set
$rowcount=mysqli_num_rows($result);
print "<br>";
printf("There are %d booker(s) currently listed.\n",$rowcount);
print "<br>";
print "<br>";

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
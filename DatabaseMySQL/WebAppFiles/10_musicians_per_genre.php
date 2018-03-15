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
$inputGenre = $_REQUEST['inputGenre'];

$query = "SELECT Plays.MusicianName
			FROM Plays
			WHERE Plays.GenreCode = '$inputGenre'";

$result = mysqli_query($conn, $query)
  or die('Search request/query failed. ' . mysqli_error($conn));

print "The musicians who perform $inputGenre ... <br><br>";

// Printing in HTML
//print '<ul>';
while ($tuple = mysqli_fetch_row($result)) {
   print $tuple[0];
   print "<br>";
}
//print '</ul>';

// Return the number of rows in result set
$rowcount=mysqli_num_rows($result);
print "<br>";
printf("There is %d musician(s) currently listed.\n",$rowcount);
print "<br>";
print "<br>";

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
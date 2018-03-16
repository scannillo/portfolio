<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to get list of musicians
$cardinalInput = $_REQUEST['cardinalInput'];
$genreInput = $_REQUEST['genreInput'];

$query = "SELECT Reach.MusicianName
          FROM Plays, Reach
          WHERE Plays.MusicianName = Reach.MusicianName
          AND Reach.CardinalDirection = '$cardinalInput'
          AND Plays.GenreCode = '$genreInput'";

$result = mysqli_query($conn, $query)
  or die('Search request/query failed: ' . mysqli_error($conn));

print "The musicians who will play <b>$genreInput</b> music in the <b>$cardinalInput</b> :<br><br>";

// Printing in HTML
while ($tuple = mysqli_fetch_row($result)) {
	print $tuple[0];
	print "<br>";
}


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
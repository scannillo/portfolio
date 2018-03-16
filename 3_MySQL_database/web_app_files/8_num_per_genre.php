<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

$query = "SELECT Genre.GenreName, Plays.MusicianName
		 FROM Plays, Genre
		 WHERE Plays.GenreCode = Genre.GenreCode
		 ORDER BY Plays.GenreCode";

$result = mysqli_query($conn, $query)
  or die('Search request/query failed. ' . mysqli_error($conn));

print "List the musicians who play each genre :<p>";

// Printing in HTML
while ($tuple = mysqli_fetch_row($result)) {
   print "<b>$tuple[0]</b>, $tuple[1]";
   echo "<br>";
}

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to get booker
$neighborhood = $_REQUEST['neighborhood'];

$query = "SELECT DISTINCT Books.BookerName, Booker.BookerEmail, Books.VenueName
FROM Books, Booker
WHERE Books.BookerName = Booker.BookerName
AND Books.VenueName IN (SELECT Venue.VenueName
										FROM Venue, Neighborhood
										WHERE Venue.NeighborhoodName = Neighborhood.NeighborhoodName
										AND Neighborhood.CardinalDirection 
											= '$neighborhood')";
$result = mysqli_query($conn, $query)
  or die('Search request/query failed: ' . mysqli_error($conn));

print "Here are bookers who book in $neighborhood :<br>";

// Printing in HTML

while ($tuple = mysqli_fetch_row($result)) {
   print '<ul>';
   print '<li> Booker Name: '.$tuple[0];
   print '<li> Booker Email: '.$tuple[1];
   print '<li> Venue: '.$tuple[2];
   print '</ul>';  
}


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
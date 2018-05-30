<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to list bookers on the famous lincoln ave
$query = "SELECT Booker.BookerName, Booker.BookerEmail, Booker.BookerRating
		FROM Books, Booker
		WHERE Books.BookerName = Booker.BookerName
		AND Books.VenueName IN (SELECT Venue.VenueName
								FROM Venue
								WHERE Venue.Address LIKE '%Lincoln%')";
								
$result = mysqli_query($conn, $query)
	or die('Search request/query failed. ' . mysqli_error());

print "All the bookers who book on Lincoln Ave are :<br>";

// HTML code
while ($tuple = mysqli_fetch_row($result)) {
	print '<ul>';  
	print '<li> Booker Name: '.$tuple[0];
	print '<li> Booker Email: '.$tuple[1];
	print '<li> Booker Rating: '.$tuple[2];
	print '</ul>';
}

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
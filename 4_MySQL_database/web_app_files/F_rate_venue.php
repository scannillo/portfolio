<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Input parameters
$venueNameInput = $_REQUEST['venueNameInput'];
$ratingInput = $_REQUEST['ratingInput'];
$genreCodeInput = $_REQUEST['genreCodeInput'];

// Call stored procedure
$query = "CALL updateVenueRating('$venueNameInput', '$genreCodeInput', 
		 '$ratingInput')";

// Execute the stored procedure
$result = mysqli_query($conn, $query)
	or die('Unable to execute this rating. Make sure the venue exists in our app!' . mysqli_error());

print "You successfully rated $venueNameInput with a $ratingInput out of 10 for $genreCodeInput music.";

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
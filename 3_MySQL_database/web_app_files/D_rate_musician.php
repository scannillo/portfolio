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
$musicianNameInput = $_REQUEST['musicianNameInput'];
$ratingInput = $_REQUEST['ratingInput'];

// Call stored procedure
$query = "CALL updateMusicianRating('$musicianNameInput', '$ratingInput')";

// Execute the stored procedure
$result = mysqli_query($conn, $query)
	or die('Unable to execute this rating. Make sure this musician exists in our app!');

print "You successfully rated $musicianNameInput with a $ratingInput out of 10.";

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
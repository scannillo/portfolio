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
$nameInput = $_REQUEST['nameInput'];

// query. this will auto cascade!
$sql = "DELETE FROM Musician
		WHERE MusicianName = '$nameInput'";

// Execute the update
if (mysqli_query($conn, $sql)) {
	if(mysqli_affected_rows($conn)==0) {
		echo "No musician profiles were deleted. Please check that musician name exists before deleting.";
		echo "<br>";
	} else {
		echo "Successfully deleted $nameInput .";
		echo "<br>";
	}
    echo "Deleted entries: " . mysqli_affected_rows($conn);
} else {
    echo "Error deleting record.";
}

// Close connection
mysqli_close($conn);
?>
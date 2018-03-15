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

// Query. Auto cascades to other tables! Woop woop.
$sql = "DELETE FROM Booker
        WHERE BookerName = '$nameInput'";


// Execute the update
if (mysqli_query($conn, $sql)) {
	if(mysqli_affected_rows($conn)==0) {
		echo "No booker profiles were deleted. Please check that booker name exists before deleting.";
		echo "<br>";
	} else {
		echo "Successfully deleted $nameInput .";
		echo "<br>";
	}
    echo "Deleted entries: " . mysqli_affected_rows($conn);
} else {
    echo "Error deleting record." . mysqli_error($conn);
}

// Close connection
mysqli_close($conn);
?>
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
$newNameInput = $_REQUEST['newNameInput'];
$oldNameInput = $_REQUEST['oldNameInput'];

// Query. Auto cascades to other tables! Woop woop.
$sql = "UPDATE Booker
		SET BookerName = '$newNameInput'
		WHERE BookerName = '$oldNameInput'";


// Execute the update
if (mysqli_query($conn, $sql)) {
	if(mysqli_affected_rows($conn)==0) {
		echo "No booker names were updated. Please check that old booker name exists.";
		echo "<br>";
	} else {
		echo "Successfully updated the name $oldNameInput to $newNameInput .";
		echo "<br>";
	}
    echo "Updated entries: " . mysqli_affected_rows($conn);
} else {
    echo "Error updating booker record." . mysqli_error($conn);
}

// Close connection
mysqli_close($conn);
?>
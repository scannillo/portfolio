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

// Update query. Auto cascades to other tables! Woop woop.
$sql = "UPDATE Musician
		  SET MusicianName = '$newNameInput'
		  WHERE MusicianName = '$oldNameInput'";

// Execute the update
if (mysqli_query($conn, $sql)) {
	if(mysqli_affected_rows($conn)==0) {
		echo "No musician profiles were updated. Please check that old musician name exists.";
		echo "<br>";
	} else {
		echo "Successfully updated $oldNameInput to $newNameInput .";
		echo "<br>";
	}
    echo "Updated entries: " . mysqli_affected_rows($conn);
} else {
    echo "Error updating record. Make sure this musician name isn't already taken.";
}

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
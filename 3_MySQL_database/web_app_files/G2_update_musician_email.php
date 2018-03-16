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
$newEmailInput = $_REQUEST['newEmailInput'];

// Query. Auto cascades to other tables! Woop woop.
$sql = "UPDATE Musician
		  SET MusicianEmail = '$newEmailInput'
		  WHERE MusicianName = '$newNameInput'";

// Execute the update
if (mysqli_query($conn, $sql)) {
	if(mysqli_affected_rows($conn)==0) {
		echo "No musician emails were updated. Please check that musician name exists.";
		echo "<br>";
	} else {
		echo "Successfully updated the email of $newNameInput to $newEmailInput .";
		echo "<br>";
	}
    echo "Updated entries: " . mysqli_affected_rows($conn);
} else {
    echo "Error updating email record. Make sure musician name exists.";
}

// Close connection
$conn->close();
?>
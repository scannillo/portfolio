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
$bookerNameInput = $_REQUEST['bookerNameInput'];
$venueNameInput = $_REQUEST['venueNameInput'];

$sql =   "INSERT INTO Books
          VALUES ('$venueNameInput', '$bookerNameInput')";

if ($conn->query($sql) === TRUE) {
    echo "A record of $bookerNameInput booking at $venueNameInput created successfully.";
} else {
    echo "Error occured. Make sure the booker and venue name both exist.";
}

// Close connection
mysqli_close($conn);
?>
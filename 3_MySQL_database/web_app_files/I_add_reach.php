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
$cardinalDirectionInput = $_REQUEST['cardinalDirectionInput'];

$sql =   "INSERT INTO Reach
          VALUES ('$musicianNameInput', '$cardinalDirectionInput')";

if ($conn->query($sql) === TRUE) {
    echo "A record of $musicianNameInput playing in the $cardinalDirectionInput  created successfully.";
} else {
    echo "There was an error.<br><br>Make sure this musician has a profile in our app.<br>Make sure this location isn't already listed for this musician.";
}

// Close connection
mysqli_close($conn);
?>
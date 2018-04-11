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
$musicianEmailInput = $_REQUEST['musicianEmailInput'];
$musicianPhoneInput = $_REQUEST['musicianPhoneInput'];
$musicianURLInput = $_REQUEST['muicianURLInput'];

$sql =   "INSERT INTO Musician(MusicianName, MusicianEmail, MusicURL,
							   MusicianPhone) 
          VALUES ('$musicianNameInput', '$musicianEmailInput',
          		  '$musicianURLInput','$musicianPhoneInput')";

$result = mysqli_query($conn, $sql)
  or die('There was an error processing this request. Check to see if someone else already uses this musician name!');

if (!$result) {
    echo "Sorry. This musician name is already taken!";
} else {
    echo "Musician profile creation successful.";
}

mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
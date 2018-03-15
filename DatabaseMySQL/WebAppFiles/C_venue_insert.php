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
$capacityInput = $_REQUEST['capacityInput'];
$venuePhoneInput = $_REQUEST['venuePhoneInput'];
$venueAddresInput = $_REQUEST['venueAddresInput'];
$neighborhoodNameInput = $_REQUEST['neighborhoodNameInput'];

$sql =   "INSERT INTO Venue
          VALUES ('$venueNameInput', '$capacityInput',
      			  '$venuePhoneInput', '$venueAddresInput',
      			  '$neighborhoodNameInput')";

$result = mysqli_query($conn, $sql)
  or die('There was an error processing this request. Make sure the venue name is not already taken and that the neighborhood entered is on the list!');

if (!$result) {
    echo "Sorry. This venue name is already taken!";
} else {
    echo "Venue profile created successfully.";
}

mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
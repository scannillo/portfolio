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
$bookerEmailInput = $_REQUEST['bookerEmailInput'];
$bookerPhoneInput = $_REQUEST['bookerPhoneInput'];
$bookerRequiredTixSalesInput = $_REQUEST['bookerRequiredTixSalesInput'];
$bookerCoverChargeInput = $_REQUEST['bookerCoverChargeInput'];

$sql =   "INSERT INTO Booker(BookerName, BookerEmail, BookerPhone,
	                         CoverCharge, RequiredTixSales)
          VALUES ('$bookerNameInput', '$bookerEmailInput',
      			  '$bookerPhoneInput', '$bookerCoverChargeInput',
      			  '$bookerRequiredTixSalesInput')";

$result = mysqli_query($conn, $sql)
  or die('There was an error processing this request. Check to see if this booker name is already taken!');

if (!$result) {
    echo "Sorry. This booker name is already taken!";
} else {
    echo "Booker profile creation successful.";
}

mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
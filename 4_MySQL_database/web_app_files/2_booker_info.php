<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to get booker info
$bookerIn = $_REQUEST['bookerIn'];

$query = "SELECT *
		  FROM Booker
		  WHERE BookerName = '$bookerIn'";
$result = mysqli_query($conn, $query)
  or die('Search request/query failed: ' . mysqli_error($conn));

// Check for only one result
$tuple = mysqli_fetch_array($result)
  or die("$bookerIn is not listed as a booker in our app.");

print "Booker named <b>$bookerIn</b> information below:";

// HTML code
print '<ul>';  
print '<li> Booker Name: '.$tuple['BookerName'];
print '<li> Booker Email: '.$tuple['BookerEmail'];
print '<li> Booker Phone: '.$tuple['BookerPhone'];
print '<li> Booker Rating: '.$tuple['BookerRating'];
print '<li> Cover charge?: '.$tuple['CoverCharge'];
print '<li> Required ticket sales?: '.$tuple['RequiredTixSales'];
print '</ul>';

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
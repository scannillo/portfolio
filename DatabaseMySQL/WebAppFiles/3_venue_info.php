<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to get venue info
$venueIn = $_REQUEST['venueIn'];

$query = "SELECT VenueName, Capacity, VenuePhone, 
		 Address, NeighborhoodName
		 FROM Venue
		 WHERE VenueName = '$venueIn'";
$result = mysqli_query($conn, $query)
  or die('Search request/query failed: ' . mysqli_error($conn));

// Check for only one result
$tuple = mysqli_fetch_array($result)
  or die("$venueIn is not found in our app.");

print "<b>$venueIn</b> information below:";

// HTML code
print '<ul>';  
print '<li> Venue Name: '.$tuple['VenueName'];
print '<li> Capacity: '.$tuple['Capacity'];
print '<li> Phone: '.$tuple['VenuePhone'];
print '<li> Address: '.$tuple['Address'];
print '<li> Neighborhood: '.$tuple['NeighborhoodName'];
print '</ul>';

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
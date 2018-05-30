<?php

// Connection parameters 
$host = 'mpcs53001.cs.uchicago.edu';
$username = 'scannillo';
$password = 'faiNoRa1';
$database = $username.'DB';

// Connection attempt
$conn = mysqli_connect($host, $username, $password, $database)
   or die('A connection error has occured. ' . mysqli_connect_error());

// Query to get musician info
$musicianIn = $_REQUEST['musicianIn'];

$query = "SELECT *
		 FROM Musician
		 WHERE MusicianName = '$musicianIn'";
$result = mysqli_query($conn, $query)
  or die('Search request/query failed: ' . mysqli_error($conn));

// Check for only one result
$tuple = mysqli_fetch_array($result)
  or die("$musicianIn is not found in our app.");

print "Artist named <b>$musicianIn</b> information below:";

// HTML code
print '<ul>';  
print '<li> Musician Name: '.$tuple['MusicianName'];
print '<li> Musician Email: '.$tuple['MusicianEmail'];
print '<li> Website: '.$tuple['MusicURL'];
print '<li> Musician Rating: '.$tuple['MusicianRating'];
print '<li> Phone Number: '.$tuple['MusicianPhone'];
print '</ul>';

// Free the memory associated with the result/response
mysqli_free_result($result);

// Close connection
mysqli_close($conn);
?>
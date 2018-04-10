-- USE scannilloDB

-- Show the band with the highest rating who plays a rock music
SELECT Musician.MusicianName, MAX(Musician.MusicianRating)
FROM Genre, Plays, Musician
WHERE Genre.GenreCode = Plays.GenreCode
AND Musician.MusicianName = Plays.MusicianName
AND Musician.MusicianRating IS NOT NULL
GROUP BY Musician.MusicianName;

-- Find the highest rated booker in West Side who does NOT require ticket sales.
SELECT DISTINCT Booker.BookerName, MAX(Booker.BookerRating)
FROM Booker, Neighborhood, Books, Venue
WHERE Booker.BookerName = Books.BookerName
AND Neighborhood.CardinalDirection = 'West Side'
AND Venue.NeighborhoodName = Neighborhood.NeighborhoodName
AND Venue.VenueName = Books.VenueName
AND Booker.RequiredTixSales = 'No'
GROUP BY Booker.BookerName;

-- List the venue that has the most guitar amps, given it also provides a drumkit, in the North Side.
SELECT Venue.VenueName, MAX(Backline.NumGuitarAmps)
FROM Venue, Backline, Provides
WHERE Provides.VenueName = Venue.VenueName
AND Backline.BacklineId = Provides.BacklineId
AND Venue.VenueName IN (SELECT Venue.VenueName
                        FROM Venue, Neighborhood
                        WHERE Venue.NeighborhoodName = Neighborhood.NeighborhoodName
                        AND Neighborhood.CardinalDirection = 'North Side')
AND Backline.DrumKit = 1
GROUP BY Venue.VenueName;

-- Give the phone number of bookers who book only at venues that have at least 3 channel mixers and in the West Side. Subquery will list the all venues in West Side.
SELECT DISTINCT Booker.BookerName, Booker.BookerEmail, Booker.BookerPhone
FROM Books, Booker, Backline, Provides
WHERE Backline.BacklineId = Provides.BacklineId
AND Books.BookerName = Booker.BookerName
AND Backline.NumChannelMixer >= 3
AND Provides.VenueName IN (SELECT Venue.VenueName
                            FROM Venue, Neighborhood
                            WHERE Venue.NeighborhoodName = Neighborhood.NeighborhoodName
                            AND Neighborhood.CardinalDirection = 'West Side');

-- A booker wants to find a list of artists who are willing to play at The Elbo Room who will play Blues or Folk music.
SELECT Plays.MusicianName
FROM Reach
JOIN Plays USING (MusicianName)
WHERE Reach.CardinalDirection = (SELECT Neighborhood.CardinalDirection
                                FROM Venue, Neighborhood
                                WHERE Venue.VenueName = 'Venue#46'
                                AND Venue.NeighborhoodName = Neighborhood.NeighborhoodName)
AND Plays.GenreCode = 'BLUES' OR Plays.GenreCode = 'FOLK';

-- Return the score of the best rated musician for each genre. If the genre has no rated musician, still include it in the list! There can be more than one best rated.
SELECT G.GenreName, M.MusicianName, MAX(M.MusicianRating)
FROM Genre G
LEFT OUTER JOIN Plays P
    ON G.GenreCode = P.GenreCode
LEFT OUTER JOIN Musician M
    USING(MusicianName)
GROUP BY G.GenreName, M.MusicianName;


-- The below keeps a LOG/ track of changes made to the Musicians table when a MusicianRating is changed. First, lets create the relation.
CREATE TABLE MusicianRatingChanges (
    MusicianName            VARCHAR(75),
    OldRating               FLOAT,
    NewRating               FLOAT,
    EditorName              VARCHAR(100),
    EditDatetime            DATETIME,
    PRIMARY KEY(MusicianName, EditDatetime)
);

-- Create the trigger to place log information into the MusicianRatingChanges table.
DELIMITER |
CREATE TRIGGER MusicanRatingChangedTrigger
AFTER UPDATE ON Musician
FOR EACH ROW
BEGIN
    IF (NEW.MusicianRating != OLD.MusicianRating) THEN
        INSERT INTO MusicianRatingChanges 
        VALUES(OLD.MusicianName, OLD.MusicianRating, NEW.MusicianRating, CURRENT_USER(), NOW());
            END IF;
END; |
DELIMITER ;
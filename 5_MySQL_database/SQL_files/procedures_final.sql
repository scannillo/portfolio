USE scannilloDB;

###SET FOREIGN_KEY_CHECKS = 1;

##Create procedure to keep track of ratings posted in our log table. This will also update the rating in the musician
##table to be the NEW average rating of all previous ratings.
DELIMITER |
CREATE PROCEDURE updateMusicianRating(
    IN musicianNameInput                VARCHAR(75),
    IN musicianRatingInput              FLOAT
)
BEGIN

    DECLARE newAvgRating FLOAT;

    INSERT INTO LogMusicianRatings
    VALUES(musicianNameInput, musicianRatingInput, CURRENT_USER(), NOW());
    
    SET newAvgRating = (SELECT AVG(LogRating)
                        FROM LogMusicianRatings L
                        WHERE L.MusicianName = musicianNameInput);
                                        
    UPDATE Musician
    SET MusicianRating = newAvgRating
    WHERE MusicianName = musicianNameInput;
    
END |
DELIMITER ;

##Procedure to keep track of booker ratings in the log, but also to update the average in the booker profile table.
DELIMITER |
CREATE PROCEDURE updateBookerRating(
    IN bookerNameInput              VARCHAR(75),
    IN bookerRatingInput            FLOAT
)
BEGIN

    DECLARE newAvgRating FLOAT;

    INSERT INTO LogBookerRatings
    VALUES(bookerNameInput, bookerRatingInput, CURRENT_USER(), NOW());
    
    SET newAvgRating = (SELECT AVG(LogRating)
                        FROM LogBookerRatings L
                        WHERE L.BookerName = bookerNameInput);
                                        
    UPDATE Booker
    SET BookerRating = newAvgRating
    WHERE BookerName = bookerNameInput;
    
END |
DELIMITER ;

##Proceduer to track venue ratings. This will store in a log table, and also update the Offers table which stores ratings.
## Venue ratings also are based on genres. If no rating exists for that genre, insert. If so, update to current avg.
DELIMITER |
CREATE PROCEDURE updateVenueRating(
    IN venueNameInput               VARCHAR(75),
    IN genreCodeInput               VARCHAR(5),
    IN venueRatingInput             FLOAT
)
BEGIN

    DECLARE newAvgRating FLOAT;

    INSERT INTO LogVenueRatings
    VALUES(venueNameInput, genreCodeInput, venueRatingInput, CURRENT_USER(), NOW());
    
    SET newAvgRating = (SELECT AVG(LogRating)
                        FROM LogVenueRatings L
                        WHERE L.VenueName = venueNameInput
                        AND L.GenreCode = genreCodeInput);
                                        
    INSERT INTO Offers 
    VALUES (venueNameInput, genreCodeInput, venueRatingInput)
    ON DUPLICATE KEY UPDATE
        VenueRating = newAvgRating;
    
END |
DELIMITER ;

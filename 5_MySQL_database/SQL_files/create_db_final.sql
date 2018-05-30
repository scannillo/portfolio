## USE scannillo DB

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS Reach;
DROP TABLE IF EXISTS Offers;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Provides;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Neighborhood;
DROP TABLE IF EXISTS Musician;
DROP TABLE IF EXISTS Booker;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Backline;
DROP TABLE IF EXISTS Plays;
DROP TABLE IF EXISTS LogVenueRatings;
DROP TABLE IF EXISTS LogMusicianRatings;
DROP TABLE IF EXISTS LogBookerRatings;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE Musician (
    MusicianName            VARCHAR(75) NOT NULL,
    MusicianEmail           VARCHAR(50),
    MusicURL                VARCHAR(250),
    MusicianRating          FLOAT,
    MusicianPhone           BIGINT,
    PRIMARY KEY (MusicianName)
);

CREATE TABLE Neighborhood (
    CardinalDirection       VARCHAR(25) NOT NULL,   
    NeighborhoodName        VARCHAR(50) NOT NULL,
    PRIMARY KEY (NeighborhoodName)
);

CREATE TABLE Venue (
    VenueName               VARCHAR(75) NOT NULL,
    Capacity                SMALLINT,
    VenuePhone              BIGINT,
    Address                 VARCHAR(200),
    NeighborhoodName        VARCHAR(50),
    PRIMARY KEY (VenueName),
    FOREIGN KEY (NeighborhoodName) REFERENCES Neighborhood(NeighborhoodName)
);

CREATE TABLE Booker (
    BookerName              VARCHAR(50) NOT NULL,
    BookerEmail             VARCHAR(75),
    BookerPhone             BIGINT,
    BookerRating            FLOAT,
    CoverCharge             VARCHAR(10),
    RequiredTixSales        VARCHAR(10),
    PRIMARY KEY (BookerName)
);

CREATE TABLE Genre (
    GenreCode               VARCHAR(5)  NOT NULL,
    GenreName               VARCHAR(25) NOT NULL,
    PRIMARY KEY (GenreCode)
);

CREATE TABLE Backline (
    BacklineId              INT NOT NULL AUTO_INCREMENT,
    NumBassAmps             TINYINT,
    DrumKit                 BIT,
    NumGuitarAmps           TINYINT,
    NumMonitors             TINYINT,
    NumChannelMixer         TINYINT,
    NumPianos               TINYINT,
    PA                      BIT,
    PRIMARY KEY (BacklineId)
); 

CREATE TABLE Reach (
    MusicianName            VARCHAR(75) NOT NULL,
    CardinalDirection       VARCHAR(20) NOT NULL,
    PRIMARY KEY (MusicianName, CardinalDirection),
    FOREIGN KEY (MusicianName) REFERENCES Musician(MusicianName)
     ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Offers (
    VenueName               VARCHAR(75) NOT NULL,
    GenreCode               VARCHAR(5)  NOT NULL,           
    VenueRating             FLOAT,
    PRIMARY KEY (VenueName, GenreCode),
    FOREIGN KEY (VenueName) REFERENCES Venue(VenueName),
    FOREIGN KEY (GenreCode) REFERENCES Genre(GenreCode)
);

CREATE TABLE Books (
    VenueName               VARCHAR(75) NOT NULL,
    BookerName              VARCHAR(50) NOT NULL,
    PRIMARY KEY (VenueName, BookerName),
    FOREIGN KEY (VenueName) REFERENCES Venue(VenueName),
    FOREIGN KEY (BookerName) REFERENCES Booker(BookerName)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Provides (
    VenueName               VARCHAR(75) NOT NULL,
    BacklineId              INT         NOT NULL,
    PRIMARY KEY (VenueName, BacklineId),
    FOREIGN KEY (VenueName) REFERENCES Venue(VenueName),
    FOREIGN KEY (BacklineId) REFERENCES Backline(BacklineId)
);

CREATE TABLE Plays (
    MusicianName                VARCHAR(75) NOT NULL,
    GenreCode                   VARCHAR(5)  NOT NULL,
    PRIMARY KEY (MusicianName, GenreCode),
    FOREIGN KEY (MusicianName) REFERENCES Musician(MusicianName)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (GenreCode) REFERENCES Genre(GenreCode)
);

#### Create log tables for rating updates.

CREATE TABLE LogMusicianRatings (
    MusicianName                VARCHAR(75),
    LogRating                   FLOAT,
    EditorName                  VARCHAR(100),
    EditDatetime                DATETIME,
    PRIMARY KEY(MusicianName, EditDatetime),
    FOREIGN KEY(MusicianName) REFERENCES Musician(MusicianName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LogBookerRatings (
    BookerName                  VARCHAR(75),
    LogRating                   FLOAT,
    EditorName                  VARCHAR(100),
    EditDatetime                DATETIME,
    PRIMARY KEY(BookerName, EditDatetime),
    FOREIGN KEY(BookerName) REFERENCES Booker(BookerName)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LogVenueRatings (
    VenueName                   VARCHAR(75),
    GenreCode                   VARCHAR(5),
    LogRating                   FLOAT,
    EditorName                  VARCHAR(100),
    EditDatetime                DATETIME,
    PRIMARY KEY(VenueName, GenreCode, EditDatetime),
    FOREIGN KEY(VenueName) REFERENCES Venue(VenueName),
    FOREIGN KEY(GenreCode) REFERENCES Genre(GenreCode)
);
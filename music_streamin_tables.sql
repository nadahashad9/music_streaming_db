--Music Streaming Project
--Users
CREATE TABLE USERS (
    user_id NUMBER(6),
    username VARCHAR2(50) CONSTRAINT nn_users_username NOT NULL,
    email VARCHAR2(100),
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email)
);
--Artist
CREATE TABLE ARTIST (
    artist_id NUMBER(6),
    name VARCHAR2(100) CONSTRAINT nn_artist_name NOT NULL,
    CONSTRAINT pk_artist PRIMARY KEY (artist_id)
);
--Album
CREATE TABLE ALBUM (
    album_id NUMBER(6),
    title VARCHAR2(100) CONSTRAINT nn_album_title NOT NULL,
    artist_id NUMBER(6),
    CONSTRAINT pk_album PRIMARY KEY (album_id),
    CONSTRAINT fk_album_artist FOREIGN KEY (artist_id) 
    REFERENCES ARTIST(artist_id) ON DELETE CASCADE
);
--Song
CREATE TABLE SONG (
    song_id NUMBER(6),
    title VARCHAR2(100) CONSTRAINT nn_song_title NOT NULL,
    duration NUMBER,
    album_id NUMBER(6),
    CONSTRAINT pk_song PRIMARY KEY (song_id),
    CONSTRAINT fk_song_album FOREIGN KEY (album_id) 
    REFERENCES ALBUM(album_id),
    CONSTRAINT ck_song_duration CHECK (duration > 0)
);
--Playlist
CREATE TABLE PLAYLIST (
    playlist_id NUMBER(6),
    name VARCHAR2(100) CONSTRAINT nn_playlist_name NOT NULL,
    user_id NUMBER(6),
    CONSTRAINT pk_playlist PRIMARY KEY (playlist_id),
    CONSTRAINT fk_playlist_users FOREIGN KEY (user_id) 
    REFERENCES USERS(user_id)
);
--Song_artist (M:N)
CREATE TABLE SONG_ARTIST (
    song_id NUMBER(6),
    artist_id NUMBER(6),
    CONSTRAINT pk_song_artist PRIMARY KEY (song_id, artist_id),
    CONSTRAINT fk_song_artist_song FOREIGN KEY (song_id) 
    REFERENCES SONG(song_id),
    CONSTRAINT fk_song_artist_artist FOREIGN KEY (artist_id) 
    REFERENCES ARTIST(artist_id)
);
--Playlist_song (M:N)
CREATE TABLE PLAYLIST_SONG (
    playlist_id NUMBER(6),
    song_id NUMBER(6),
    CONSTRAINT pk_playlist_song PRIMARY KEY (playlist_id, song_id),
    CONSTRAINT fk_playlist_song_playlist FOREIGN KEY (playlist_id) 
    REFERENCES PLAYLIST(playlist_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_playlist_song_song FOREIGN KEY (song_id) 
    REFERENCES SONG(song_id)
); 
-- added forgotten DEFAULT constraint
ALTER TABLE USERS
ADD created_at DATE DEFAULT SYSDATE;

-- 1st user
INSERT INTO Users (user_id, username, email) VALUES (1, 'dahlia', 'dahlia@email.com');
--2nd user
INSERT INTO Users (user_id, username, email) VALUES (2, 'ahmed', 'ahmed@email.com');
-- 3rd user
INSERT INTO Users (user_id, username, email) VALUES (3, 'rahma', 'rahma@email.com');

--1st artist
INSERT INTO ARTIST (artist_id, name) VALUES (2345, 'Madd');
--2nd artist
INSERT INTO ARTIST (artist_id, name) VALUES (9835, 'Wegz');
--3rd artist
INSERT INTO ARTIST (artist_id, name) VALUES (1111, 'Shobee');
-- 4th artist
INSERT INTO ARTIST (artist_id, name) VALUES (9888, 'Amr Diab');

--1st album
INSERT INTO ALBUM (album_id, title, artist_id) VALUES (1, 'Sēnsus', 2345)
--2nd album
INSERT INTO ALBUM (album_id, title, artist_id) VALUES (2, 'جزيرة البطل', 9835);
--3rd album
INSERT INTO ALBUM (album_id, title, artist_id) VALUES (3, 'Amr Diab Songs', 9888);

--songs inserted
INSERT INTO SONG (song_id, title, duration, album_id) VALUES (6, 'Ebtadena', 400, 3);
INSERT INTO SONG (song_id, title, duration, album_id) VALUES (1, 'Spliff', 210, 1);
INSERT INTO SONG (song_id, title, duration, album_id) VALUES (2, 'كان نفسي', 180, 2);
INSERT INTO SONG (song_id, title, duration, album_id) VALUES (4, 'Doubt', 210, 1);
INSERT INTO SONG (song_id, title, duration, album_id) VALUES (3, 'حورية', 180, 2);

--playlists
INSERT INTO PLAYLIST (playlist_id, name, user_id) VALUES (5, 'liebe', 3);
INSERT INTO PLAYLIST (playlist_id, name, user_id) VALUES (1, 'My Favorites', 1);
INSERT INTO PLAYLIST (playlist_id, name, user_id) VALUES (2, 'Songs', 2);

--assign artists to songs
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (1, 2345);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (2, 9835);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (3, 9835);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (4, 2345);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (4, 1111);
INSERT INTO SONG_ARTIST (song_id, artist_id) VALUES (6, 9888);

--add songs to playlists
INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (1, 1);
INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (1, 2);
INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (2, 3);
INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (2, 4);
INSERT INTO PLAYLIST_SONG (playlist_id, song_id) VALUES (5, 3);

-- meaningful update (affects many rows)
UPDATE SONG
SET duration = duration + 10
WHERE album_id =1;

--meaningful delete
DELETE FROM PLAYLIST_SONG
WHERE playlist_id = 1;

--UNIQUE error chech
INSERT INTO Users (user_id, username, email)
VALUES (2, 'ahmed', 'dahlia@email.com'); --email already assigned to another user

--NOT NULL error check
INSERT INTO Users (user_id, username, email)
VALUES (1, '', 'dahlia@email.com'); --null is prohibited

--CHECK error check
INSERT INTO SONG (song_id, title, duration, album_id)
VALUES (1, 'Spliff', -1, 1); -- duration is < 0 which violates the CHECK condition

--FOREIGN KEY error check
INSERT INTO SONG_ARTIST (song_id, artist_id)
VALUES (1, 123456); -- artist id doesn't even exist


CREATE TABLE distributie (
    id_film INT NOT NULL REFERENCES filme(id_film) ON DELETE CASCADE,
    id_actor INT NOT NULL REFERENCES actori(id_actor) ON DELETE CASCADE,
    rol VARCHAR(100) NOT NULL,
    comentariu_prestatie TEXT,
    PRIMARY KEY (id_film, id_actor)
);
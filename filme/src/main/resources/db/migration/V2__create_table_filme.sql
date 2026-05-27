CREATE TABLE filme (
    id_film SERIAL PRIMARY KEY,
    titlu VARCHAR(150) NOT NULL,
    descriere TEXT,
    categorie VARCHAR(50) NOT NULL,
    data_lansarii DATE,
    durata INT NOT NULL,
    rating_mediu NUMERIC(4,2) DEFAULT 0
);
CREATE TABLE versiuni_film (
    id_versiune SERIAL PRIMARY KEY,
    id_film INT NOT NULL REFERENCES filme(id_film) ON DELETE CASCADE,
    format_video VARCHAR(20) NOT NULL,
    limba VARCHAR(50) NOT NULL,
    rezolutie VARCHAR(20)
);
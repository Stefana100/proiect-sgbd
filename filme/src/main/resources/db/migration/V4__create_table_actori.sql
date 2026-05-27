CREATE TABLE actori (
    id_actor SERIAL PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    nume_scena VARCHAR(100),
    data_nasterii DATE
);
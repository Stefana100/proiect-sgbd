CREATE TABLE clienti (
    id_client SERIAL PRIMARY KEY,
    nume VARCHAR(50) NOT NULL,
    prenume VARCHAR(50) NOT NULL,
    telefon_acasa VARCHAR(20),
    telefon_mobil VARCHAR(20) UNIQUE NOT NULL,
    adresa VARCHAR(150),
    oras VARCHAR(50),
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nasterii DATE NOT NULL
);
CREATE TABLE vizualizari (
    id_vizualizare SERIAL PRIMARY KEY,
    id_client INT NOT NULL REFERENCES clienti(id_client) ON DELETE CASCADE,
    id_versiune INT NOT NULL REFERENCES versiuni_film(id_versiune) ON DELETE CASCADE,
    data_vizualizare TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    durata_minute INT CHECK (durata_minute >= 0),
    stare_vizualizare VARCHAR(20) DEFAULT 'FINALIZAT'
);
CREATE TABLE feedback (
    id_feedback SERIAL PRIMARY KEY,
    id_client INT NOT NULL REFERENCES clienti(id_client) ON DELETE CASCADE,
    id_film INT NOT NULL REFERENCES filme(id_film) ON DELETE CASCADE,
    nota INT CHECK (nota BETWEEN 1 AND 10),
    comentariu TEXT,
    data_postare DATE DEFAULT CURRENT_DATE
);
CREATE TABLE optiuni_feedback (
    id_optiune SERIAL PRIMARY KEY,
    denumire VARCHAR(50) NOT NULL UNIQUE
);
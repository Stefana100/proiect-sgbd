CREATE TABLE IF NOT EXISTS log_stergeri_clienti (
    id_log SERIAL PRIMARY KEY,
    id_client INT,
    nume_complet VARCHAR(150),
    data_stergere TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    utilizator_db VARCHAR(50)
);

CREATE OR REPLACE FUNCTION proceseaza_stergere_client()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM feedback_optiuni_selectate
    WHERE id_feedback IN (SELECT id_feedback FROM feedback WHERE id_client = OLD.id_client);
    DELETE FROM feedback WHERE id_client = OLD.id_client;
    DELETE FROM vizualizari WHERE id_client = OLD.id_client;
    INSERT INTO log_stergeri_clienti (id_client, nume_complet, utilizator_db)
    VALUES (OLD.id_client, OLD.nume || ' ' || OLD.prenume, CURRENT_USER);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_log_stergere_client ON clienti;
CREATE TRIGGER trg_proceseaza_stergere_client
BEFORE DELETE ON clienti
FOR EACH ROW
EXECUTE FUNCTION proceseaza_stergere_client();
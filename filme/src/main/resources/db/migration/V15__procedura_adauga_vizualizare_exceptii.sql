CREATE OR REPLACE PROCEDURE adauga_vizualizare(
    p_id_client_vizat INT,
    p_id_versiune_film INT,
    p_durata_vizionare INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_verificare_existenta_client INT;
    v_durata_totala_film INT;
    v_stare_calculata VARCHAR(20);
BEGIN
    IF p_durata_vizionare < 0 THEN
        RAISE EXCEPTION 'Eroare: Durata vizionarii (%) este invalida.', p_durata_vizionare;
    END IF;
    SELECT COUNT(*) INTO v_verificare_existenta_client
    FROM clienti
    WHERE id_client = p_id_client_vizat;

    IF v_verificare_existenta_client = 0 THEN
        RAISE EXCEPTION 'Eroare: Clientul cu ID-ul % nu a fost gasit.', p_id_client_vizat;
    END IF;
    SELECT f.durata INTO v_durata_totala_film
    FROM filme f
    JOIN versiuni_film vf ON f.id_film = vf.id_film
    WHERE vf.id_versiune = p_id_versiune_film;
    IF p_durata_vizionare = 0 THEN
        v_stare_calculata := 'INCEPUT';
    ELSIF v_durata_totala_film IS NOT NULL AND p_durata_vizionare >= v_durata_totala_film THEN
        v_stare_calculata := 'FINALIZAT';
    ELSIF v_durata_totala_film IS NOT NULL AND p_durata_vizionare < (v_durata_totala_film * 0.2) THEN
        v_stare_calculata := 'ABANDONAT';
    ELSE
        v_stare_calculata := 'IN CURS';
    END IF;
    INSERT INTO vizualizari (
        id_client,
        id_versiune,
        durata_minute,
        stare_vizualizare,
        data_vizualizare
    )
    VALUES (
        p_id_client_vizat,
        p_id_versiune_film,
        p_durata_vizionare,
        v_stare_calculata,
        CURRENT_DATE
    );
    RAISE NOTICE 'Vizualizare inregistrata cu starea: %', v_stare_calculata;
END;
$$;
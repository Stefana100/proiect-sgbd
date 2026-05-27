CREATE OR REPLACE FUNCTION predictie_categorie_sezon(p_luna_calendaristica INT)
RETURNS VARCHAR AS $$
DECLARE
    v_categorie_celebra VARCHAR(50);
BEGIN
    IF p_luna_calendaristica NOT BETWEEN 1 AND 12 THEN
        RAISE EXCEPTION 'Luna % nu exista. Introdu o cifra intre 1 si 12.', p_luna_calendaristica;
    END IF;
    SELECT film.categorie
    INTO v_categorie_celebra
    FROM vizualizari viz
    JOIN versiuni_film versiune ON viz.id_versiune = versiune.id_versiune
    JOIN filme film ON versiune.id_film = film.id_film
    WHERE to_char(viz.data_vizualizare, 'MM')::INT = p_luna_calendaristica
    GROUP BY film.categorie
    ORDER BY COUNT(*) DESC
    FETCH FIRST 1 ROW ONLY;
    IF v_categorie_celebra IS NULL THEN
        RETURN 'Nu avem date istorice pentru luna ' || p_luna_calendaristica;
    END IF;

    RETURN 'Predictie: In luna ' || p_luna_calendaristica ||
           ' cea mai cautata categorie va fi ' || v_categorie_celebra;
END;
$$ LANGUAGE plpgsql;
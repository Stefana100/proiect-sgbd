CREATE OR REPLACE FUNCTION obtine_recomandari_client(p_id_client_curent INT)
RETURNS SETOF VARCHAR AS $$
DECLARE
    v_titlu_film_recomandat filme.titlu%TYPE;
    v_numar_filme_gasite INT := 0;
    c_cursor_filme_recomandate CURSOR FOR
        SELECT DISTINCT film_recomandat.titlu
        FROM vizualizari vizualizari_alti_clienti
        JOIN versiuni_film versiuni_alti_clienti ON vizualizari_alti_clienti.id_versiune = versiuni_alti_clienti.id_versiune
        JOIN filme film_recomandat ON versiuni_alti_clienti.id_film = film_recomandat.id_film
        WHERE vizualizari_alti_clienti.id_client != p_id_client_curent
          AND film_recomandat.categorie IN (
              SELECT DISTINCT film_deja_vazut.categorie
              FROM vizualizari vizualizari_client_curent
              JOIN versiuni_film versiuni_client_curent ON vizualizari_client_curent.id_versiune = versiuni_client_curent.id_versiune
              JOIN filme film_deja_vazut ON versiuni_client_curent.id_film = film_deja_vazut.id_film
              WHERE vizualizari_client_curent.id_client = p_id_client_curent
          )
          AND film_recomandat.id_film NOT IN (
              SELECT versiuni_istoric.id_film
              FROM vizualizari vizualizari_istoric
              JOIN versiuni_film versiuni_istoric ON vizualizari_istoric.id_versiune = versiuni_istoric.id_versiune
              WHERE vizualizari_istoric.id_client = p_id_client_curent
          );
BEGIN
    OPEN c_cursor_filme_recomandate;
    LOOP
        FETCH c_cursor_filme_recomandate INTO v_titlu_film_recomandat;
        EXIT WHEN NOT FOUND OR v_numar_filme_gasite >= 5;

        RETURN NEXT v_titlu_film_recomandat;
        v_numar_filme_gasite := v_numar_filme_gasite + 1;
    END LOOP;
    CLOSE c_cursor_filme_recomandate;
END;
$$ LANGUAGE plpgsql;
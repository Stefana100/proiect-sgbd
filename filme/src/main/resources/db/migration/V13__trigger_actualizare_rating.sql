CREATE OR REPLACE FUNCTION update_rating_mediu_film()
RETURNS TRIGGER AS $$
DECLARE
    v_id_film_vizat INT;
    v_media_noua NUMERIC;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_id_film_vizat := OLD.id_film;
    ELSE
        v_id_film_vizat := NEW.id_film;
    END IF;
    SELECT AVG(nota) INTO v_media_noua
    FROM feedback
    WHERE id_film = v_id_film_vizat;
    IF v_media_noua IS NULL THEN
        v_media_noua := 0;
    END IF;
    UPDATE filme
    SET rating_mediu = ROUND(v_media_noua, 2)
    WHERE id_film = v_id_film_vizat;
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_actualizeaza_rating ON feedback;
CREATE TRIGGER trg_actualizeaza_rating
AFTER INSERT OR UPDATE OR DELETE ON feedback
FOR EACH ROW
EXECUTE FUNCTION update_rating_mediu_film();
UPDATE filme f
SET rating_mediu = ROUND((SELECT AVG(nota) FROM feedback WHERE id_film = f.id_film), 2);
UPDATE filme SET rating_mediu = 0 WHERE rating_mediu IS NULL;
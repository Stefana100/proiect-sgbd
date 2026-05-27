CREATE OR REPLACE FUNCTION analiza_sentiment_feedback(p_id_feedback INT)
RETURNS VARCHAR AS $$
DECLARE
    v_comentariu TEXT;
    v_nota INT;
    v_cuvinte_pozitive VARCHAR[] := ARRAY['bun', 'excelent', 'capodopera', 'recomand', 'placut', 'interesant', 'emotionant', 'super', 'fain'];
    v_cuvinte_negative VARCHAR[] := ARRAY['prost', 'plictisitor', 'slab', 'dezamagitor', 'urat', 'pierdere', 'groaznic', 'evitati'];
    v_scor INT := 0;
    v_rezultat VARCHAR;
    i INT;
BEGIN
    SELECT comentariu, nota INTO v_comentariu, v_nota
    FROM feedback
    WHERE id_feedback = p_id_feedback;

    IF v_comentariu IS NULL OR TRIM(v_comentariu) = '' THEN
        IF v_nota >= 8 THEN
            RETURN 'POZITIV';
        ELSIF v_nota <= 4 THEN
            RETURN 'NEGATIV';
        ELSE
            RETURN 'NEUTRU';
        END IF;
    END IF;

    v_comentariu := LOWER(v_comentariu);

    FOR i IN 1..ARRAY_LENGTH(v_cuvinte_pozitive, 1) LOOP
        IF v_comentariu LIKE '%' || v_cuvinte_pozitive[i] || '%' THEN
            v_scor := v_scor + 1;
        END IF;
    END LOOP;

    FOR i IN 1..ARRAY_LENGTH(v_cuvinte_negative, 1) LOOP
        IF v_comentariu LIKE '%' || v_cuvinte_negative[i] || '%' THEN
            v_scor := v_scor - 1;
        END IF;
    END LOOP;

    IF v_nota >= 8 THEN
        v_scor := v_scor + 1;
    ELSIF v_nota <= 4 THEN
        v_scor := v_scor - 1;
    END IF;

    IF v_scor > 0 THEN
        v_rezultat := 'POZITIV';
    ELSIF v_scor < 0 THEN
        v_rezultat := 'NEGATIV';
    ELSE
        v_rezultat := 'NEUTRU';
    END IF;

    RETURN v_rezultat;
END;
$$ LANGUAGE plpgsql;
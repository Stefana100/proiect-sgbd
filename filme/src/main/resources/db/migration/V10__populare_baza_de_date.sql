DO $$
DECLARE
    v_nume VARCHAR[] := ARRAY['Popescu', 'Ionescu', 'Radu', 'Stancu', 'Dumitru', 'Marin', 'Gheorghe', 'Ilie', 'Tudor', 'Dobre', 'Voinea', 'Mircea', 'Albu', 'Barbu', 'Cretu', 'Nita', 'Constantin', 'Toma', 'Vasile', 'Stanescu', 'Ene', 'Oprea', 'Stoica', 'Matei', 'Munteanu'];
    v_prenume VARCHAR[] := ARRAY['Andrei', 'Elena', 'Mihai', 'Ana', 'Cristian', 'Ioana', 'Alexandru', 'Diana', 'Vlad', 'Maria', 'Ionut', 'George', 'Stefan', 'Laura', 'Carmen', 'Bogdan', 'Catalin', 'Adrian', 'Mihaela', 'Alina', 'Cosmin', 'Florin', 'Gabriel', 'Andreea', 'Cristina'];
    v_actor_nume VARCHAR[] := ARRAY['Brando', 'Bale', 'Travolta', 'Hanks', 'DiCaprio', 'Pitt', 'Reeves', 'De Niro', 'Freeman', 'Crowe', 'McConaughey', 'Song', 'Duncan', 'Damon', 'Jackman', 'Nicholson', 'Simmons', 'Irons', 'Weaver', 'Pearce', 'Schwarzenegger', 'DiCaprio', 'Scheider', 'Stallone', 'Worthington'];
    v_actor_prenume VARCHAR[] := ARRAY['Marlon', 'Christian', 'John', 'Tom', 'Leonardo', 'Brad', 'Keanu', 'Robert', 'Morgan', 'Russell', 'Matthew', 'Kang-ho', 'Michael', 'Matt', 'Hugh', 'Jack', 'J.K.', 'Jeremy', 'Sigourney', 'Guy', 'Arnold', 'Leonardo', 'Roy', 'Sylvester', 'Sam'];
    v_strazi VARCHAR[] := ARRAY['Bulevardul Carol I', 'Strada Cuza Voda', 'Strada Sararie', 'Soseaua Arcu', 'Strada Lapusneanu', 'Bulevardul Independentei', 'Strada Pacurari', 'Strada Nicolina', 'Bulevardul Primaverii', 'Strada Victoriei'];
    v_domenii VARCHAR[] := ARRAY['gmail.com', 'yahoo.com', 'icloud.com', 'outlook.com'];
    v_filme VARCHAR[] := ARRAY['The Godfather', 'The Dark Knight', 'Pulp Fiction', 'Forrest Gump', 'Inception', 'Fight Club', 'The Matrix', 'Goodfellas', 'Se7en', 'Gladiator', 'Interstellar', 'Parasite', 'The Green Mile', 'Saving Private Ryan', 'The Prestige', 'The Departed', 'Whiplash', 'The Lion King', 'Alien', 'Memento', 'Terminator 2', 'Shutter Island', 'Jaws', 'Rocky', 'Avatar'];
    v_categorii VARCHAR[] := ARRAY['Crima', 'Actiune', 'Crima', 'Drama', 'Sci-Fi', 'Drama', 'Sci-Fi', 'Crima', 'Thriller', 'Istoric', 'Sci-Fi', 'Thriller', 'Drama', 'Razboi', 'Thriller', 'Crima', 'Drama', 'Animatie', 'Horror', 'Thriller', 'Sci-Fi', 'Thriller', 'Horror', 'Sport', 'Sci-Fi'];
    i INT;
    v_telefon_mobil VARCHAR(20);
    v_telefon_acasa VARCHAR(20);
    v_email VARCHAR(100);
    v_adresa VARCHAR(150);
    v_nota_random INT ;
    v_oras VARCHAR(50) := 'Iasi';
    v_limbi VARCHAR[] := ARRAY['Engleza', 'Romana', 'Franceza', 'Germana', 'Spaniola'];
    v_formate VARCHAR[] := ARRAY['Ultra HD 4K', 'Full HD 1080p', 'HD 720p', 'HDR Premium', 'HD 360 p'];
    v_rezolutii VARCHAR[] := ARRAY['3840x2160', '1920x1080', '2560x1440', '1280x720', '1024x576'];
    v_comentarii_pozitive VARCHAR[] := ARRAY['O capodopera, un film absolut excelent!', 'Mi-a placut la nebunie, este foarte bun.', 'Recomand tuturor, un scenariu emotionant.'];
    v_comentarii_negative VARCHAR[] := ARRAY['Destul de plictisitor, scenariu slab.', 'O pierdere de timp, foarte dezamagitor.', 'Groaznic, nu il recomand deloc.'];
BEGIN
    TRUNCATE TABLE feedback_optiuni_selectate, optiuni_feedback, feedback, vizualizari, distributie, actori, versiuni_film, filme, clienti RESTART IDENTITY CASCADE;
    INSERT INTO optiuni_feedback (denumire) VALUES
    ('mi-a placut'), ('nu mi-a placut'), ('interesant'), ('emotionant'),
    ('plictisitor'), ('as recomanda'), ('as mai viziona'),
    ('actor principal apreciat'), ('scenariu slab');
    FOR i IN 1..25 LOOP
        v_telefon_mobil := '07' ||
                           (floor(random() * (99 - 20 + 1)) + 20)::text || ' ' ||
                           (floor(random() * (999 - 100 + 1)) + 100)::text || ' ' ||
                           (floor(random() * (999 - 100 + 1)) + 100)::text;

        v_telefon_acasa := '0232 ' ||
                           (floor(random() * (999 - 100 + 1)) + 100)::text || ' ' ||
                           (floor(random() * (999 - 100 + 1)) + 100)::text;

        v_email := LOWER(v_prenume[i]) || '.' || LOWER(v_nume[i]) || i || '@' || v_domenii[MOD(i, 4) + 1];
        v_adresa := v_strazi[MOD(i, 10) + 1] || ', Nr. ' || (i * 2) || ', Bl. A' || MOD(i, 5) + 1 || ', Ap. ' || (i + 5);

        INSERT INTO clienti (nume, prenume, telefon_acasa, telefon_mobil, adresa, oras, email, data_nasterii)
        VALUES (v_nume[i], v_prenume[i], v_telefon_acasa, v_telefon_mobil, v_adresa, v_oras, v_email, CAST('1992-05-15' AS DATE) + (i * 100 * INTERVAL '1 day'));

        INSERT INTO filme (titlu, descriere, categorie, data_lansarii, durata)
        VALUES (
            v_filme[i],
            'Productie artistica din categoria ' || v_categorii[i],
            v_categorii[i],
            CURRENT_DATE - (i * 100),
            CASE WHEN i % 2 = 0 THEN 120 ELSE 110 END
        );

       INSERT INTO actori (nume, prenume, nume_scena, data_nasterii)
               VALUES (v_actor_nume[i], v_actor_prenume[i], v_actor_prenume[i] || ' ' || v_actor_nume[i], CAST('1960-01-01' AS DATE) + (i * 365 * INTERVAL '1 day'));
    END LOOP;
    FOR i IN 1..25 LOOP
        INSERT INTO versiuni_film (id_film, format_video, limba, rezolutie)
        VALUES (i, v_formate[MOD(i, 5) + 1], v_limbi[MOD(i, 5) + 1], v_rezolutii[MOD(i, 3) + 1]);
        INSERT INTO versiuni_film (id_film, format_video, limba, rezolutie)
        VALUES (i, 'Standard', v_limbi[MOD(i + 1, 5) + 1], v_rezolutii[MOD(i, 2) + 4]);

        INSERT INTO distributie (id_film, id_actor, rol, comentariu_prestatie)
            VALUES ( i,  i, 'Protagonist',
                CASE
                    WHEN random() > 0.2 THEN 'O interpretare remarcabila.'
                    ELSE 'O prestatie surprinzator de stearsa pentru un rol principal.'
                END
            );
            FOR j IN 1..(floor(random() * 3))::int LOOP
                DECLARE
                    v_nota_prestatie FLOAT := random();
                BEGIN
                    INSERT INTO distributie (id_film, id_actor, rol, comentariu_prestatie)
                    VALUES (  i,((i + j) % 25) + 1,
                        CASE
                            WHEN j = 1 THEN 'Antagonist'
                            ELSE 'Rol Secundar'
                        END,
                        CASE
                            WHEN v_nota_prestatie > 0.7 THEN 'Prestatie artistica deosebita.'
                            WHEN v_nota_prestatie > 0.4 THEN 'Interpretare corecta, dar fara stralucire.'
                            ELSE 'Prestatie scazuta, actorul nu s-a adaptat rolului.'
                        END
                    );
                END;
            END LOOP;

              INSERT INTO vizualizari (id_client, id_versiune, data_vizualizare, durata_minute, stare_vizualizare)
              VALUES ( i,(i*2)-1,('2026-' || (MOD(i-1, 12) + 1) || '-10 20:00')::timestamp,
                  CASE
                      WHEN i % 5 = 0 THEN 0
                      WHEN i % 5 = 1 THEN 10
                      WHEN i % 5 = 2 THEN 45
                      ELSE (CASE WHEN i % 2 = 0 THEN 120 ELSE 110 END)
                  END,
                  CASE
                      WHEN i % 5 = 0 THEN 'INCEPUT'
                      WHEN i % 5 = 1 THEN 'ABANDONAT'
                      WHEN i % 5 = 2 THEN 'IN CURS'
                      ELSE 'FINALIZAT'
                  END
              );
                  v_nota_random := floor(random() * 10) + 1;
                  INSERT INTO feedback (id_client, id_film, nota, comentariu, data_postare)
                  VALUES (i, i, v_nota_random,
                      CASE
                          WHEN v_nota_random >= 8 THEN v_comentarii_pozitive[MOD(i, 3) + 1]
                          WHEN v_nota_random <= 4 THEN v_comentarii_negative[MOD(i, 3) + 1]
                          ELSE 'Un film interesant, merita vazut macar o data.'
                      END,
                      CURRENT_DATE - (MOD(i, 15) * INTERVAL '1 day')
                  );
    END LOOP;

    INSERT INTO feedback_optiuni_selectate (id_feedback, id_optiune)
    SELECT id_feedback, 1 FROM feedback WHERE nota >= 8;
    INSERT INTO feedback_optiuni_selectate (id_feedback, id_optiune)
    SELECT id_feedback, 3 FROM feedback WHERE nota BETWEEN 6 AND 7;
    INSERT INTO feedback_optiuni_selectate (id_feedback, id_optiune)
    SELECT id_feedback, 9 FROM feedback WHERE nota <= 5;

END $$;
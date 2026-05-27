package com.platforma.filme.service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
public class PlatformaService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> getAllFilme() {
        return jdbcTemplate.queryForList("SELECT * FROM filme ORDER BY id_film");
    }

    public Map<String, Object> getFilmById(Integer id) {
        return jdbcTemplate.queryForMap("SELECT * FROM filme WHERE id_film = ?", id);
    }

    public List<Map<String, Object>> getVersiuniFilm(Integer idFilm) {
        String sql = "SELECT id_versiune, format_video, limba, rezolutie FROM versiuni_film WHERE id_film = ?";
        return jdbcTemplate.queryForList(sql, idFilm);
    }

    public List<Map<String, Object>> getOptiuniFeedback() {
        return jdbcTemplate.queryForList("SELECT * FROM optiuni_feedback");
    }

    public Integer saveClient(Map<String, String> p) {
        String sql = "INSERT INTO clienti (nume, prenume, email, telefon_mobil, telefon_acasa, oras, adresa, data_nasterii) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, CAST(? AS DATE)) RETURNING id_client";

        return jdbcTemplate.queryForObject(sql, Integer.class,
                p.get("nume"),
                p.get("prenume"),
                p.get("email"),
                p.get("telefon_mobil"),
                p.get("telefon_acasa"),
                p.get("oras"),
                p.get("adresa"),
                p.get("data_nasterii"));
    }
    public boolean existaClient(String email) {
        String sql = "SELECT COUNT(*) FROM clienti WHERE email = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }
    public boolean verificaAutentificare(String nume, String prenume, String telefon) {
        String sql = "SELECT COUNT(*) FROM clienti WHERE nume = ? AND prenume = ? AND telefon_mobil = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, nume, prenume, telefon);
        return count != null && count > 0;
    }
    public String getPredictiePentruLuna(int luna) {
        String sql = "SELECT predictie_categorie_sezon(?)";
        try {
            return jdbcTemplate.queryForObject(sql, String.class, luna);
        } catch (Exception e) {
            return "Nu am gasit date suficiente pentru luna selectata.";
        }
    }
    @Transactional(readOnly = true)
    public List<Map<String, Object>> getRecomandariPentruClient(Integer idClient) {
        if (idClient == null) return List.of();

        String sqlSql = "SELECT * FROM obtine_recomandari_client(?)";
        List<String> titluri = jdbcTemplate.queryForList(sqlSql, String.class, idClient);

        return titluri.stream().map(titlu -> {
            try {
                return jdbcTemplate.queryForMap("SELECT id_film, titlu FROM filme WHERE titlu = ?", titlu);
            } catch (Exception e) {
                return null;
            }
        }).filter(m -> m != null).toList();
    }
    @Transactional
    public String proceseazaFeedback(int idFilm, int nota, String comentariu, List<Integer> optiuniIds, int idClient) {
        String sqlFeedback = "INSERT INTO feedback (id_client, id_film, nota, comentariu, data_postare) " +
                "VALUES (?, ?, ?, ?, CURRENT_DATE) RETURNING id_feedback";

        Integer idFeedback = jdbcTemplate.queryForObject(sqlFeedback, Integer.class, idClient, idFilm, nota, comentariu);

        if (optiuniIds != null && !optiuniIds.isEmpty()) {
            for (Integer idOptiune : optiuniIds) {
                jdbcTemplate.update("INSERT INTO feedback_optiuni_selectate (id_feedback, id_optiune) VALUES (?, ?)",
                        idFeedback, idOptiune);
            }
        }
        return jdbcTemplate.queryForObject("SELECT analiza_sentiment_feedback(?)", String.class, idFeedback);
    }

    public List<Map<String, Object>> getPredictiiSezoniere() {
        return jdbcTemplate.queryForList("SELECT * FROM predictii_sezoniere()");
    }
    public int obtineSauCreeazaVersiune(int idFilm, String format, String rezolutie, String limba) {
        String sqlCheck = "SELECT id_versiune FROM versiuni_film WHERE id_film = ? AND format_video = ? AND rezolutie = ? AND limba = ? LIMIT 1";
        List<Integer> ids = jdbcTemplate.queryForList(sqlCheck, Integer.class, idFilm, format, rezolutie, limba);

        if (!ids.isEmpty()) {
            return ids.get(0);
        }

        String sqlInsert = "INSERT INTO versiuni_film (id_film, format_video, rezolutie, limba) VALUES (?, ?, ?, ?) RETURNING id_versiune";
        return jdbcTemplate.queryForObject(sqlInsert, Integer.class, idFilm, format, rezolutie, limba);
    }
    public Integer obtineIdClient(String nume, String prenume, String telefon) {
        String sql = "SELECT id_client FROM clienti WHERE nume = ? AND prenume = ? AND telefon_mobil = ?";
        try {
            return jdbcTemplate.queryForObject(sql, Integer.class, nume, prenume, telefon);
        } catch (Exception e) {
            return null;
        }
    }
    public void insertVizualizareFinala(int idVersiune, int idClient, int durataReala) {
        String sql = "CALL adauga_vizualizare(?, ?, ?)";
        try {
            jdbcTemplate.update(sql, idClient, idVersiune, durataReala);

            System.out.println("DEBUG: Procedura executata pentru Client " + idClient +
                    " - Timp petrecut: " + durataReala + " minute.");
        } catch (Exception e) {
            System.err.println("Eroare la apelul procedurii: " + e.getMessage());
        }
    }
    @Transactional
    public void stergeClient(int idClient) {
        jdbcTemplate.update("DELETE FROM clienti WHERE id_client = ?", idClient);
    }
}
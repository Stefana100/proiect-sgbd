package com.platforma.filme.controller;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.platforma.filme.service.PlatformaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
import java.util.List;

@Controller
public class PlatformaController {
    @Autowired
    private PlatformaService platformaService;

    @GetMapping("/")
    public String index() {
        return "login";
    }
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }
    @GetMapping("/browse")
    public String browsePage(Model model, HttpSession session) {
        model.addAttribute("filme", platformaService.getAllFilme());
        Integer idClient = (Integer) session.getAttribute("idClientLogat");
        if (idClient != null) {
            model.addAttribute("recomandari", platformaService.getRecomandariPentruClient(idClient));
        }

        return "index";
    }
    @GetMapping("/film/{id}")
    public String detailPage(@PathVariable Integer id, Model model) {
        model.addAttribute("film", platformaService.getFilmById(id));
        model.addAttribute("formate", List.of("Ultra HD 4K", "Full HD 1080p", "HD 720p", "HDR Premium", "HD 360 p"));
        model.addAttribute("limbi", List.of("Engleza", "Romana", "Franceza", "Germana", "Spaniola"));
        model.addAttribute("rezolutii", List.of("3840x2160", "1920x1080", "2560x1440", "1280x720", "1024x576"));
        model.addAttribute("versiuni", platformaService.getVersiuniFilm(id));
        model.addAttribute("optiuni", platformaService.getOptiuniFeedback());
        return "detalii";
    }
    @GetMapping("/statistici")
    public String statsPage(@RequestParam(name = "luna", required = false) Integer luna, Model model) {
        if (luna != null) {
            String rezultat = platformaService.getPredictiePentruLuna(luna);
            model.addAttribute("predictie", rezultat);
        }
        return "statistici";
    }
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
    @PostMapping("/clienti/login")
    public String loginClient(@RequestParam String nume,
                              @RequestParam String prenume,
                              @RequestParam String telefon_mobil,
                              HttpSession session,
                              Model model) {
        Integer idClient = platformaService.obtineIdClient(nume, prenume, telefon_mobil);
        boolean esteValid = platformaService.verificaAutentificare(nume, prenume, telefon_mobil);

        if (idClient != null) {
            session.setAttribute("idClientLogat", idClient);
            return "redirect:/browse";
        } else {
            model.addAttribute("eroare", "Datele introduse sunt incorecte!");
            return "login";
        }
    }
    @PostMapping("/film/salveaza-vizualizare")
    public String salveazaFinal(@RequestParam int idVersiune,
                                @RequestParam int idFilm,
                                @RequestParam int durataMinute,
                                HttpSession session) {

        Integer idClient = (Integer) session.getAttribute("idClientLogat");

        if (idClient != null) {
            platformaService.insertVizualizareFinala(idVersiune, idClient, durataMinute);
        }

        return "redirect:/film/" + idFilm;
    }
    @PostMapping("/clienti/register")
    public String registerClient(@RequestParam Map<String, String> params, HttpSession session) {
        String email = params.get("email");
        if (platformaService.existaClient(email)) {
            return "redirect:/login";
        }
        Integer noulIdClient = platformaService.saveClient(params);
        session.setAttribute("idClientLogat", noulIdClient);
        return "redirect:/browse";
    }
    @PostMapping("/film/feedback")
    public String trimiteFeedback(@RequestParam int id_film,
                                  @RequestParam int nota,
                                  @RequestParam String comentariu,
                                  @RequestParam(required = false) List<Integer> optiuni_id,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {

        Integer idClient = (Integer) session.getAttribute("idClientLogat");

        if (idClient == null) {
            idClient = 1;
        }

        String sentiment = platformaService.proceseazaFeedback(id_film, nota, comentariu, optiuni_id, idClient);

        redirectAttributes.addFlashAttribute("analizaSentiment", sentiment);

        return "redirect:/film/" + id_film;
    }

    @PostMapping("/film/vizionare")
    public String pornesteVizionare(@RequestParam int id_film,
                                    @RequestParam String format,
                                    @RequestParam String rezolutie,
                                    @RequestParam String limba,
                                    Model model) {

        int idVersiune = platformaService.obtineSauCreeazaVersiune(id_film, format, rezolutie, limba);

        model.addAttribute("film", platformaService.getFilmById(id_film));
        model.addAttribute("idVersiune", idVersiune);

        return "player";
    }
    @PostMapping("/clienti/stergere")
    public String stergeCont(HttpSession session) {
        Integer idClient = (Integer) session.getAttribute("idClientLogat");
        if (idClient != null) {
            platformaService.stergeClient(idClient);
            session.invalidate();
        }
        return "redirect:/login";
    }
}
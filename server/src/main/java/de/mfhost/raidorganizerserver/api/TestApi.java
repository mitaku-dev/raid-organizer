package de.mfhost.raidorganizerserver.api;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class TestApi {


    //TODO only test
    @GetMapping(value = "/login/discord", produces = MediaType.TEXT_HTML_VALUE)
    public ResponseEntity<String> loginWithDiscord() {

        String html = "<!DOCTYPE html>\n" +
                "<title>Authentication complete</title>\n" +
                "<p>Authentication is complete. If this does not happen automatically, please\n" +
                "    close the window.\n" +
                "    <script>\n" +
                "        window.opener.postMessage({\n" +
                "            'flutter-web-auth': window.location.href\n" +
                "        }, window.location.origin);\n" +
                "        window.close();\n" +
                "    </script>";

        //generate Tokens and return them
        return ResponseEntity.ok(html);
    }

}

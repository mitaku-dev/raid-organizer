package de.mfhost.raidorganizerserver.security.discord;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class OAuth2Service {

    private final RestTemplate restTemplate;

    private final String BASE_URL = "https://discord.com/api";

    public OAuth2Service(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String loginWithDiscord(AuthDiscordRequest request){

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(request.getToken());
        HttpEntity<String> httpEntity = new HttpEntity<>("", headers);

        ResponseEntity<String> data = this.restTemplate.exchange(BASE_URL +"/users/@me", HttpMethod.GET, httpEntity ,String.class);
        return data.getBody();
    }

}

package de.mfhost.raidorganizerserver.security.discord;


import de.mfhost.raidorganizerserver.dto.AuthResponse;
import de.mfhost.raidorganizerserver.security.AuthenticationProvider;
import de.mfhost.raidorganizerserver.security.JwtTokenUtils;
import de.mfhost.raidorganizerserver.security.RefreshTokenService;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import liquibase.pro.packaged.J;
import liquibase.pro.packaged.O;
import net.minidev.json.JSONObject;
import net.minidev.json.JSONValue;
import net.minidev.json.parser.JSONParser;
import net.minidev.json.parser.ParseException;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
public class OAuth2Service {

    private final RestTemplate restTemplate;
    private final UserRepository userRepository;
    private final JwtTokenUtils jwtTokenUtils;
    private final RefreshTokenService refreshTokenService;

    private final String BASE_URL = "https://discord.com/api";


    @Value("${spring.security.oauth2.client.registration.discord.client-id}")
    private String clientId;
    @Value("${spring.security.oauth2.client.registration.discord.client-secret}")
    private String clientSecret;
    private String redirectUri ="http://localhost:8080/login/oauth2/code/discord";


    public OAuth2Service(RestTemplate restTemplate, UserRepository userRepository, JwtTokenUtils jwtTokenUtils, RefreshTokenService refreshTokenService) {
        this.restTemplate = restTemplate;
        this.userRepository = userRepository;
        this.jwtTokenUtils = jwtTokenUtils;
        this.refreshTokenService = refreshTokenService;
    }


    public String getTokenFromDiscord(String code) throws OAuth2ServiceException{

        HttpHeaders headers = new HttpHeaders();
        headers.setBasicAuth(new String(Base64.encodeBase64((clientId+":"+clientSecret).getBytes())));
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String body = "grant_type=authorization_code&code="+code+"&redirect_uri="+redirectUri;

        String uri = BASE_URL +"/oauth2/token";

        HttpEntity<String> httpEntity = new HttpEntity<>(body, headers);
        ResponseEntity<String> data = this.restTemplate.exchange(uri, HttpMethod.POST, httpEntity ,String.class);

        if(data.getStatusCode().is2xxSuccessful()) {
            JSONParser parser = new JSONParser();
            JSONObject json = null;
            try {
                json = (JSONObject) parser.parse(data.getBody());
            } catch (ParseException e) {
               throw new OAuth2ServiceException();
            }

            return  json.getAsString("access_token");
        } else {
            throw new OAuth2ServiceException();
        }


    }

    public AuthResponse loginWithDiscord(AuthDiscordRequest request) throws OAuth2ServiceException{


        String token = getTokenFromDiscord(request.getToken());

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        HttpEntity<String> httpEntity = new HttpEntity<>("", headers);

        ResponseEntity<String> data = this.restTemplate.exchange(BASE_URL +"/users/@me", HttpMethod.GET, httpEntity ,String.class);


        String email = "";
        String name = "";

        String st = data.getBody();
        JSONParser parser = new JSONParser();
        JSONObject json = null;
        try {
            json = (JSONObject) parser.parse(data.getBody());
            email = json.getAsString("email");
            name = json.getAsString("username");
        } catch (ParseException e) {
            throw new OAuth2ServiceException();
        }



        return onDiscordSuccessLogin(email,name);
    }


    public AuthResponse onDiscordSuccessLogin(String email, String name) {

        AuthResponse response;

        Optional<User> userOpt = userRepository.findByEmail(email);
        if(userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getAuth_provider() == AuthenticationProvider.DISCORD) {

                response = AuthResponse.builder()
                        .id(user.getId())
                        .token(jwtTokenUtils.generateAccessToken(user))
                        .username(user.getUsername())
                        .refreshToken(refreshTokenService.createRefreshToken(user).getToken())
                .build();
            }else {
                response = null;
            }

        } else {


            User user = new User(name, email, AuthenticationProvider.DISCORD);
            userRepository.save(user);

            response = AuthResponse.builder()
                    .id(user.getId())
                    .token(jwtTokenUtils.generateAccessToken(user))
                    .username(user.getUsername())
                    .refreshToken(refreshTokenService.createRefreshToken(user).getToken())
                    .build();

        }

        return response;
    }

}

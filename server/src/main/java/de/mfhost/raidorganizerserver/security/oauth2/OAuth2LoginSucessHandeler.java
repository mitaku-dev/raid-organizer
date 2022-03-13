package de.mfhost.raidorganizerserver.security.oauth2;

import de.mfhost.raidorganizerserver.dto.AuthResponse;
import de.mfhost.raidorganizerserver.security.discord.OAuth2Service;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@Component

public class OAuth2LoginSucessHandeler extends SimpleUrlAuthenticationSuccessHandler {

    private OAuth2Service oAuth2Service;

    //TODO?
    public void setoAuth2Service(OAuth2Service oAuth2Service){
        this.oAuth2Service = oAuth2Service;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {


        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getEmail();
        String name = oAuth2User.getName();


        AuthResponse authResponse = oAuth2Service.onDiscordSuccessLogin(email,name);

        response.setHeader("token",authResponse.getToken());
        response.setHeader("refresh_token",authResponse.getRefreshToken());


        super.onAuthenticationSuccess(request,response, authentication);
    }
}

package de.mfhost.raidorganizerserver.security.oauth2;

import de.mfhost.raidorganizerserver.security.AuthenticationProvider;
import de.mfhost.raidorganizerserver.security.JwtTokenUtils;
import de.mfhost.raidorganizerserver.security.RefreshTokenService;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import de.mfhost.raidorganizerserver.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

@Component
@RequiredArgsConstructor
public class OAuth2LoginSucessHandeler extends SimpleUrlAuthenticationSuccessHandler {


    private final UserRepository userRepository;
   // private final UserService userService;

    private final JwtTokenUtils jwtTokenUtils;
    private final RefreshTokenService refreshTokenService;



    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {


        System.out.println("LOGIN Sucess");

        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getEmail();
        String name = oAuth2User.getName();


        Optional<User> userOpt = userRepository.findByEmail(email);
        if(userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getAuth_provider() == AuthenticationProvider.DISCORD) {
                response.setHeader("token",jwtTokenUtils.generateAccessToken(user));
                response.setHeader("refresh_token",refreshTokenService.createRefreshToken(user).getToken());
            }
        } else {


            User user = new User(name, email, AuthenticationProvider.DISCORD);
            userRepository.save(user);


           response.setHeader("token",jwtTokenUtils.generateAccessToken(user));
           response.setHeader("refresh_token",refreshTokenService.createRefreshToken(user).getToken());

        }



        super.onAuthenticationSuccess(request,response, authentication);
    }
}

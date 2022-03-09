package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.Exception.TokenRefreshException;
import de.mfhost.raidorganizerserver.dto.AuthRequest;
import de.mfhost.raidorganizerserver.dto.AuthResponse;
import de.mfhost.raidorganizerserver.dto.CreateUserRequest;
import de.mfhost.raidorganizerserver.security.*;
import de.mfhost.raidorganizerserver.security.discord.AuthDiscordRequest;
import de.mfhost.raidorganizerserver.security.discord.OAuth2Service;
import de.mfhost.raidorganizerserver.security.discord.OAuth2ServiceException;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Required;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.xml.bind.ValidationException;

@Controller
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthApi {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtils jwtTokenUtils;
    private final UserService userService;
    private final RefreshTokenService refreshTokenService;
    private final OAuth2Service oAuth2Service;


    @PostMapping(value="/login/discord")
    public ResponseEntity<AuthResponse> loginWithDiscord(@RequestBody AuthDiscordRequest request) throws OAuth2ServiceException {
        AuthResponse data = oAuth2Service.loginWithDiscord(request);


        return ResponseEntity.ok(data);
    }

    @PostMapping(value = "/login")
    public ResponseEntity<AuthResponse> login(@RequestBody AuthRequest request) { try {

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );
        System.out.println(authentication);
            User user = (User) authentication.getPrincipal();

        System.out.println(user);

            return ResponseEntity.ok()
                    .header(HttpHeaders.AUTHORIZATION, jwtTokenUtils.generateAccessToken(user))
                    .body(AuthResponse.builder()
                            .id(user.getId())
                            .username(user.getUsername())
                            .token(jwtTokenUtils.generateAccessToken(user))
                            .refreshToken(refreshTokenService.createRefreshToken(user).getToken()).build()
                    );

       } catch(BadCredentialsException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
       }

    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody CreateUserRequest request) {
        try {
            User user = userService.create(request);
            AuthResponse response = AuthResponse.builder()
                    .id(user.getId())
                    .username(user.getUsername())
                    .token(jwtTokenUtils.generateAccessToken(user))
                    .refreshToken(refreshTokenService.createRefreshToken(user).getToken()).build();
            return ResponseEntity.ok().body(response);
        } catch(ValidationException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

    }


    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@RequestBody RefreshTokenRequest request) {

        String requestRefreshToken = request.getRefreshToken();

        return refreshTokenService.findByToken(requestRefreshToken)
                .map(refreshTokenService::verifyExpiration)
                .map(RefreshToken::getUser)
                .map(user -> {
                    refreshTokenService.deleteByUserId(user.getId()); // delete old token
                    return ResponseEntity.ok(AuthResponse.builder()
                            .id(user.getId())
                            .username(user.getUsername())
                            .token(jwtTokenUtils.generateAccessToken(user))
                            .refreshToken(refreshTokenService.createRefreshToken(user).getToken()).build());
                })
                .orElseThrow(() -> new TokenRefreshException(requestRefreshToken,
                        "Refresh token is not in database!"));

    }

}

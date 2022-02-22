package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.dto.AuthRequest;
import de.mfhost.raidorganizerserver.dto.AuthResponse;
import de.mfhost.raidorganizerserver.dto.CreateUserRequest;
import de.mfhost.raidorganizerserver.security.JwtTokenUtils;
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
public class AuthApi {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenUtils jwtTokenUtils;
    private final UserService userService;


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
                    .body(AuthResponse.fromUser(user));

       } catch(BadCredentialsException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
       }

    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody CreateUserRequest request) {
        try {
            AuthResponse response = AuthResponse.fromUser(userService.create(request));
            return ResponseEntity.ok().body(response);
        } catch(ValidationException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }

    }

    //TODO delete
    @GetMapping("/api/public/user")
    public ResponseEntity<Iterable<User>> user() {
        return  ResponseEntity.ok().body(
                userService.getAllUser()
        );

    }

}

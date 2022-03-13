package de.mfhost.raidorganizerserver.user;


import de.mfhost.raidorganizerserver.dto.ChangePasswordRequest;
import de.mfhost.raidorganizerserver.dto.CreateUserRequest;
import de.mfhost.raidorganizerserver.security.AuthenticationProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import javax.xml.bind.ValidationException;

import static java.lang.String.format;

@Component
@RequiredArgsConstructor
public class UserService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username)
                .orElseThrow(
                        () -> new UsernameNotFoundException(format("User with username - %s, not found", username))
                );
    }


    public User create(CreateUserRequest request) throws ValidationException {

        if(!request.getPassword().equals(request.getPasswordRepeat())) {
            throw new ValidationException("Passoword does not repeat");
        }

        if(userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new ValidationException("Username exists!");
        }

        User user = User.builder()
                .email(request.getEmail())
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .enabled(true)
                .build();
        return userRepository.save(user);
    }


    public ResponseEntity<Boolean> changePassword(ChangePasswordRequest request) {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if(principal instanceof User) {
            User user = (User) principal;
            /*
            Long userId = ((User) principal).getId();
            User user = userRepository.getById(userId);
        */

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(user.getUsername(), request.getOldPassword())
            );
            User authenticatedUser = (User) authentication.getPrincipal();
            if(authenticatedUser != null) {
                user.setPassword(passwordEncoder.encode(request.getNewPassword()));
                userRepository.save(user);
                return ResponseEntity.ok(true);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }

        }
        return ResponseEntity.badRequest().build();
    }

    public User createWithOAuth(String email, String name, AuthenticationProvider provider) {
       User user = new User(name, email, provider);
       return userRepository.save(user);
    }

    public void updateOAuth(User user, String name, AuthenticationProvider provider ) {
        //TODO connect wth Discord
    }

    public Iterable<User> getAllUser() {
        return userRepository.findAll();
    }

}

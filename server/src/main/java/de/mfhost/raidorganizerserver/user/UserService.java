package de.mfhost.raidorganizerserver.user;


import de.mfhost.raidorganizerserver.dto.CreateUserRequest;
import de.mfhost.raidorganizerserver.security.AuthenticationProvider;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import javax.transaction.Transactional;
import javax.xml.bind.ValidationException;

import static java.lang.String.format;

@Component
@RequiredArgsConstructor
public class UserService implements UserDetailsService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByUsername(username)
                .orElseThrow(
                        () -> new UsernameNotFoundException(format("User with username - %s, not found", username))
                );
    }


    public User create(CreateUserRequest request) throws ValidationException {

        if(userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new ValidationException("Username exists!");
        }

        User user = new User(
                request.getUsername(),
                passwordEncoder.encode(request.getPassword())
        );
        return userRepository.save(user);
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

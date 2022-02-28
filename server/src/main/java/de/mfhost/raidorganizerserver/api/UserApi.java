package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserApi {

    private final UserRepository userRepository;

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        User user = userRepository.getById(id);
        return ResponseEntity.ok(user);
    }

}

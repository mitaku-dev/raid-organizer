package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.dto.ChangePasswordRequest;
import de.mfhost.raidorganizerserver.security.RefreshToken;
import de.mfhost.raidorganizerserver.security.RefreshTokenRepository;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import de.mfhost.raidorganizerserver.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.transaction.Transactional;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserApi {

    private final UserRepository userRepository;
    private final UserService userService;
    private final RefreshTokenRepository refreshTokenRepository;


    @GetMapping("/me")
    public ResponseEntity<User> getMe() {

        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        //TODO maybe only UserDetails??
        if(principal instanceof User) {
            Long userId = ((User) principal).getId();
            User user = userRepository.findById(userId).orElseThrow();
            return ResponseEntity.ok(user);

        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        User user = userRepository.getById(id);
        return ResponseEntity.ok(user);
    }


    @Transactional
    @DeleteMapping("/me")
    public ResponseEntity<Boolean> delete() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        //TODO maybe only UserDetails??
        if(principal instanceof User) {
            Long userId = ((User) principal).getId();

            //TODO
            refreshTokenRepository.deleteByUser((User) principal);
            userRepository.deleteById(userId);

            //TODO delete refreshTokens cascade etc.

            return ResponseEntity.ok(true);
        }
        return ResponseEntity.badRequest().build();
    }

    @PostMapping("/me/password")
    public ResponseEntity<Boolean> changePassword(@RequestBody ChangePasswordRequest request) {
      return userService.changePassword(request);
    }



    //TODO change pw


}

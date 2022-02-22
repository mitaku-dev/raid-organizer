package de.mfhost.raidorganizerserver.dto;

import de.mfhost.raidorganizerserver.user.User;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponse {

    private Long id;
    private String username;

    public static AuthResponse fromUser(User user) {
        return new AuthResponse(user.id, user.username);
    }

}

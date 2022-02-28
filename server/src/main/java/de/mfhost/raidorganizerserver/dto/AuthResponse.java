package de.mfhost.raidorganizerserver.dto;

import de.mfhost.raidorganizerserver.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class AuthResponse {

    private Long id;
    private String username;
    private String token;
    private String refreshToken;


}

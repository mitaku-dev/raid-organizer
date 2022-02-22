package de.mfhost.raidorganizerserver.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CreateUserRequest {

    private String username;
    private String password;

}

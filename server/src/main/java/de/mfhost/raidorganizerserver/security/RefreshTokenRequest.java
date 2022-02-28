package de.mfhost.raidorganizerserver.security;


import lombok.Data;

@Data
public class RefreshTokenRequest {

    private String refreshToken;

}
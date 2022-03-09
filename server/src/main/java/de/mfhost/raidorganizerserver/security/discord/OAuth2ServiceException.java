package de.mfhost.raidorganizerserver.security.discord;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "The authorization with discord failed")
public class OAuth2ServiceException extends Exception{
}

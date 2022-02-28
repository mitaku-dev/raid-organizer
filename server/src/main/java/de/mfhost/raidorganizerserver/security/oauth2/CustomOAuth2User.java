package de.mfhost.raidorganizerserver.security.oauth2;

import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Map;

@RequiredArgsConstructor
@Data
public class CustomOAuth2User implements org.springframework.security.oauth2.core.user.OAuth2User {


    private OAuth2User oAuth2User;

    CustomOAuth2User(OAuth2User user) {
        this.oAuth2User = user;
    }


    @Override
    public Map<String, Object> getAttributes() {
        return oAuth2User.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return oAuth2User.getAuthorities();
    }

    @Override
    public String getName() {
        return oAuth2User.getAttribute("username");
    }


    public String getEmail() {
        return oAuth2User.getAttribute("email");
    }
}

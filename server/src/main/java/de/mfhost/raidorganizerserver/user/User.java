package de.mfhost.raidorganizerserver.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import de.mfhost.raidorganizerserver.models.Job;
import de.mfhost.raidorganizerserver.security.AuthenticationProvider;
import de.mfhost.raidorganizerserver.security.RefreshToken;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@Data
@EqualsAndHashCode
@Table(name="users")
@Builder
@AllArgsConstructor
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String username;
    private String email;

    @JsonIgnore
    private String password;
    private String profilePicUrl;

    @Enumerated(EnumType.STRING)
    private AuthenticationProvider auth_provider;

    @ElementCollection
    private List<Job> jobs;

    private String lodestoneUrl;
    private String fflogsUrl;

    @JsonIgnore
    private boolean enabled = true;

    public User() {}


    public User(String username, String email, AuthenticationProvider provider) {
        this.username = username;
        this.email = email;
        this.auth_provider = provider;

        this.jobs = new ArrayList<>();
        this.enabled = true;

    }

    @Builder
    public User(String username, String password) {
        this.username = username;
        this.password = password;
        this.jobs = new ArrayList<>();
        this.enabled = true;

    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null;
    }

    @Override
    public boolean isAccountNonExpired() {
        return enabled;
    }

    @Override
    public boolean isAccountNonLocked() {
        return enabled;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return enabled;
    }

    @Override
    public boolean isEnabled() {
        return enabled;
    }
}

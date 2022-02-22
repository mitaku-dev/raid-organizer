package de.mfhost.raidorganizerserver.user;

import de.mfhost.raidorganizerserver.security.UserDetailsService;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<Integer, User> {

    @Cacheable
    Optional<User> findByUsername(String username);
}

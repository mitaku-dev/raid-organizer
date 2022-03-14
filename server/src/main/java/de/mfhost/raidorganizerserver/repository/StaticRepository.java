package de.mfhost.raidorganizerserver.repository;

import de.mfhost.raidorganizerserver.models.Static;
import de.mfhost.raidorganizerserver.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StaticRepository extends JpaRepository<Static,Long> {

}

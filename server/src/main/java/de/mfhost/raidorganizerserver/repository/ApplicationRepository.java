package de.mfhost.raidorganizerserver.repository;

import de.mfhost.raidorganizerserver.models.Application;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ApplicationRepository extends JpaRepository<Application, Long> {
}

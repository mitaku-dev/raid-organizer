package de.mfhost.raidorganizerserver.repository;

import de.mfhost.raidorganizerserver.models.Image;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ImageRepository extends JpaRepository<Image, Long> {
}

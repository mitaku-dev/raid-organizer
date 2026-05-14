package de.mfhost.raidorganizerserver.repository;

import de.mfhost.raidorganizerserver.models.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
}

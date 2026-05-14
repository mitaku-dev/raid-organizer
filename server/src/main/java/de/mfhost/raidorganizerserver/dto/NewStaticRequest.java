package de.mfhost.raidorganizerserver.dto;

import de.mfhost.raidorganizerserver.models.Schedule;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
@NoArgsConstructor
public class NewStaticRequest {
    private String name;
    private Long leadId;
    private List<Schedule> schedules;

}

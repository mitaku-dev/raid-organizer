package de.mfhost.raidorganizerserver.dto;

import de.mfhost.raidorganizerserver.models.Job;
import lombok.Data;

@Data
public class MemberId {

    private Long userId;
    private Job job;

}
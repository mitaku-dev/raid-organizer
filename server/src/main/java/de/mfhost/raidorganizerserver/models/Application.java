package de.mfhost.raidorganizerserver.models;

import de.mfhost.raidorganizerserver.user.User;
import lombok.*;

import javax.persistence.*;

@Entity
@Data
@NoArgsConstructor
@Builder
@AllArgsConstructor
public class Application {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;

    @ManyToOne
    User user;

    Job job;

    String text;




}

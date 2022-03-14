package de.mfhost.raidorganizerserver.models;

import de.mfhost.raidorganizerserver.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Data
@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Static {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String name;

    @OneToMany(cascade = CascadeType.ALL)
    private List<Member> members;

    @OneToMany
    private List<Application> applications;

    private String staticImageUrl;


    @ManyToOne
    @JoinColumn(name = "lead_id", referencedColumnName = "id")
    private User lead;


    @OneToMany
    private List<Schedule> schedules;


    public Static(String name, User lead) {
        this.name = name;
        this.lead = lead;
    }

    public void addMember(User user, Job job) {
        members.add(
                Member.builder()
                        .job(job)
                        .user(user)
                        .build()
        );
    }

    public void apply(Application application) {
        applications.add(application);
    }

}

package de.mfhost.raidorganizerserver.service;

import de.mfhost.raidorganizerserver.dto.MemberId;
import de.mfhost.raidorganizerserver.dto.NewStaticRequest;
import de.mfhost.raidorganizerserver.models.Application;
import de.mfhost.raidorganizerserver.models.Member;
import de.mfhost.raidorganizerserver.models.Schedule;
import de.mfhost.raidorganizerserver.models.Static;
import de.mfhost.raidorganizerserver.repository.ApplicationRepository;
import de.mfhost.raidorganizerserver.repository.ScheduleRepository;
import de.mfhost.raidorganizerserver.repository.StaticRepository;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.scheduling.annotation.Schedules;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
@Transactional
public class StaticService {

    private final UserRepository userRepository;
    private final StaticRepository staticRepository;
    private final ApplicationRepository applicationRepository;
    private final ScheduleRepository scheduleRepository;

    @Transactional
    public Static creatStatic(NewStaticRequest newStatic) {


        List<Schedule> schedules = newStatic.getSchedules();
        for (Schedule schedule : schedules) {
            scheduleRepository.save(schedule);
        }



        User leader = userRepository.findById(newStatic.getLeadId()).orElseThrow();
        Static st = Static.builder()
                .name(newStatic.getName())
                .schedules(schedules)
                .members(new ArrayList<>())
                .lead(leader).build();
        //TODO if static lead is me or i need permission to add them (ROLE)
        st.addMember(leader,null);
        return staticRepository.save(st);
    }

    @Transactional
    public void apply(Long id, Application application) {
        Static statics= staticRepository.getById(id);

        application.setUser(PermissionService.getMe());
        Application appl = applicationRepository.save(application);

        statics.apply(appl);
        staticRepository.save(statics);
    }

    @Transactional
    public void acceptApplication(Long id, Long applicationId) {

        Static st = staticRepository.findById(id).orElseThrow();

        if(!PermissionService.isMe(st.getLead().getId())) return;

        Application application = applicationRepository.findById(applicationId).orElseThrow();

        st.getApplications().remove(application);
        st.addMember(application.getUser(), application.getJob());
        applicationRepository.deleteById(applicationId);
        staticRepository.save(st);

    }


    @Transactional
    public void addMember(Long id, MemberId member) {

        Static st = staticRepository.findById(id).orElseThrow();
        if(!PermissionService.isMe(st.getLead().getId())) return;

        User user = userRepository.getById(member.getUserId());

        Member mb = Member.builder()
                .user(user)
                .job(member.getJob())
                .build();

        st.addMember(mb);
        staticRepository.save(st);

    }


    public Iterable<Static> getStaticsOfUser(Long userId) {

        Iterable<Static> statics = staticRepository.findAllByMembersUserId(userId);
       // Iterable<Static> staticsLead = staticRepository.findAllByLeadId(userId);
        return statics;

    }



    public void deleteStatic(Long id) {
        Static st = staticRepository.findById(id).orElseThrow();
        if(!PermissionService.isMe(st.getLead().getId())) return;
        staticRepository.deleteById(id);
    }

}

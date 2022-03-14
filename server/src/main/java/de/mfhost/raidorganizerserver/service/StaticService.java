package de.mfhost.raidorganizerserver.service;

import de.mfhost.raidorganizerserver.dto.NewStaticRequest;
import de.mfhost.raidorganizerserver.models.Application;
import de.mfhost.raidorganizerserver.models.Static;
import de.mfhost.raidorganizerserver.repository.ApplicationRepository;
import de.mfhost.raidorganizerserver.repository.StaticRepository;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Optional;

@Service
@AllArgsConstructor
public class StaticService {

    private final UserRepository userRepository;
    private final StaticRepository staticRepository;
    private final ApplicationRepository applicationRepository;

    public Static creatStatic(NewStaticRequest newStatic) {

        User leader = userRepository.findById(newStatic.getLeadId()).orElseThrow();
        Static st = Static.builder()
                .name(newStatic.getName())
                .lead(leader).build();
        //TODO if static lead is me or i need permission to add them (ROLE)
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


    public void deleteStatic(Long id) {
        Static st = staticRepository.findById(id).orElseThrow();
        if(!PermissionService.isMe(st.getLead().getId())) return;
        staticRepository.deleteById(id);
    }

}

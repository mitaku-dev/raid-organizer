package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.dto.NewStaticRequest;
import de.mfhost.raidorganizerserver.models.Application;
import de.mfhost.raidorganizerserver.models.Static;
import de.mfhost.raidorganizerserver.repository.StaticRepository;
import de.mfhost.raidorganizerserver.service.PermissionService;
import de.mfhost.raidorganizerserver.service.StaticService;
import de.mfhost.raidorganizerserver.user.User;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/static")
@AllArgsConstructor
public class StaticsApi {

    private final StaticService staticService;
    private final StaticRepository staticRepository;

    @PostMapping
    public ResponseEntity<Static> create(@RequestBody NewStaticRequest newStatic){

        if(newStatic.getLeadId() != null) { //every static needs an Lead
            Static savedStatic = staticService.creatStatic(newStatic);
            return ResponseEntity.ok(savedStatic);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }

    }

    @PostMapping("/{id}/apply")
    public ResponseEntity<?> apply(@PathVariable Long id,@RequestBody Application application) {

        staticService.apply(id, application);
        return  ResponseEntity.ok("");
    }

    @PostMapping("/{id}/accept/{application_id}")
    public ResponseEntity<?> apply(@PathVariable Long id, @PathVariable Long application_id) {

            staticService.acceptApplication(id, application_id);
        return  ResponseEntity.ok("");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        staticService.deleteStatic(id);
        return ResponseEntity.ok("");
    }


    @GetMapping("/{id}")
    public ResponseEntity<Static> get(@PathVariable Long id) {

        Optional<Static> s = staticRepository.findById(id);
        if(s.isPresent()) {
            return ResponseEntity.ok(s.get());
        }
        return  ResponseEntity.notFound().build();
    }

    @GetMapping()
    public ResponseEntity<List<Static>> getAll() {
        return ResponseEntity.ok(staticRepository.findAll());
    }


}

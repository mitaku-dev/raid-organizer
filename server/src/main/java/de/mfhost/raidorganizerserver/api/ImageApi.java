package de.mfhost.raidorganizerserver.api;

import de.mfhost.raidorganizerserver.models.Image;
import de.mfhost.raidorganizerserver.models.Static;
import de.mfhost.raidorganizerserver.repository.ImageRepository;
import de.mfhost.raidorganizerserver.repository.StaticRepository;
import de.mfhost.raidorganizerserver.user.User;
import de.mfhost.raidorganizerserver.user.UserRepository;
import de.mfhost.raidorganizerserver.utils.ImageUtility;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.transaction.Transactional;
import java.io.IOException;
import java.util.Optional;

@Controller
@RequestMapping("/images")
public class ImageApi {

    private final ImageRepository imageRepository;
    private final UserRepository userRepository;
    private final StaticRepository staticRepository;

    public ImageApi(ImageRepository imageRepository, UserRepository userRepository, StaticRepository staticRepository) {
        this.imageRepository = imageRepository;
        this.userRepository = userRepository;
        this.staticRepository = staticRepository;
    }


    @PostMapping("/user")
    @Transactional
    public ResponseEntity uploadImage(@RequestParam("image") MultipartFile file) throws IOException {

        //TODO if over 10MB
        //TODO delete old or where to put?

        //TODO link to User-Account
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object principal = auth.getPrincipal();

        //TODO maybe only UserDetails??
        if(principal instanceof User) {
            Long userId = ((User) principal).getId();
            User user = userRepository.findById(userId).orElseThrow();

            Image image = imageRepository.save(
                    Image.builder()
                            .name(file.getOriginalFilename())
                            .type(file.getContentType())
                            .image(ImageUtility.compressImage(file.getBytes())).build()
            );



            String url = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();

            if(url.equals("http://localhost:8080")) { //TODO only dev
                url = "http://192.168.178.75:8080";
            }

            url += "/images/"+image.getId();

            user.setProfilePicUrl(url);
            userRepository.save(user);

        }

        return ResponseEntity.status(HttpStatus.OK).build();
    }


    @PostMapping("/static/{id}")
    @Transactional
    public ResponseEntity uploadImageStatic(@RequestParam("image") MultipartFile file, @PathVariable Long id) throws IOException {

        Static statics = staticRepository.findById(id).orElseThrow();

        Image image = imageRepository.save(
                Image.builder()
                        .name(file.getOriginalFilename())
                        .type(file.getContentType())
                        .image(ImageUtility.compressImage(file.getBytes())).build()
        );

        String url = ServletUriComponentsBuilder.fromCurrentContextPath().build().toUriString();

        if(url.equals("http://localhost:8080")) { //TODO only dev
            url = "http://192.168.178.75:8080";
        }

        url += "/images/"+image.getId();

        statics.setStaticImageUrl(url);
        staticRepository.save(statics);

        return ResponseEntity.status(HttpStatus.OK).build();
    }




    @GetMapping("/{id}")
    public ResponseEntity<byte[]> getImage(@PathVariable("id") Long id) {
        final Optional<Image> image = imageRepository.findById(id);


        if(image.isEmpty()) return ResponseEntity.notFound().build();

        return ResponseEntity.ok()
                .contentType(MediaType.valueOf(image.get().getType()))
                .body(ImageUtility.decompressImage(image.get().getImage()));
    }

}

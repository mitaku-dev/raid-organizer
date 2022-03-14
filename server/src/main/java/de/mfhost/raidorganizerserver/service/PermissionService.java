package de.mfhost.raidorganizerserver.service;

import de.mfhost.raidorganizerserver.user.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;


public class PermissionService {

    static public boolean isMe(Long id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object principal = auth.getPrincipal();
        if(principal instanceof User) {
            Long userId = ((User) principal).getId();
            return id.equals(userId);
        }
        return false;
    }

    static public User getMe() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Object principal = auth.getPrincipal();
        if(principal instanceof User) {
            return (User) principal;
        }
        return null;
    }


}

package com.stressdebugger.controller;

import com.stressdebugger.dto.AdminStatsResponse;
import com.stressdebugger.model.*;
import com.stressdebugger.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {
    
    private final AdminService adminService;
    
    @GetMapping("/stats")
    public ResponseEntity<AdminStatsResponse> getAdminStats(Authentication auth) {
        return ResponseEntity.ok(adminService.getAdminStats());
    }
    
    @GetMapping("/users")
    public ResponseEntity<List<User>> getAllUsers(Authentication auth) {
        return ResponseEntity.ok(adminService.getAllUsers());
    }
    
    @GetMapping("/logs")
    public ResponseEntity<List<StressLog>> getAllLogs(Authentication auth) {
        return ResponseEntity.ok(adminService.getAllLogs());
    }
    
    @DeleteMapping("/users/{username}")
    public ResponseEntity<Void> deleteUser(
        Authentication auth,
        @PathVariable String username
    ) {
        adminService.deleteUser(username);
        return ResponseEntity.noContent().build();
    }
    
    @DeleteMapping("/logs/{id}")
    public ResponseEntity<Void> deleteAnyLog(
        Authentication auth,
        @PathVariable Long id
    ) {
        adminService.deleteLog(id);
        return ResponseEntity.noContent().build();
    }
}

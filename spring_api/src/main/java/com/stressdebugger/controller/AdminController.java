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
        // 간단 권한 체크 (실제론 @PreAuthorize 사용 권장)
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
}

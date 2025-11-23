package com.stressdebugger.controller;

import com.stressdebugger.dto.LogRequest;
import com.stressdebugger.model.StressLog;
import com.stressdebugger.service.LogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/logs")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class LogController {
    
    private final LogService logService;
    
    @PostMapping
    public ResponseEntity<StressLog> createLog(
        Authentication auth,
        @RequestBody LogRequest request
    ) {
        return ResponseEntity.ok(logService.createLog(auth.getName(), request));
    }
    
    @GetMapping("/me")
    public ResponseEntity<List<StressLog>> getMyLogs(Authentication auth) {
        return ResponseEntity.ok(logService.getUserLogs(auth.getName()));
    }
    
    @GetMapping("/daily")
    public ResponseEntity<List<StressLog>> getDailyLogs(Authentication auth) {
        return ResponseEntity.ok(logService.getTodayLogs(auth.getName()));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<StressLog> updateLog(
        Authentication auth,
        @PathVariable Long id,
        @RequestBody LogRequest request
    ) {
        return ResponseEntity.ok(logService.updateLog(auth.getName(), id, request));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLog(
        Authentication auth,
        @PathVariable Long id
    ) {
        logService.deleteLog(auth.getName(), id);
        return ResponseEntity.noContent().build();
    }
}

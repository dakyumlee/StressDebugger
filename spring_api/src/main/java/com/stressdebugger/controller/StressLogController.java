package com.stressdebugger.controller;

import com.stressdebugger.dto.*;
import com.stressdebugger.service.StressLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/logs")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StressLogController {
    
    private final StressLogService stressLogService;
    
    @PostMapping
    public ResponseEntity<StressLogResponse> createLog(
        Authentication authentication,
        @RequestBody StressLogRequest request
    ) {
        String username = authentication.getName();
        return ResponseEntity.ok(stressLogService.createLog(username, request));
    }
    
    @GetMapping
    public ResponseEntity<List<StressLogResponse>> getLogs(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok(stressLogService.getUserLogs(username));
    }
    
    @GetMapping("/daily")
    public ResponseEntity<List<StressLogResponse>> getDailyLogs(
        Authentication authentication,
        @RequestParam String date
    ) {
        String username = authentication.getName();
        LocalDateTime dateTime = LocalDateTime.parse(date);
        return ResponseEntity.ok(stressLogService.getDailyLogs(username, dateTime));
    }
    
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok(stressLogService.getStats(username));
    }
}

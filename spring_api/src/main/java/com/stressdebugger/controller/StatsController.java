package com.stressdebugger.controller;

import com.stressdebugger.service.StatsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/stats")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StatsController {
    
    private final StatsService statsService;
    
    @GetMapping("/monthly")
    public ResponseEntity<Map<String, Object>> getMonthlyStats(Authentication auth) {
        String username = auth.getName();
        return ResponseEntity.ok(statsService.getMonthlyStats(username));
    }
}

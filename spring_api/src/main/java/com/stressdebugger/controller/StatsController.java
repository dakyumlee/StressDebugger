package com.stressdebugger.controller;

import com.stressdebugger.dto.StatsResponse;
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
    
    @GetMapping("/weekly")
    public ResponseEntity<StatsResponse> getWeeklyStats(Authentication auth) {
        return ResponseEntity.ok(statsService.getWeeklyStats(auth.getName()));
    }
    
    @GetMapping("/day-of-week")
    public ResponseEntity<Map<String, Integer>> getDayOfWeekStats(Authentication auth) {
        return ResponseEntity.ok(statsService.getDayOfWeekStats(auth.getName()));
    }
}

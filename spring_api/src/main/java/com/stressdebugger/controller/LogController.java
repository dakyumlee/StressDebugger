package com.stressdebugger.controller;

import com.stressdebugger.dto.*;
import com.stressdebugger.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/logs")
@RequiredArgsConstructor
public class LogController {
    
    private final LogService logService;
    private final JwtService jwtService;
    
    @PostMapping
    public ResponseEntity<StressLogResponse> createLog(@RequestBody LogRequest request, @RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        return ResponseEntity.ok(logService.createLog(username, request));
    }
    
    @PostMapping("/quick")
    public ResponseEntity<StressLogResponse> createQuickLog(@RequestBody QuickLogRequest request, @RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        return ResponseEntity.ok(logService.createQuickLog(username, request));
    }
    
    @GetMapping("/history")
    public ResponseEntity<List<StressLogResponse>> getHistory(@RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        return ResponseEntity.ok(logService.getUserHistory(username));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<StressLogResponse> updateLog(@PathVariable Long id, @RequestBody LogRequest request, @RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        return ResponseEntity.ok(logService.updateLog(id, username, request));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteLog(@PathVariable Long id, @RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        logService.deleteLog(id, username);
        return ResponseEntity.noContent().build();
    }
}

package com.stressdebugger.controller;

import com.stressdebugger.service.FineTuningService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {
    
    private final FineTuningService fineTuningService;
    
    @GetMapping("/finetuning/export")
    public ResponseEntity<String> exportFineTuningData(Authentication auth) {
        String jsonl = fineTuningService.generateJSONL();
        
        return ResponseEntity.ok()
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=stressdebugger-training.jsonl")
            .contentType(MediaType.TEXT_PLAIN)
            .body(jsonl);
    }
}

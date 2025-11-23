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

    @PostMapping("/finetuning/start")
    public ResponseEntity<Map<String, Object>> startFineTuning(Authentication auth) {
        try {
            Map<String, Object> result = fineTuningService.startFineTuning();
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
    
    @GetMapping("/finetuning/status/{jobId}")
    public ResponseEntity<Map<String, Object>> getFineTuningStatus(@PathVariable String jobId) {
        try {
            Map<String, Object> status = fineTuningService.getJobStatus(jobId);
            return ResponseEntity.ok(status);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
    
    @GetMapping("/finetuning/models")
    public ResponseEntity<Map<String, Object>> listFineTunedModels() {
        try {
            Map<String, Object> models = fineTuningService.listModels();
            return ResponseEntity.ok(models);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}

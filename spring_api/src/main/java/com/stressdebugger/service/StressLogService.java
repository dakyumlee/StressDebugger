package com.stressdebugger.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.stressdebugger.dto.*;
import com.stressdebugger.model.*;
import com.stressdebugger.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StressLogService {
    
    private final StressLogRepository stressLogRepository;
    private final UserRepository userRepository;
    private final PythonService pythonService;
    private final ObjectMapper objectMapper;
    
    public StressLogResponse createLog(String username, StressLogRequest request) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Map<String, Object> analysisResult = pythonService.analyzeStress(request.getText());
        
        String forensicJson;
        try {
            forensicJson = objectMapper.writeValueAsString(
                analysisResult.get("forensic_result")
            );
        } catch (JsonProcessingException e) {
            forensicJson = "{}";
        }
        
        StressLog log = StressLog.builder()
            .user(user)
            .text(request.getText())
            .angerLevel((Integer) analysisResult.get("anger_level"))
            .anxiety((Integer) analysisResult.get("anxiety"))
            .techFactor((Integer) analysisResult.get("tech_factor"))
            .humanFactor((Integer) analysisResult.get("human_factor"))
            .forensicResult(forensicJson)
            .justification((String) analysisResult.get("justification"))
            .consolation((String) analysisResult.get("consolation"))
            .build();
        
        stressLogRepository.save(log);
        
        return convertToResponse(log);
    }
    
    public List<StressLogResponse> getUserLogs(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        return stressLogRepository.findByUserOrderByCreatedAtDesc(user).stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList());
    }
    
    public List<StressLogResponse> getDailyLogs(String username, LocalDateTime date) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        LocalDateTime startOfDay = date.toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = startOfDay.plusDays(1);
        
        return stressLogRepository
            .findByUserAndCreatedAtBetweenOrderByCreatedAtDesc(user, startOfDay, endOfDay)
            .stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList());
    }
    
    public Map<String, Object> getStats(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("avg_anger", stressLogRepository.getAverageAngerLevel(user));
        stats.put("avg_tech_factor", stressLogRepository.getAverageTechFactor(user));
        stats.put("avg_human_factor", stressLogRepository.getAverageHumanFactor(user));
        
        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        List<StressLog> recentLogs = stressLogRepository
            .findByUserAndCreatedAtBetweenOrderByCreatedAtDesc(
                user, 
                weekAgo, 
                LocalDateTime.now()
            );
        
        stats.put("recent_logs", recentLogs.stream()
            .map(this::convertToResponse)
            .collect(Collectors.toList()));
        
        return stats;
    }
    
    private StressLogResponse convertToResponse(StressLog log) {
        Map<String, Object> forensicResult;
        try {
            forensicResult = objectMapper.readValue(
                log.getForensicResult(), 
                Map.class
            );
        } catch (JsonProcessingException e) {
            forensicResult = new HashMap<>();
        }
        
        return StressLogResponse.builder()
            .id(log.getId())
            .text(log.getText())
            .angerLevel(log.getAngerLevel())
            .anxiety(log.getAnxiety())
            .techFactor(log.getTechFactor())
            .humanFactor(log.getHumanFactor())
            .forensicResult(forensicResult)
            .justification(log.getJustification())
            .consolation(log.getConsolation())
            .createdAt(log.getCreatedAt())
            .build();
    }
}

package com.stressdebugger.service;

import com.stressdebugger.dto.*;
import com.stressdebugger.model.*;
import com.stressdebugger.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class LogService {
    
    private final StressLogRepository logRepository;
    private final PythonService pythonService;
    
    public StressLogResponse createLog(String username, LogRequest request) {
        AnalysisResult analysis;
        
        try {
            analysis = pythonService.analyzeEmotion(request.getText());
            
            if (analysis == null) {
                throw new RuntimeException("AI 분석 실패: 응답 없음");
            }
        } catch (Exception e) {
            throw new RuntimeException("AI 분석 실패: " + e.getMessage());
        }
        
        StressLog log = StressLog.builder()
            .username(username)
            .text(request.getText())
            .logType("NORMAL")
            .angerLevel(analysis.getAngerLevel())
            .anxiety(analysis.getAnxiety())
            .techFactor(analysis.getTechFactor())
            .humanFactor(analysis.getHumanFactor())
            .forensicResult(analysis.getForensicResult())
            .justification(analysis.getJustification())
            .consolation(analysis.getConsolation())
            .build();
        
        log = logRepository.save(log);
        
        return mapToResponse(log);
    }
    
    public StressLogResponse createQuickLog(String username, QuickLogRequest request) {
        StressLog log = StressLog.builder()
            .username(username)
            .text(request.getText())
            .logType("QUICK")
            .angerLevel(0)
            .anxiety(0)
            .techFactor(0)
            .humanFactor(0)
            .build();
        
        log = logRepository.save(log);
        
        return mapToResponse(log);
    }
    
    public List<StressLogResponse> getUserHistory(String username) {
        return logRepository.findByUsernameOrderByCreatedAtDesc(username).stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    public StressLogResponse updateLog(Long id, String username, LogRequest request) {
        StressLog log = logRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Log not found"));
        
        if (!log.getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized");
        }
        
        log.setText(request.getText());
        
        if ("NORMAL".equals(log.getLogType())) {
            try {
                AnalysisResult analysis = pythonService.analyzeEmotion(request.getText());
                
                if (analysis != null) {
                    log.setAngerLevel(analysis.getAngerLevel());
                    log.setAnxiety(analysis.getAnxiety());
                    log.setTechFactor(analysis.getTechFactor());
                    log.setHumanFactor(analysis.getHumanFactor());
                    log.setForensicResult(analysis.getForensicResult());
                    log.setJustification(analysis.getJustification());
                    log.setConsolation(analysis.getConsolation());
                }
            } catch (Exception e) {
                System.err.println("AI 분석 실패: " + e.getMessage());
            }
        }
        
        log = logRepository.save(log);
        
        return mapToResponse(log);
    }
    
    public void deleteLog(Long id, String username) {
        StressLog log = logRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Log not found"));
        
        if (!log.getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized");
        }
        
        logRepository.delete(log);
    }
    
    private StressLogResponse mapToResponse(StressLog log) {
        return StressLogResponse.builder()
            .id(log.getId())
            .username(log.getUsername())
            .text(log.getText())
            .logType(log.getLogType())
            .angerLevel(log.getAngerLevel())
            .anxiety(log.getAnxiety())
            .techFactor(log.getTechFactor())
            .humanFactor(log.getHumanFactor())
            .forensicResult(log.getForensicResult())
            .justification(log.getJustification())
            .consolation(log.getConsolation())
            .createdAt(log.getCreatedAt())
            .build();
    }
}

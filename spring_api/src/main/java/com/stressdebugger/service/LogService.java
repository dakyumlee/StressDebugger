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
    private final UserRepository userRepository;
    
    public StressLogResponse createLog(String username, LogRequest request) {
        AnalysisResult analysis;
        
        try {
            analysis = pythonService.analyzeEmotion(request.getText(), username);
            
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
        
        updateUserProfile(username, log);
        
        return mapToResponse(log);
    }
    
    private void updateUserProfile(String username, StressLog log) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        List<StressLog> allLogs = logRepository.findByUsernameOrderByCreatedAtDesc(username).stream()
            .filter(l -> "NORMAL".equals(l.getLogType()))
            .collect(Collectors.toList());
        
        if (allLogs.isEmpty()) return;
        
        double avgAnger = allLogs.stream().mapToInt(StressLog::getAngerLevel).average().orElse(0);
        double avgAnxiety = allLogs.stream().mapToInt(StressLog::getAnxiety).average().orElse(0);
        double avgTech = allLogs.stream().mapToInt(StressLog::getTechFactor).average().orElse(0);
        double avgHuman = allLogs.stream().mapToInt(StressLog::getHumanFactor).average().orElse(0);
        
        double swearLevel = calculateSwearLevel(log.getText());
        double currentAvgSwear = user.getAvgSwearLevel() != null ? user.getAvgSwearLevel() : 0.0;
        double newAvgSwear = (currentAvgSwear * (allLogs.size() - 1) + swearLevel) / allLogs.size();
        
        user.setTotalLogs(allLogs.size());
        user.setAvgAngerLevel(Math.round(avgAnger * 10) / 10.0);
        user.setAvgAnxiety(Math.round(avgAnxiety * 10) / 10.0);
        user.setAvgSwearLevel(Math.round(newAvgSwear * 10) / 10.0);
        user.setTechRatio(avgHuman > 0 ? Math.round((avgTech / avgHuman) * 100) / 100.0 : 0.0);
        
        userRepository.save(user);
    }
    
    private double calculateSwearLevel(String text) {
        String[] swearWords = {"ㅅㅂ", "시발", "씨발", "ㅂㅅ", "병신", "개새", "좆", "ㅈ같", "ㅈ됐", "엿먹", "ㅈ나", "존나"};
        long count = 0;
        
        for (String swear : swearWords) {
            if (text.contains(swear)) {
                count++;
            }
        }
        
        return Math.min(count * 20.0, 100.0);
    }
    
    public StressLogResponse createQuickLog(String username, String text) {
        StressLog log = StressLog.builder()
            .username(username)
            .text(text)
            .logType("QUICK")
            .angerLevel(0)
            .anxiety(0)
            .techFactor(0)
            .humanFactor(0)
            .forensicResult("")
            .justification("")
            .consolation("간단 메모 저장 완료!")
            .build();
        
        log = logRepository.save(log);
        
        updateUserProfile(username, log);
        
        return mapToResponse(log);
    }
    
    public List<StressLogResponse> getUserLogs(String username) {
        return logRepository.findByUsernameOrderByCreatedAtDesc(username).stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    public StressLogResponse updateLog(Long id, String username, String newText) {
        StressLog log = logRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Log not found"));
        
        if (!log.getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized");
        }
        
        log.setText(newText);
        log = logRepository.save(log);
        
        updateUserProfile(username, log);
        
        return mapToResponse(log);
    }
    
    public void deleteLog(Long id, String username) {
        StressLog log = logRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Log not found"));
        
        if (!log.getUsername().equals(username)) {
            throw new RuntimeException("Unauthorized");
        }
        
        logRepository.delete(log);
        updateUserProfile(username, null);
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

package com.stressdebugger.service;

import com.stressdebugger.dto.StressLogResponse;
import com.stressdebugger.dto.UserProfileResponse;
import com.stressdebugger.model.StressLog;
import com.stressdebugger.model.User;
import com.stressdebugger.repository.StressLogRepository;
import com.stressdebugger.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminService {
    
    private final UserRepository userRepository;
    private final StressLogRepository logRepository;
    
    public List<UserProfileResponse> getAllUsers() {
        return userRepository.findAll().stream()
            .map(this::mapToUserProfile)
            .collect(Collectors.toList());
    }
    
    public List<StressLogResponse> getAllLogs() {
        return logRepository.findAll().stream()
            .map(this::mapToLogResponse)
            .collect(Collectors.toList());
    }
    
    public void deleteUser(String username) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        logRepository.deleteByUsername(username);
        userRepository.delete(user);
    }
    
    public void deleteLog(Long id) {
        StressLog log = logRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Log not found"));
        
        logRepository.delete(log);
    }
    
    private UserProfileResponse mapToUserProfile(User user) {
        return UserProfileResponse.builder()
            .username(user.getUsername())
            .nickname(user.getNickname())
            .role(user.getRole())
            .totalLogs(user.getTotalLogs())
            .avgAngerLevel(user.getAvgAngerLevel())
            .avgAnxiety(user.getAvgAnxiety())
            .avgSwearLevel(user.getAvgSwearLevel())
            .techRatio(user.getTechRatio())
            .humorPreference(user.getHumorPreference())
            .sensitivityLevel(user.getSensitivityLevel())
            .preferredMessageLength(user.getPreferredMessageLength())
            .preferredNickname(user.getPreferredNickname())
            .createdAt(user.getCreatedAt())
            .build();
    }
    
    private StressLogResponse mapToLogResponse(StressLog log) {
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

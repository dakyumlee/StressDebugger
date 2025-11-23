package com.stressdebugger.service;

import com.stressdebugger.dto.*;
import com.stressdebugger.model.*;
import com.stressdebugger.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminService {
    
    private final UserRepository userRepository;
    private final StressLogRepository logRepository;
    
    public AdminStatsResponse getAdminStats() {
        List<User> users = userRepository.findAll();
        List<StressLog> logs = logRepository.findAll();
        
        Map<String, List<StressLog>> logsByUser = logs.stream()
            .collect(Collectors.groupingBy(StressLog::getUsername));
        
        List<UserSummary> topAngry = logsByUser.entrySet().stream()
            .map(entry -> {
                User user = userRepository.findByUsername(entry.getKey()).orElse(null);
                return UserSummary.builder()
                    .username(entry.getKey())
                    .nickname(user != null ? user.getNickname() : entry.getKey())
                    .logCount(entry.getValue().size())
                    .avgAngerLevel(entry.getValue().stream()
                        .mapToInt(StressLog::getAngerLevel)
                        .average()
                        .orElse(0))
                    .build();
            })
            .sorted(Comparator.comparing(UserSummary::getAvgAngerLevel).reversed())
            .limit(10)
            .collect(Collectors.toList());
        
        double avgAnger = logs.stream()
            .mapToInt(StressLog::getAngerLevel)
            .average()
            .orElse(0);
        
        return AdminStatsResponse.builder()
            .totalUsers(users.size())
            .totalLogs(logs.size())
            .avgAngerLevel(avgAnger)
            .topAngryUsers(topAngry)
            .build();
    }
    
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    public List<StressLog> getAllLogs() {
        return logRepository.findAllOrderByCreatedAtDesc();
    }
}

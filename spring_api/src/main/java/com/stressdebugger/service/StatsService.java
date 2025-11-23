package com.stressdebugger.service;

import com.stressdebugger.model.StressLog;
import com.stressdebugger.repository.StressLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StatsService {
    
    private final StressLogRepository logRepository;
    
    public Map<String, Object> getMonthlyStats(String username) {
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minusDays(30);
        List<StressLog> logs = logRepository.findByUsernameOrderByCreatedAtDesc(username).stream()
            .filter(log -> log.getCreatedAt().isAfter(thirtyDaysAgo))
            .filter(log -> "NORMAL".equals(log.getLogType()))
            .collect(Collectors.toList());
        
        Map<String, Object> stats = new HashMap<>();
        
        if (logs.isEmpty()) {
            stats.put("totalLogs", 0);
            stats.put("avgAngerLevel", 0.0);
            stats.put("avgAnxiety", 0.0);
            stats.put("techVsHumanRatio", 0.0);
            stats.put("dailyStats", new ArrayList<>());
            return stats;
        }
        
        double avgAnger = logs.stream().mapToInt(StressLog::getAngerLevel).average().orElse(0);
        double avgAnxiety = logs.stream().mapToInt(StressLog::getAnxiety).average().orElse(0);
        double avgTech = logs.stream().mapToInt(StressLog::getTechFactor).average().orElse(0);
        double avgHuman = logs.stream().mapToInt(StressLog::getHumanFactor).average().orElse(0);
        
        stats.put("totalLogs", logs.size());
        stats.put("avgAngerLevel", Math.round(avgAnger * 10) / 10.0);
        stats.put("avgAnxiety", Math.round(avgAnxiety * 10) / 10.0);
        stats.put("techVsHumanRatio", avgHuman > 0 ? Math.round((avgTech / avgHuman) * 100) / 100.0 : 0.0);
        
        Map<String, List<StressLog>> groupedByDate = logs.stream()
            .collect(Collectors.groupingBy(log -> log.getCreatedAt().toLocalDate().toString()));
        
        List<Map<String, Object>> dailyStats = groupedByDate.entrySet().stream()
            .map(entry -> {
                Map<String, Object> day = new HashMap<>();
                day.put("date", entry.getKey());
                double dayAvgAnger = entry.getValue().stream()
                    .mapToInt(StressLog::getAngerLevel)
                    .average()
                    .orElse(0);
                day.put("avgAngerLevel", Math.round(dayAvgAnger * 10) / 10.0);
                return day;
            })
            .sorted((a, b) -> ((String) a.get("date")).compareTo((String) b.get("date")))
            .collect(Collectors.toList());
        
        stats.put("dailyStats", dailyStats);
        
        return stats;
    }
}

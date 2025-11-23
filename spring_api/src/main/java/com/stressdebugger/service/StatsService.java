package com.stressdebugger.service;

import com.stressdebugger.dto.*;
import com.stressdebugger.model.StressLog;
import com.stressdebugger.repository.StressLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StatsService {
    
    private final StressLogRepository logRepository;
    
    public StatsResponse getWeeklyStats(String username) {
        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        List<StressLog> logs = logRepository.findByUsernameAndCreatedAtAfter(username, weekAgo);
        
        Map<LocalDate, List<StressLog>> grouped = logs.stream()
            .collect(Collectors.groupingBy(log -> log.getCreatedAt().toLocalDate()));
        
        List<DailyStats> weeklyStats = grouped.entrySet().stream()
            .map(entry -> DailyStats.builder()
                .date(entry.getKey())
                .avgAngerLevel(entry.getValue().stream().mapToInt(StressLog::getAngerLevel).average().orElse(0))
                .avgAnxiety(entry.getValue().stream().mapToInt(StressLog::getAnxiety).average().orElse(0))
                .count(entry.getValue().size())
                .build())
            .sorted(Comparator.comparing(DailyStats::getDate))
            .collect(Collectors.toList());
        
        Map<String, Integer> dayOfWeekStats = logs.stream()
            .collect(Collectors.groupingBy(
                log -> log.getCreatedAt().getDayOfWeek().toString(),
                Collectors.summingInt(log -> 1)
            ));
        
        double avgAnger = logs.stream().mapToInt(StressLog::getAngerLevel).average().orElse(0);
        double avgTech = logs.stream().mapToInt(StressLog::getTechFactor).average().orElse(0);
        double avgHuman = logs.stream().mapToInt(StressLog::getHumanFactor).average().orElse(0);
        double ratio = avgHuman > 0 ? avgTech / avgHuman : 0;
        
        return StatsResponse.builder()
            .weeklyStats(weeklyStats)
            .dayOfWeekStats(dayOfWeekStats)
            .totalLogs(logs.size())
            .avgAngerLevel(avgAnger)
            .techVsHumanRatio(ratio)
            .build();
    }
    
    public Map<String, Integer> getDayOfWeekStats(String username) {
        List<StressLog> logs = logRepository.findByUsername(username);
        
        return logs.stream()
            .collect(Collectors.groupingBy(
                log -> log.getCreatedAt().getDayOfWeek().toString(),
                Collectors.summingInt(log -> log.getAngerLevel())
            ));
    }
}

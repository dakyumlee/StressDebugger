package com.stressdebugger.dto;

import lombok.*;
import java.util.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatsResponse {
    private List<DailyStats> weeklyStats;
    private Map<String, Integer> dayOfWeekStats;
    private int totalLogs;
    private double avgAngerLevel;
    private double techVsHumanRatio;
}

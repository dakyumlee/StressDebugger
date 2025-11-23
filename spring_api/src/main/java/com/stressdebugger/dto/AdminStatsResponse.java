package com.stressdebugger.dto;

import lombok.*;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminStatsResponse {
    private long totalUsers;
    private long totalLogs;
    private double avgAngerLevel;
    private List<UserSummary> topAngryUsers;
}

package com.stressdebugger.dto;

import lombok.*;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyStats {
    private LocalDate date;
    private double avgAngerLevel;
    private double avgAnxiety;
    private int count;
}

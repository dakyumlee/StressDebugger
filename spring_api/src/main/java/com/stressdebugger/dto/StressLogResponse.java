package com.stressdebugger.dto;

import lombok.*;
import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StressLogResponse {
    private Long id;
    private String text;
    private Integer angerLevel;
    private Integer anxiety;
    private Integer techFactor;
    private Integer humanFactor;
    private Map<String, Object> forensicResult;
    private String justification;
    private String consolation;
    private LocalDateTime createdAt;
}

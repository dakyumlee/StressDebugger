package com.stressdebugger.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserSummary {
    private String username;
    private String nickname;
    private int logCount;
    private double avgAngerLevel;
}

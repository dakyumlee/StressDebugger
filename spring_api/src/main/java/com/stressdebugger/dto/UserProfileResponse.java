package com.stressdebugger.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileResponse {
    private String username;
    private String nickname;
    private String role;
    private Integer totalLogs;
    private Double avgAngerLevel;
    private Double avgAnxiety;
    private Double avgSwearLevel;
    private Double techRatio;
    private String humorPreference;
    private Integer sensitivityLevel;
    private String preferredMessageLength;
    private String preferredNickname;
    private LocalDateTime createdAt;
}

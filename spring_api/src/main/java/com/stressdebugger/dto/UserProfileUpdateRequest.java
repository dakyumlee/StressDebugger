package com.stressdebugger.dto;

import lombok.Data;

@Data
public class UserProfileUpdateRequest {
    private String humorPreference;
    private Integer sensitivityLevel;
    private String preferredMessageLength;
    private String preferredNickname;
}

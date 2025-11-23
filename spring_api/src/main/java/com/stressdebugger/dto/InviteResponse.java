package com.stressdebugger.dto;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InviteResponse {
    private String inviteCode;
    private String message;
}

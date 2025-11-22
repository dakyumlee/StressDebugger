package com.stressdebugger.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StressLogRequest {
    private String text;
}

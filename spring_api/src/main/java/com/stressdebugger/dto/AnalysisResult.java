package com.stressdebugger.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AnalysisResult {
    private int angerLevel;
    private int anxiety;
    private int techFactor;
    private int humanFactor;
    private String forensicResult;
    private String justification;
    private String consolation;
}

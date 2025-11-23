package com.stressdebugger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stressdebugger.dto.AnalysisResult;
import lombok.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Map;
import java.util.HashMap;

@Service
@RequiredArgsConstructor
public class PythonService {
    
    @Value("${python.service.url}")
    private String pythonServiceUrl;
    
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    public Map<String, Object> analyzeStress(String text) {
        String url = pythonServiceUrl + "/analyze";
        
        Map<String, String> request = new HashMap<>();
        request.put("text", text);
        
        return restTemplate.postForObject(url, request, Map.class);
    }
    
    public AnalysisResult analyzeEmotion(String text) {
        Map<String, Object> result = analyzeStress(text);
        
        String forensicResultJson = "";
        try {
            Object forensicObj = result.get("forensic_result");
            if (forensicObj != null) {
                forensicResultJson = objectMapper.writeValueAsString(forensicObj);
            }
        } catch (Exception e) {
            System.err.println("Forensic result 변환 실패: " + e.getMessage());
        }
        
        return AnalysisResult.builder()
            .angerLevel(((Number) result.getOrDefault("anger_level", 0)).intValue())
            .anxiety(((Number) result.getOrDefault("anxiety", 0)).intValue())
            .techFactor(((Number) result.getOrDefault("tech_factor", 0)).intValue())
            .humanFactor(((Number) result.getOrDefault("human_factor", 0)).intValue())
            .forensicResult(forensicResultJson)
            .justification((String) result.getOrDefault("justification", ""))
            .consolation((String) result.getOrDefault("consolation", ""))
            .build();
    }
}

package com.stressdebugger.service;

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
    
    public Map<String, Object> analyzeStress(String text) {
        String url = pythonServiceUrl + "/analyze";
        
        Map<String, String> request = new HashMap<>();
        request.put("text", text);
        
        return restTemplate.postForObject(url, request, Map.class);
    }
    
    public AnalysisResult analyzeEmotion(String text) {
        Map<String, Object> result = analyzeStress(text);
        
        return AnalysisResult.builder()
            .angerLevel(((Number) result.getOrDefault("anger_level", 0)).intValue())
            .anxiety(((Number) result.getOrDefault("anxiety", 0)).intValue())
            .techFactor(((Number) result.getOrDefault("tech_factor", 0)).intValue())
            .humanFactor(((Number) result.getOrDefault("human_factor", 0)).intValue())
            .forensicResult((String) result.getOrDefault("forensic_result", ""))
            .justification((String) result.getOrDefault("justification", ""))
            .consolation((String) result.getOrDefault("consolation", ""))
            .build();
    }
}

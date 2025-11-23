package com.stressdebugger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stressdebugger.dto.AnalysisResult;
import com.stressdebugger.model.User;
import com.stressdebugger.repository.UserRepository;
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
    private final UserRepository userRepository;
    
    public Map<String, Object> analyzeStress(String text, String username) {
        String url = pythonServiceUrl + "/analyze";
        
        Map<String, Object> request = new HashMap<>();
        request.put("text", text);
        
        User user = userRepository.findByUsername(username).orElse(null);
        if (user != null) {
            Map<String, Object> profile = new HashMap<>();
            profile.put("avgSwearLevel", user.getAvgSwearLevel());
            profile.put("techRatio", user.getTechRatio());
            profile.put("avgAngerLevel", user.getAvgAngerLevel());
            profile.put("humorPreference", user.getHumorPreference());
            profile.put("sensitivityLevel", user.getSensitivityLevel());
            profile.put("preferredMessageLength", user.getPreferredMessageLength());
            request.put("userProfile", profile);
        }
        
        return restTemplate.postForObject(url, request, Map.class);
    }
    
    public AnalysisResult analyzeEmotion(String text, String username) {
        Map<String, Object> result = analyzeStress(text, username);
        
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

package com.stressdebugger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stressdebugger.dto.LogRequest;
import com.stressdebugger.model.StressLog;
import com.stressdebugger.repository.StressLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class LogService {
    
    private final StressLogRepository logRepository;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    public StressLog createLog(String username, LogRequest request) {
        String pythonUrl = System.getenv("PYTHON_SERVICE_URL") + "/analyze";
        
        Map<String, Object> aiRequest = new HashMap<>();
        aiRequest.put("text", request.getText());
        
        Map<String, Object> aiResponse = restTemplate.postForObject(
            pythonUrl, 
            aiRequest, 
            Map.class
        );
        
        String forensicJson;
        try {
            forensicJson = objectMapper.writeValueAsString(aiResponse.get("forensic_result"));
        } catch (Exception e) {
            forensicJson = aiResponse.get("forensic_result").toString();
        }
        
        StressLog log = StressLog.builder()
            .username(username)
            .text(request.getText())
            .angerLevel((Integer) aiResponse.get("anger_level"))
            .anxiety((Integer) aiResponse.get("anxiety"))
            .techFactor((Integer) aiResponse.get("tech_factor"))
            .humanFactor((Integer) aiResponse.get("human_factor"))
            .forensicResult(forensicJson)
            .justification((String) aiResponse.get("justification"))
            .consolation((String) aiResponse.get("consolation"))
            .build();
        
        return logRepository.save(log);
    }
    
    public List<StressLog> getUserLogs(String username) {
        return logRepository.findByUsernameOrderByCreatedAtDesc(username);
    }
    
    public List<StressLog> getTodayLogs(String username) {
        LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        return logRepository.findByUsernameAndCreatedAtAfter(username, startOfDay);
    }
}

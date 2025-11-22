package com.stressdebugger.service;

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
}

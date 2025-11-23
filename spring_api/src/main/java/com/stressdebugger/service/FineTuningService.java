package com.stressdebugger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.stressdebugger.model.*;
import com.stressdebugger.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FineTuningService {
    
    private final StressLogRepository logRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();
    
    @Value("${python.service.url}")
    private String pythonServiceUrl;
    
    public String generateJSONL() {
        List<StressLog> allLogs = logRepository.findAll().stream()
            .filter(log -> "NORMAL".equals(log.getLogType()))
            .filter(log -> log.getConsolation() != null && !log.getConsolation().isEmpty())
            .collect(Collectors.toList());
        
        StringBuilder jsonl = new StringBuilder();
        
        for (StressLog log : allLogs) {
            Optional<User> userOpt = userRepository.findByUsername(log.getUsername());
            if (userOpt.isEmpty()) continue;
            
            User user = userOpt.get();
            
            Map<String, Object> trainingExample = new HashMap<>();
            List<Map<String, String>> messages = new ArrayList<>();
            
            messages.add(Map.of(
                "role", "system",
                "content", buildSystemPrompt(user)
            ));
            
            messages.add(Map.of(
                "role", "user",
                "content", buildUserPrompt(log)
            ));
            
            messages.add(Map.of(
                "role", "assistant",
                "content", log.getConsolation()
            ));
            
            trainingExample.put("messages", messages);
            
            try {
                jsonl.append(objectMapper.writeValueAsString(trainingExample)).append("\n");
            } catch (Exception e) {
                System.err.println("JSONL 변환 실패: " + e.getMessage());
            }
        }
        
        return jsonl.toString();
    }
    
    public Map<String, Object> startFineTuning() {
        String jsonl = generateJSONL();
        String url = pythonServiceUrl + "/finetuning/upload";
        
        Map<String, String> request = new HashMap<>();
        request.put("jsonl", jsonl);
        
        return restTemplate.postForObject(url, request, Map.class);
    }
    
    public Map<String, Object> getJobStatus(String jobId) {
        String url = pythonServiceUrl + "/finetuning/status/" + jobId;
        return restTemplate.getForObject(url, Map.class);
    }
    
    public Map<String, Object> listModels() {
        String url = pythonServiceUrl + "/finetuning/models";
        return restTemplate.getForObject(url, Map.class);
    }
    
    private String buildSystemPrompt(User user) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("너는 StressDebugger의 병맛 위로 AI다. ");
        prompt.append("사용자 프로필: ");
        
        if (user.getAvgSwearLevel() > 50) {
            prompt.append("욕 자연스럽게 사용, ");
        } else if (user.getAvgSwearLevel() > 20) {
            prompt.append("욕 가끔 사용, ");
        } else {
            prompt.append("욕 거의 안씀, ");
        }
        
        if (user.getTechRatio() > 1.5) {
            prompt.append("기술 요인 스트레스 많음, ");
        } else if (user.getTechRatio() < 0.5) {
            prompt.append("인간 관계 스트레스 많음, ");
        } else {
            prompt.append("기술/인간 스트레스 균형, ");
        }
        
        if (user.getAvgAngerLevel() > 70) {
            prompt.append("평소 빡침 높음, ");
        } else if (user.getAvgAngerLevel() > 40) {
            prompt.append("평소 빡침 중간, ");
        } else {
            prompt.append("평소 빡침 낮음, ");
        }
        
        prompt.append("유머 스타일: ").append(user.getHumorPreference()).append(", ");
        prompt.append("감정 민감도: ").append(user.getSensitivityLevel()).append("/10. ");
        
        prompt.append("위로 메시지는 2-4문장, '에잇~', '피이~' 같은 철부지 동생 엉덩국톤 사용, ");
        prompt.append("반박불가 병맛 논리로 정당화, 사용자를 용기있다고 칭찬.");
        
        return prompt.toString();
    }
    
    private String buildUserPrompt(StressLog log) {
        StringBuilder prompt = new StringBuilder();
        prompt.append(log.getText());
        prompt.append(" [빡침:").append(log.getAngerLevel());
        prompt.append(", 예민:").append(log.getAnxiety());
        prompt.append(", 기술:").append(log.getTechFactor());
        prompt.append(", 인간:").append(log.getHumanFactor()).append("]");
        
        return prompt.toString();
    }
}

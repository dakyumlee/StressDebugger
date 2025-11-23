package com.stressdebugger.controller;

import com.stressdebugger.dto.UserProfileUpdateRequest;
import com.stressdebugger.model.User;
import com.stressdebugger.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class UserController {
    
    private final UserRepository userRepository;
    
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> getUserInfo(Authentication auth) {
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Map<String, Object> info = new HashMap<>();
        info.put("username", user.getUsername());
        info.put("nickname", user.getNickname());
        info.put("inviteCode", user.getInviteCode());
        info.put("invitedBy", user.getInvitedBy());
        
        return ResponseEntity.ok(info);
    }
    
    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getUserProfile(Authentication auth) {
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        Map<String, Object> profile = new HashMap<>();
        profile.put("avgSwearLevel", user.getAvgSwearLevel());
        profile.put("techRatio", user.getTechRatio());
        profile.put("avgAngerLevel", user.getAvgAngerLevel());
        profile.put("avgAnxiety", user.getAvgAnxiety());
        profile.put("humorPreference", user.getHumorPreference());
        profile.put("sensitivityLevel", user.getSensitivityLevel());
        profile.put("preferredMessageLength", user.getPreferredMessageLength());
        profile.put("totalLogs", user.getTotalLogs());
        
        return ResponseEntity.ok(profile);
    }
    
    @PutMapping("/profile")
    public ResponseEntity<Map<String, Object>> updateUserProfile(
        Authentication auth, 
        @RequestBody UserProfileUpdateRequest request
    ) {
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (request.getHumorPreference() != null) {
            user.setHumorPreference(request.getHumorPreference());
        }
        if (request.getSensitivityLevel() != null) {
            user.setSensitivityLevel(request.getSensitivityLevel());
        }
        if (request.getPreferredMessageLength() != null) {
            user.setPreferredMessageLength(request.getPreferredMessageLength());
        }
        
        userRepository.save(user);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "프로필 업데이트 완료");
        
        return ResponseEntity.ok(response);
    }
}

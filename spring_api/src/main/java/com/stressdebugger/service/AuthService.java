package com.stressdebugger.service;

import com.stressdebugger.dto.*;
import com.stressdebugger.model.User;
import com.stressdebugger.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new RuntimeException("Username already exists");
        }
        
        User user = User.builder()
            .username(request.getUsername())
            .password(passwordEncoder.encode(request.getPassword()))
            .nickname(request.getNickname())
            .build();
        
        userRepository.save(user);
        
        String token = jwtService.generateToken(user.getUsername());
        
        return AuthResponse.builder()
            .token(token)
            .username(user.getUsername())
            .nickname(user.getNickname())
            .build();
    }
    
    public AuthResponse login(AuthRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }
        
        String token = jwtService.generateToken(user.getUsername());
        
        return AuthResponse.builder()
            .token(token)
            .username(user.getUsername())
            .nickname(user.getNickname())
            .build();
    }
}

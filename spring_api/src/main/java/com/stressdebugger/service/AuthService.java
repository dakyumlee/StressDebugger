package com.stressdebugger.service;

import com.stressdebugger.dto.LoginRequest;
import com.stressdebugger.dto.LoginResponse;
import com.stressdebugger.dto.RegisterRequest;
import com.stressdebugger.model.User;
import com.stressdebugger.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    
    public LoginResponse register(RegisterRequest request) {
        if (userRepository.findByUsername(request.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }
        
        String inviteCode = generateInviteCode();
        
        User user = User.builder()
            .username(request.getUsername())
            .password(passwordEncoder.encode(request.getPassword()))
            .nickname(request.getNickname())
            .inviteCode(inviteCode)
            .invitedBy(request.getInvitedBy())
            .role("USER")
            .build();
        
        userRepository.save(user);
        
        String token = jwtService.generateToken(user.getUsername());
        
        return LoginResponse.builder()
            .token(token)
            .username(user.getUsername())
            .nickname(user.getNickname())
            .role(user.getRole())
            .inviteCode(inviteCode)
            .build();
    }
    
    public LoginResponse login(LoginRequest request) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );
        
        User user = userRepository.findByUsername(request.getUsername())
            .orElseThrow(() -> new RuntimeException("User not found"));
        
        String token = jwtService.generateToken(user.getUsername());
        
        return LoginResponse.builder()
            .token(token)
            .username(user.getUsername())
            .nickname(user.getNickname())
            .role(user.getRole())
            .inviteCode(user.getInviteCode())
            .build();
    }
    
    public User getUserInfo(String username) {
        return userRepository.findByUsername(username)
            .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    private String generateInviteCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        
        for (int i = 0; i < 6; i++) {
            code.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        if (userRepository.findByInviteCode(code.toString()).isPresent()) {
            return generateInviteCode();
        }
        
        return code.toString();
    }
}

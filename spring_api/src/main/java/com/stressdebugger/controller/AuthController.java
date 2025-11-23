package com.stressdebugger.controller;

import com.stressdebugger.dto.*;
import com.stressdebugger.model.User;
import com.stressdebugger.service.AuthService;
import com.stressdebugger.service.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    
    private final AuthService authService;
    private final JwtService jwtService;
    
    @PostMapping("/register")
    public ResponseEntity<LoginResponse> register(@RequestBody RegisterRequest request){
        return ResponseEntity.ok(authService.register(request));
    }
    
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }
    
    @GetMapping("/me")
    public ResponseEntity<User> getUserInfo(@RequestHeader("Authorization") String token) {
        String username = jwtService.extractUsername(token.substring(7));
        return ResponseEntity.ok(authService.getUserInfo(username));
    }
}

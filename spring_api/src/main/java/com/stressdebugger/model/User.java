package com.stressdebugger.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    private String nickname;
    
    @Column(unique = true)
    private String inviteCode;
    
    private String invitedBy;
    
    @Builder.Default
    private String role = "USER";
    
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Builder.Default
    private Integer totalLogs = 0;
    
    @Builder.Default
    private Double avgAngerLevel = 0.0;
    
    @Builder.Default
    private Double avgAnxiety = 0.0;
    
    @Builder.Default
    private Double avgSwearLevel = 0.0;
    
    @Builder.Default
    private Double techRatio = 0.0;
    
    @Builder.Default
    private String humorPreference = "병맛";
    
    @Builder.Default
    private Integer sensitivityLevel = 5;
    
    @Builder.Default
    private String preferredMessageLength = "중간";
    
    @Builder.Default
    private String preferredNickname = "누나";
}

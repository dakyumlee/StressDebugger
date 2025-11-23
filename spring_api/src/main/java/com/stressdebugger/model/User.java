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
}

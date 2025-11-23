package com.stressdebugger.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "stress_logs")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StressLog {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    
    @Column(nullable = false, length = 1000)
    private String text;
    
    @Builder.Default
    private String logType = "NORMAL";
    
    private int angerLevel;
    private int anxiety;
    private int techFactor;
    private int humanFactor;
    
    @Column(length = 2000)
    private String forensicResult;
    
    @Column(length = 2000)
    private String justification;
    
    @Column(length = 2000)
    private String consolation;
    
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}

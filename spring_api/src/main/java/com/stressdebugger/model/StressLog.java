package com.stressdebugger.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "stress_logs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StressLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(columnDefinition = "TEXT", nullable = false)
    private String text;
    
    @Column(name = "anger_level")
    private Integer angerLevel;
    
    private Integer anxiety;
    
    @Column(name = "tech_factor")
    private Integer techFactor;
    
    @Column(name = "human_factor")
    private Integer humanFactor;
    
    @Column(columnDefinition = "TEXT")
    private String forensicResult;
    
    @Column(columnDefinition = "TEXT")
    private String justification;
    
    @Column(columnDefinition = "TEXT")
    private String consolation;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}

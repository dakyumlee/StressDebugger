package com.stressdebugger.repository;

import com.stressdebugger.model.StressLog;
import com.stressdebugger.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface StressLogRepository extends JpaRepository<StressLog, Long> {
    List<StressLog> findByUserOrderByCreatedAtDesc(User user);
    
    List<StressLog> findByUserAndCreatedAtBetweenOrderByCreatedAtDesc(
        User user, 
        LocalDateTime start, 
        LocalDateTime end
    );
    
    @Query("SELECT AVG(s.angerLevel) FROM StressLog s WHERE s.user = :user")
    Double getAverageAngerLevel(User user);
    
    @Query("SELECT AVG(s.techFactor) FROM StressLog s WHERE s.user = :user")
    Double getAverageTechFactor(User user);
    
    @Query("SELECT AVG(s.humanFactor) FROM StressLog s WHERE s.user = :user")
    Double getAverageHumanFactor(User user);
}

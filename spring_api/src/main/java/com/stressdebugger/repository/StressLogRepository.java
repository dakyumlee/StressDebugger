package com.stressdebugger.repository;

import com.stressdebugger.model.StressLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.time.LocalDateTime;
import java.util.List;

public interface StressLogRepository extends JpaRepository<StressLog, Long> {
    
    List<StressLog> findByUsernameOrderByCreatedAtDesc(String username);
    
    List<StressLog> findByUsernameAndCreatedAtAfter(String username, LocalDateTime createdAt);
    
    @Query("SELECT s FROM StressLog s ORDER BY s.createdAt DESC")
    List<StressLog> findAllOrderByCreatedAtDesc();
    
    void deleteByUsername(String username);
}

package com.stressdebugger.repository;

import com.stressdebugger.model.StressLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface StressLogRepository extends JpaRepository<StressLog, Long> {
    
    List<StressLog> findByUsername(String username);
    
    List<StressLog> findByUsernameOrderByCreatedAtDesc(String username);
    
    List<StressLog> findByUsernameAndCreatedAtAfter(String username, LocalDateTime createdAt);
    
    List<StressLog> findAllByOrderByCreatedAtDesc();
    
    void deleteByUsername(String username);
}

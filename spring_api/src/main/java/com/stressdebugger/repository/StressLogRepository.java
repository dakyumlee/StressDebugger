package com.stressdebugger.repository;

import com.stressdebugger.model.StressLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface StressLogRepository extends JpaRepository<StressLog, Long> {
    List<StressLog> findByUserId(Long userId);
    List<StressLog> findByUsername(String username);
    List<StressLog> findByUsernameOrderByCreatedAtDesc(String username);
    List<StressLog> findByUsernameAndCreatedAtAfter(String username, LocalDateTime date);
    List<StressLog> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<StressLog> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT s FROM StressLog s ORDER BY s.createdAt DESC")
    List<StressLog> findAllOrderByCreatedAtDesc();
    
    void deleteByUsername(String username);
}
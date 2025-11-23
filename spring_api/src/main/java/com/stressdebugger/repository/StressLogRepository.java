package com.stressdebugger.repository;

import com.stressdebugger.model.StressLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface StressLogRepository extends JpaRepository<StressLog, Long> {
    List<StressLog> findByUserId(Long userId);
    List<StressLog> findByUsername(String username);
    List<StressLog> findByUserIdOrderByCreatedAtDesc(Long userId);
    List<StressLog> findByCreatedAtBetween(LocalDateTime start, LocalDateTime end);
    void deleteByUsername(String username);
}
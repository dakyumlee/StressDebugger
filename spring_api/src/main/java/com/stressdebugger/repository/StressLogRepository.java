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
    
    List<StressLog> findByUserId(Long userId);
    
    List<StressLog> findByUserIdOrderByCreatedAtDesc(Long userId);
    
    @Query("SELECT l FROM StressLog l WHERE l.user.id = :userId AND l.createdAt BETWEEN :start AND :end")
    List<StressLog> findByUserIdAndDateRange(@Param("userId") Long userId, @Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
    
    @Query("SELECT l FROM StressLog l WHERE l.user.username = :username ORDER BY l.createdAt DESC")
    List<StressLog> findByUsername(@Param("username") String username);
    
    void deleteByUsername(String username);
}

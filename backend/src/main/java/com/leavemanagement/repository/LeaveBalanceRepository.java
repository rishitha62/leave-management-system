package com.leavemanagement.repository;

import com.leavemanagement.model.LeaveBalance;
import com.leavemanagement.model.LeaveType;
import com.leavemanagement.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LeaveBalanceRepository extends JpaRepository<LeaveBalance, Long> {
    List<LeaveBalance> findByUser(User user);
    List<LeaveBalance> findByUserIdAndYear(Long userId, Integer year);
    Optional<LeaveBalance> findByUserAndLeaveTypeAndYear(User user, LeaveType leaveType, Integer year);
}
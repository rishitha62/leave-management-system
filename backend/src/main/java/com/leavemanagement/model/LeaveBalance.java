package com.leavemanagement.model;

import javax.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import javax.validation.constraints.*;

@Entity
@Table(name = "leave_balances")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LeaveBalance {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "leave_type_id", nullable = false)
    private LeaveType leaveType;

    @Column(name = "allocated_days", nullable = false)
    private Double allocatedDays;

    @Column(name = "used_days", nullable = false)
    private Double usedDays = 0.0;

    @Column(name = "remaining_days", nullable = false)
    private Double remainingDays;

    @Column(nullable = false)
    private Integer year;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
        this.remainingDays = this.allocatedDays - this.usedDays;
    }

    @PrePersist
    public void prePersist() {
        this.remainingDays = this.allocatedDays - this.usedDays;
    }
}
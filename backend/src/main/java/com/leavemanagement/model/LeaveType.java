package com.leavemanagement.model;

import javax.persistence.*;
import lombok.*;
import javax.validation.constraints.*;

@Entity
@Table(name = "leave_types")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LeaveType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    @NotBlank(message = "Leave type name is required")
    private String name; // e.g., ANNUAL, SICK, CASUAL

    @Column(name = "default_days", nullable = false)
    private Integer defaultDays; // Default allocation per year

    @Column(length = 500)
    private String description;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
}
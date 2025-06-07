package com.blogsystem.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_likes", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "blog_id"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserLike {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "blog_id", nullable = false)
    private Long blogId;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // 关联用户实体
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    // 关联博客实体
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "blog_id", insertable = false, updatable = false)
    private Blog blog;

    public UserLike(Long userId, Long blogId) {
        this.userId = userId;
        this.blogId = blogId;
    }
}
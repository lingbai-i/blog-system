package com.blogsystem.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonIgnore;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "tags")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Tag {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(length = 200)
    private String description;

    @Column(name = "color_code", length = 7)
    private String colorCode; // 用于前端显示的颜色代码，如 #28A745

    @Column(name = "is_active")
    private Boolean isActive = true;

    @CreationTimestamp
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // 与Blog的多对多关系 - 添加@JsonIgnore防止循环引用
    @ManyToMany(mappedBy = "tagEntities", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Blog> blogs;

    // 博客数量统计
    @Transient
    private Long blogCount;

    public Tag(String name) {
        this.name = name;
    }

    public Tag(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public Tag(String name, String description, String colorCode) {
        this.name = name;
        this.description = description;
        this.colorCode = colorCode;
    }

    // 便于调试的toString方法
    @Override
    public String toString() {
        return "Tag{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", colorCode='" + colorCode + '\'' +
                ", isActive=" + isActive +
                '}';
    }
}
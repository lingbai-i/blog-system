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
@Table(name = "blogs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Blog {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false, length = 200)
  private String title;

  @Column(columnDefinition = "TEXT")
  private String content;

  @Column(length = 500)
  private String summary;

  @Column(name = "author_name", length = 100)
  private String authorName;

  @Column(name = "view_count")
  private Integer viewCount = 0;

  @Column(name = "like_count")
  private Integer likeCount = 0;

  @CreationTimestamp
  @Column(name = "created_at")
  private LocalDateTime createdAt;

  @UpdateTimestamp
  @Column(name = "updated_at")
  private LocalDateTime updatedAt;

  @Column(name = "published_at")
  private LocalDateTime publishedAt;

  @Column(name = "is_published")
  private Boolean isPublished = false;

  @Column(length = 100)
  private String category;

  @Column(length = 500)
  private String tags;

  @Column(name = "images", columnDefinition = "TEXT")
  private String images; // 存储图片URL列表，JSON格式

  // 用户关联 - 博客作者
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "user_id")
  private User user;

  // 新的关系映射 - 添加@JsonIgnore防止循环引用
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "category_id")
  @JsonIgnore
  private Category categoryEntity;

  @ManyToMany(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
  @JoinTable(name = "blog_tags", joinColumns = @JoinColumn(name = "blog_id"), inverseJoinColumns = @JoinColumn(name = "tag_id"))
  @JsonIgnore
  private List<Tag> tagEntities;
}
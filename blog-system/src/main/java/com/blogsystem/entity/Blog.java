package com.blogsystem.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.blogsystem.enums.ArticleStatus;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "articles")
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

  @Enumerated(EnumType.STRING)
  @Column(name = "status", nullable = false)
  private ArticleStatus status = ArticleStatus.DRAFT;

  @Column(length = 100)
  private String category;

  @Column(length = 500)
  private String tags;

  @Column(name = "images", columnDefinition = "TEXT")
  private String images; // 存储图片URL列表，JSON格式

  // 用户关联 - 博客作者
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "author_id")
  @JsonIgnore
  private User user;

  // 新的关系映射 - 添加@JsonIgnore防止循环引用
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "category_id")
  @JsonIgnore
  private Category categoryEntity;

  @ManyToMany(fetch = FetchType.LAZY, cascade = { CascadeType.PERSIST, CascadeType.MERGE })
  @JoinTable(name = "article_tags", joinColumns = @JoinColumn(name = "article_id"), inverseJoinColumns = @JoinColumn(name = "tag_id"))
  @JsonIgnore
  private List<Tag> tagEntities;

  // 便利方法
  public boolean isPublished() {
    return status == ArticleStatus.PUBLISHED;
  }

  public void setPublished(boolean published) {
    if (published) {
      this.status = ArticleStatus.PUBLISHED;
      if (this.publishedAt == null) {
        this.publishedAt = LocalDateTime.now();
      }
    } else {
      this.status = ArticleStatus.DRAFT;
    }
  }

  // 手动添加getter/setter方法以解决Lombok问题
  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getSummary() {
    return summary;
  }

  public void setSummary(String summary) {
    this.summary = summary;
  }

  public Integer getViewCount() {
    return viewCount;
  }

  public void setViewCount(Integer viewCount) {
    this.viewCount = viewCount;
  }

  public Integer getLikeCount() {
    return likeCount;
  }

  public void setLikeCount(Integer likeCount) {
    this.likeCount = likeCount;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  public LocalDateTime getPublishedAt() {
    return publishedAt;
  }

  public void setPublishedAt(LocalDateTime publishedAt) {
    this.publishedAt = publishedAt;
  }

  public ArticleStatus getStatus() {
    return status;
  }

  public void setStatus(ArticleStatus status) {
    this.status = status;
  }

  public String getCategory() {
    return category;
  }

  public void setCategory(String category) {
    this.category = category;
  }

  public String getTags() {
    return tags;
  }

  public void setTags(String tags) {
    this.tags = tags;
  }

  public String getImages() {
    return images;
  }

  public void setImages(String images) {
    this.images = images;
  }

  public User getUser() {
    return user;
  }

  public void setUser(User user) {
    this.user = user;
  }

  public Category getCategoryEntity() {
    return categoryEntity;
  }

  public void setCategoryEntity(Category categoryEntity) {
    this.categoryEntity = categoryEntity;
  }

  public List<Tag> getTagEntities() {
    return tagEntities;
  }

  public void setTagEntities(List<Tag> tagEntities) {
    this.tagEntities = tagEntities;
  }
}
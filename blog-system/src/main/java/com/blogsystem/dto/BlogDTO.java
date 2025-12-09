package com.blogsystem.dto;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.enums.ArticleStatus;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BlogDTO {
    private Long id;
    private String title;
    private String content;
    private String summary;
    private String authorName;
    private String authorAvatar;
    private Long authorId; // 作者ID
    private Long userId; // 用户ID
    private String username; // 用户名用于权限检查
    private Integer viewCount;
    private Integer likeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime publishedAt;
    private ArticleStatus status;
    private String category;
    private String tags;
    private String images;

    // 从Blog实体转换为DTO的静态方法
    public static BlogDTO fromEntity(Blog blog, User author) {
        BlogDTO dto = new BlogDTO();
        dto.setId(blog.getId());
        dto.setTitle(blog.getTitle());
        dto.setContent(blog.getContent());
        dto.setSummary(blog.getSummary());
        dto.setAuthorName(author != null ? author.getUsername() : (blog.getUser() != null ? blog.getUser().getUsername() : null));
        dto.setAuthorAvatar(author != null ? author.getAvatar() : null);
        dto.setAuthorId(author != null ? author.getId() : null);
        dto.setUserId(author != null ? author.getId() : null);
        dto.setUsername(author != null ? author.getUsername() : null);
        dto.setViewCount(blog.getViewCount());
        dto.setLikeCount(blog.getLikeCount());
        dto.setCreatedAt(blog.getCreatedAt());
        dto.setUpdatedAt(blog.getUpdatedAt());
        dto.setPublishedAt(blog.getPublishedAt());
        dto.setStatus(blog.getStatus());
        dto.setCategory(blog.getCategory());
        dto.setTags(blog.getTags());
        dto.setImages(blog.getImages());
        return dto;
    }

    // 从Blog实体转换为DTO的静态方法（不包含作者信息）
    public static BlogDTO fromEntity(Blog blog) {
        BlogDTO dto = new BlogDTO();
        dto.setId(blog.getId());
        dto.setTitle(blog.getTitle());
        dto.setContent(blog.getContent());
        dto.setSummary(blog.getSummary());
        dto.setViewCount(blog.getViewCount());
        dto.setLikeCount(blog.getLikeCount());
        dto.setCreatedAt(blog.getCreatedAt());
        dto.setUpdatedAt(blog.getUpdatedAt());
        dto.setPublishedAt(blog.getPublishedAt());
        dto.setStatus(blog.getStatus());
        dto.setCategory(blog.getCategory());
        dto.setTags(blog.getTags());
        dto.setImages(blog.getImages());
        
        // 设置作者信息
        if (blog.getUser() != null) {
            dto.setAuthorId(blog.getUser().getId());
            dto.setAuthorName(blog.getUser().getUsername());
            dto.setAuthorAvatar(blog.getUser().getAvatar());
            dto.setUserId(blog.getUser().getId());
            dto.setUsername(blog.getUser().getUsername());
        }
        
        return dto;
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

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getAuthorAvatar() {
        return authorAvatar;
    }

    public void setAuthorAvatar(String authorAvatar) {
        this.authorAvatar = authorAvatar;
    }

    public Long getAuthorId() {
        return authorId;
    }

    public void setAuthorId(Long authorId) {
        this.authorId = authorId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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
}
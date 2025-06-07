package com.blogsystem.dto;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
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
    private Long userId; // 用户ID
    private String userAccount; // 用户账号用于权限检查
    private Integer viewCount;
    private Integer likeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime publishedAt;
    private Boolean isPublished;
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
        dto.setAuthorName(blog.getAuthorName());
        dto.setAuthorAvatar(author != null ? author.getAvatar() : null);
        dto.setUserId(author != null ? author.getId() : null);
        dto.setUserAccount(author != null ? author.getAccount() : null);
        dto.setViewCount(blog.getViewCount());
        dto.setLikeCount(blog.getLikeCount());
        dto.setCreatedAt(blog.getCreatedAt());
        dto.setUpdatedAt(blog.getUpdatedAt());
        dto.setPublishedAt(blog.getPublishedAt());
        dto.setIsPublished(blog.getIsPublished());
        dto.setCategory(blog.getCategory());
        dto.setTags(blog.getTags());
        dto.setImages(blog.getImages());
        return dto;
    }

    // 从Blog实体转换为DTO的静态方法（不包含作者信息）
    public static BlogDTO fromEntity(Blog blog) {
        return fromEntity(blog, null);
    }
}
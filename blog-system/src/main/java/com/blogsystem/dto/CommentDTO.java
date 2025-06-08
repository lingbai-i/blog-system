package com.blogsystem.dto;

import com.blogsystem.entity.Comment;
import com.blogsystem.entity.User;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CommentDTO {
    private Long id;
    private Long blogId;
    private String authorName;
    private String authorEmail;
    private String authorAvatar;
    private Long userId; // 用户ID
    private String userAccount; // 用户账号用于权限检查
    private String content;
    private LocalDateTime createdAt;
    private Boolean isApproved;
    private Long parentId;
    private String replyToName; // 被回复的用户名
    private String images; // 评论图片列表，JSON格式
    private List<CommentDTO> replies;

    // 从Comment实体转换为DTO的静态方法
    public static CommentDTO fromEntity(Comment comment) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setBlogId(comment.getBlog() != null ? comment.getBlog().getId() : null);
        dto.setAuthorName(comment.getAuthorName());
        dto.setAuthorEmail(comment.getAuthorEmail());
        dto.setAuthorAvatar(comment.getUser() != null ? comment.getUser().getAvatar() : null);
        dto.setUserId(comment.getUser() != null ? comment.getUser().getId() : null);
        dto.setUserAccount(comment.getUser() != null ? comment.getUser().getAccount() : null);
        dto.setContent(comment.getContent());
        dto.setCreatedAt(comment.getCreatedAt());
        dto.setIsApproved(comment.getIsApproved());
        dto.setParentId(comment.getParent() != null ? comment.getParent().getId() : null);
        dto.setReplyToName(comment.getReplyToName()); // 设置被回复的用户名
        dto.setImages(comment.getImages()); // 设置图片列表
        return dto;
    }

    // 从Comment实体转换为DTO，包含回复的静态方法
    public static CommentDTO fromEntityWithReplies(Comment comment, List<Comment> replies) {
        CommentDTO dto = fromEntity(comment);
        if (replies != null && !replies.isEmpty()) {
            dto.setReplies(replies.stream()
                    .map(CommentDTO::fromEntity)
                    .collect(Collectors.toList()));
        }
        return dto;
    }
}
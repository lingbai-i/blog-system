package com.blogsystem.dto;

import com.blogsystem.entity.Comment;
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
    private String content;
    private LocalDateTime createdAt;
    private Boolean isApproved;
    private Long parentId;
    private List<CommentDTO> replies;

    // 从Comment实体转换为DTO的静态方法
    public static CommentDTO fromEntity(Comment comment) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setBlogId(comment.getBlog() != null ? comment.getBlog().getId() : null);
        dto.setAuthorName(comment.getAuthorName());
        dto.setAuthorEmail(comment.getAuthorEmail());
        dto.setContent(comment.getContent());
        dto.setCreatedAt(comment.getCreatedAt());
        dto.setIsApproved(comment.getIsApproved());
        dto.setParentId(comment.getParent() != null ? comment.getParent().getId() : null);
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
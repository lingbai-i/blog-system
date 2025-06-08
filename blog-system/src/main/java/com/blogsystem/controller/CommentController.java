package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.Comment;
import com.blogsystem.entity.User;
import com.blogsystem.dto.CommentDTO;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.CommentService;
import com.blogsystem.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class CommentController {

    private final CommentService commentService;
    private final BlogService blogService;
    private final UserService userService;

    // 创建评论
    @PostMapping
    public ResponseEntity<Object> createComment(@RequestBody Map<String, Object> request) {
        try {
            if (request.get("blogId") == null || request.get("content") == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "缺少必要参数");
                return ResponseEntity.badRequest().body(response);
            }
            
            Long blogId = Long.valueOf(request.get("blogId").toString());
            String content = request.get("content").toString();
            String images = request.containsKey("images") ? request.get("images").toString() : null;
            String authorName = "匿名用户";
            String authorEmail = "";

            Optional<Blog> blogOpt = blogService.findById(blogId);
            if (!blogOpt.isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "博客不存在");
                return ResponseEntity.badRequest().body(response);
            }

            User user = null;
            if (request.containsKey("userId") && request.get("userId") != null) {
                Long userId = Long.valueOf(request.get("userId").toString());
                Optional<User> userOpt = userService.findById(userId);
                if (userOpt.isPresent()) {
                    user = userOpt.get();
                    authorName = user.getUsername(); // 使用真实用户名
                    authorEmail = user.getEmail() != null ? user.getEmail() : "";
                }
            }

            Comment comment = commentService.createComment(blogOpt.get(), user, content, authorName, authorEmail, images);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "评论提交成功");
            response.put("comment", CommentDTO.fromEntity(comment));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "评论提交失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 创建回复评论
    @PostMapping("/reply")
    public ResponseEntity<Object> createReply(@RequestBody Map<String, Object> request) {
        try {
            if (request.get("blogId") == null || request.get("parentId") == null || request.get("content") == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "缺少必要参数");
                return ResponseEntity.badRequest().body(response);
            }
            
            Long blogId = Long.valueOf(request.get("blogId").toString());
            Long parentId = Long.valueOf(request.get("parentId").toString());
            String content = request.get("content").toString();
            String images = request.containsKey("images") ? request.get("images").toString() : null;
            String authorName = "匿名用户";
            String authorEmail = "";
            String replyToName = null; // 新增：被回复的用户名

            Optional<Blog> blogOpt = blogService.findById(blogId);
            Optional<Comment> parentOpt = commentService.findById(parentId);

            if (!blogOpt.isPresent() || !parentOpt.isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "博客或父评论不存在");
                return ResponseEntity.badRequest().body(response);
            }

            User user = null;
            if (request.containsKey("userId") && request.get("userId") != null) {
                Long userId = Long.valueOf(request.get("userId").toString());
                Optional<User> userOpt = userService.findById(userId);
                if (userOpt.isPresent()) {
                    user = userOpt.get();
                    authorName = user.getUsername(); // 使用真实用户名
                    authorEmail = user.getEmail() != null ? user.getEmail() : "";
                }
            }
            
            // 获取被回复的用户名
            if (request.containsKey("replyToName") && request.get("replyToName") != null) {
                replyToName = request.get("replyToName").toString();
            }

            Comment reply;
            if (replyToName != null) {
                // 使用支持多级回复的方法
                reply = commentService.createReply(blogOpt.get(), user, parentOpt.get(), content, authorName,
                        authorEmail, replyToName, images);
            } else {
                // 使用原有的方法
                reply = commentService.createReply(blogOpt.get(), user, parentOpt.get(), content, authorName,
                        authorEmail, images);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "回复提交成功");
            response.put("comment", CommentDTO.fromEntity(reply));

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "回复提交失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 获取博客的所有已审核评论
    @GetMapping("/blog/{blogId}")
    public ResponseEntity<List<CommentDTO>> getCommentsByBlog(@PathVariable Long blogId) {
        Optional<Blog> blogOpt = blogService.findById(blogId);
        if (blogOpt.isPresent()) {
            List<Comment> comments = commentService.getTopLevelCommentsByBlog(blogOpt.get());
            List<CommentDTO> commentDTOs = comments.stream()
                    .map(CommentDTO::fromEntity)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(commentDTOs);
        }
        return ResponseEntity.notFound().build();
    }

    // 获取评论的回复
    @GetMapping("/{commentId}/replies")
    public ResponseEntity<List<CommentDTO>> getRepliesByComment(@PathVariable Long commentId) {
        Optional<Comment> commentOpt = commentService.findById(commentId);
        if (commentOpt.isPresent()) {
            List<Comment> replies = commentService.getRepliesByComment(commentOpt.get());
            List<CommentDTO> replyDTOs = replies.stream()
                    .map(CommentDTO::fromEntity)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(replyDTOs);
        }
        return ResponseEntity.notFound().build();
    }

    // 获取待审核的评论（管理员功能）
    @GetMapping("/pending")
    public ResponseEntity<Page<Comment>> getPendingComments(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Comment> comments = commentService.getPendingComments(page, size);
        return ResponseEntity.ok(comments);
    }

    // 审核通过评论
    @PutMapping("/{id}/approve")
    public ResponseEntity<Comment> approveComment(@PathVariable Long id) {
        Comment comment = commentService.approveComment(id);
        if (comment != null) {
            return ResponseEntity.ok(comment);
        }
        return ResponseEntity.notFound().build();
    }

    // 拒绝评论
    @DeleteMapping("/{id}/reject")
    public ResponseEntity<Object> rejectComment(@PathVariable Long id) {
        Optional<Comment> commentOpt = commentService.findById(id);
        if (commentOpt.isPresent()) {
            commentService.rejectComment(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "评论已拒绝");
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

    // 删除评论（带权限控制）
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteComment(
        @PathVariable Long id, 
        @RequestHeader(value = "Authorization", required = false) String authHeader) {
        Optional<Comment> commentOpt = commentService.findById(id);
        if (!commentOpt.isPresent()) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "评论不存在");
            return ResponseEntity.status(404).body(response);
        }
        
        Comment comment = commentOpt.get();
        
        // 检查用户权限
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    Optional<User> userOpt = userService.findById(userId);
                    
                    if (userOpt.isPresent()) {
                        User currentUser = userOpt.get();
                        
                        // 检查权限：用户可以删除自己的评论，或者文章作者可以删除任何评论
                        boolean canDelete = false;
                        
                        // 1. 用户删除自己的评论
                        if (comment.getUser() != null && comment.getUser().getId().equals(userId)) {
                            canDelete = true;
                        }
                        
                        // 2. 文章作者删除任何评论
                        // 通过authorName查找作者用户
                        String blogAuthorName = comment.getBlog().getAuthorName();
                        if (blogAuthorName != null && blogAuthorName.equals(currentUser.getUsername())) {
                            canDelete = true;
                        }
                        
                        if (canDelete) {
                            commentService.deleteComment(id);
                            Map<String, Object> response = new HashMap<>();
                            response.put("success", true);
                            response.put("message", "评论已删除");
                            return ResponseEntity.ok(response);
                        } else {
                            Map<String, Object> response = new HashMap<>();
                            response.put("success", false);
                            response.put("message", "没有权限删除此评论");
                            return ResponseEntity.status(403).body(response);
                        }
                    }
                }
            } catch (NumberFormatException e) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "无效的认证信息");
                return ResponseEntity.status(401).body(response);
            }
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", "需要登录才能删除评论");
        return ResponseEntity.status(401).body(response);
    }

    // 获取博客的评论数量
    @GetMapping("/blog/{blogId}/count")
    public ResponseEntity<Object> getCommentCountByBlog(@PathVariable Long blogId) {
        Optional<Blog> blogOpt = blogService.findById(blogId);
        if (blogOpt.isPresent()) {
            long count = commentService.getCommentCountByBlog(blogOpt.get());
            Map<String, Object> response = new HashMap<>();
            response.put("count", count);
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
    }

    // 批量审核评论
    @PutMapping("/batch/approve")
    public ResponseEntity<Object> approveComments(@RequestBody Map<String, List<Long>> request) {
        List<Long> commentIds = request.get("commentIds");
        commentService.approveComments(commentIds);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "批量审核成功");
        return ResponseEntity.ok(response);
    }

    // 批量删除评论
    @DeleteMapping("/batch")
    public ResponseEntity<Object> deleteComments(@RequestBody Map<String, List<Long>> request) {
        List<Long> commentIds = request.get("commentIds");
        commentService.deleteComments(commentIds);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "批量删除成功");
        return ResponseEntity.ok(response);
    }

    // 获取评论统计信息
    @GetMapping("/stats")
    public ResponseEntity<Object> getCommentStats() {
        long totalComments = commentService.getTotalApprovedComments();
        Map<String, Object> response = new HashMap<>();
        response.put("totalApprovedComments", totalComments);
        return ResponseEntity.ok(response);
    }
}
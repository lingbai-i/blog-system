package com.blogsystem.controller;

import com.blogsystem.entity.Comment;
import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.service.CommentService;
import com.blogsystem.service.BlogService;
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
            Long blogId = Long.valueOf(request.get("blogId").toString());
            String content = request.get("content").toString();
            String authorName = request.get("authorName").toString();
            String authorEmail = request.get("authorEmail").toString();

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
                user = userOpt.orElse(null);
            }

            Comment comment = commentService.createComment(blogOpt.get(), user, content, authorName, authorEmail);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "评论提交成功，等待审核");
            response.put("comment", comment);

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
            Long blogId = Long.valueOf(request.get("blogId").toString());
            Long parentId = Long.valueOf(request.get("parentId").toString());
            String content = request.get("content").toString();
            String authorName = request.get("authorName").toString();
            String authorEmail = request.get("authorEmail").toString();

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
                user = userOpt.orElse(null);
            }

            Comment reply = commentService.createReply(blogOpt.get(), user, parentOpt.get(), content, authorName,
                    authorEmail);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "回复提交成功，等待审核");
            response.put("comment", reply);

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
    public ResponseEntity<List<Comment>> getCommentsByBlog(@PathVariable Long blogId) {
        Optional<Blog> blogOpt = blogService.findById(blogId);
        if (blogOpt.isPresent()) {
            List<Comment> comments = commentService.getTopLevelCommentsByBlog(blogOpt.get());
            return ResponseEntity.ok(comments);
        }
        return ResponseEntity.notFound().build();
    }

    // 获取评论的回复
    @GetMapping("/{commentId}/replies")
    public ResponseEntity<List<Comment>> getRepliesByComment(@PathVariable Long commentId) {
        Optional<Comment> commentOpt = commentService.findById(commentId);
        if (commentOpt.isPresent()) {
            List<Comment> replies = commentService.getRepliesByComment(commentOpt.get());
            return ResponseEntity.ok(replies);
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

    // 删除评论
    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteComment(@PathVariable Long id) {
        Optional<Comment> commentOpt = commentService.findById(id);
        if (commentOpt.isPresent()) {
            commentService.deleteComment(id);
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "评论已删除");
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();
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
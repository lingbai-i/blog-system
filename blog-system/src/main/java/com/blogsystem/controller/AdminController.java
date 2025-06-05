package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class AdminController {

    private final BlogService blogService;
    private final UserService userService;

    // 获取所有博客（管理员，支持搜索和状态筛选）
    @GetMapping("/blogs")
    public ResponseEntity<Map<String, Object>> getAllBlogsForAdmin(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status) {

        Page<Blog> blogs;

        // 根据搜索关键字和状态筛选
        if (keyword != null && !keyword.trim().isEmpty()) {
            if ("published".equals(status)) {
                blogs = blogService.searchBlogs(keyword.trim(), page, size);
            } else if ("draft".equals(status)) {
                blogs = blogService.searchDraftBlogs(keyword.trim(), page, size);
            } else {
                blogs = blogService.searchAllBlogs(keyword.trim(), page, size);
            }
        } else {
            if ("published".equals(status)) {
                blogs = blogService.findPublishedBlogs(page, size);
            } else if ("draft".equals(status)) {
                blogs = blogService.findDraftBlogs(page, size);
            } else {
                blogs = blogService.findAllBlogs(page, size);
            }
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", blogs);

        return ResponseEntity.ok(response);
    }

    // 获取统计数据
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();

        // 获取博客统计
        long totalBlogs = blogService.getTotalBlogsCount();
        long publishedBlogs = blogService.getPublishedBlogsCount();
        long draftBlogs = totalBlogs - publishedBlogs;

        // 获取用户统计
        long totalUsers = userService.getTotalUsersCount();

        stats.put("totalBlogs", totalBlogs);
        stats.put("publishedBlogs", publishedBlogs);
        stats.put("draftBlogs", draftBlogs);
        stats.put("totalUsers", totalUsers);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", stats);

        return ResponseEntity.ok(response);
    }

    // 管理员登录
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> adminLogin(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String password = request.get("password");

        Map<String, Object> response = new HashMap<>();

        // 简单的管理员验证
        if ("admin".equals(username) && "admin123".equals(password)) {
            response.put("success", true);
            response.put("message", "登录成功");
            response.put("token", "admin_token_" + System.currentTimeMillis());
        } else {
            response.put("success", false);
            response.put("message", "用户名或密码错误");
        }

        return ResponseEntity.ok(response);
    }

    // 删除博客
    @DeleteMapping("/blogs/{id}")
    public ResponseEntity<Map<String, Object>> deleteBlog(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();

        try {
            blogService.deleteBlog(id);
            response.put("success", true);
            response.put("message", "博客删除成功");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "删除失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // 更新博客状态
    @PutMapping("/blogs/{id}/status")
    public ResponseEntity<Map<String, Object>> updateBlogStatus(
            @PathVariable Long id,
            @RequestBody Map<String, Object> request) {

        Map<String, Object> response = new HashMap<>();

        try {
            Boolean isPublished = (Boolean) request.get("isPublished");
            Blog updatedBlog = blogService.updateBlogStatus(id, isPublished);
            response.put("success", true);
            response.put("message", "状态更新成功");
            response.put("data", updatedBlog);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "更新失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}
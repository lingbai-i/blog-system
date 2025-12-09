package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.entity.Announcement;
import com.blogsystem.enums.ArticleStatus;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;
import com.blogsystem.service.AnnouncementService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Optional;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class AdminController {

    private final BlogService blogService;
    private final UserService userService;
    private final AnnouncementService announcementService;

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

        // 创建简化的博客数据传输对象，避免序列化问题
        Page<Map<String, Object>> blogDTOs = blogs.map(blog -> {
            Map<String, Object> blogDTO = new HashMap<>();
            blogDTO.put("id", blog.getId());
            blogDTO.put("title", blog.getTitle());
            blogDTO.put("content", blog.getContent());
            blogDTO.put("summary", blog.getSummary());
            blogDTO.put("viewCount", blog.getViewCount());
            blogDTO.put("likeCount", blog.getLikeCount());
            blogDTO.put("createdAt", blog.getCreatedAt());
            blogDTO.put("updatedAt", blog.getUpdatedAt());
            blogDTO.put("publishedAt", blog.getPublishedAt());
            blogDTO.put("status", blog.getStatus());
            blogDTO.put("category", blog.getCategory());
            blogDTO.put("tags", blog.getTags());
            blogDTO.put("images", blog.getImages());
            
            // 添加作者信息（避免序列化代理对象）
            if (blog.getUser() != null) {
                Map<String, Object> authorInfo = new HashMap<>();
                authorInfo.put("id", blog.getUser().getId());
                authorInfo.put("username", blog.getUser().getUsername());
                authorInfo.put("nickname", blog.getUser().getNickname());
                authorInfo.put("avatar", blog.getUser().getAvatar());
                blogDTO.put("author", authorInfo);
            }
            
            return blogDTO;
        });

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", blogDTOs);

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
        long totalViews = blogService.getTotalViewsCount();

        // 获取用户统计
        long totalUsers = userService.getTotalUsersCount();

        // 获取今日发布统计
        long todayPosts = blogService.getTodayPublishedCount();

        // 获取公告统计
        long totalAnnouncements = announcementService.getTotalAnnouncementCount();
        long publishedAnnouncements = announcementService.getPublishedAnnouncementCount();
        long pinnedAnnouncements = announcementService.getPinnedAnnouncementCount();

        stats.put("totalBlogs", totalBlogs);
        stats.put("publishedBlogs", publishedBlogs);
        stats.put("draftBlogs", draftBlogs);
        stats.put("totalViews", totalViews);
        stats.put("totalUsers", totalUsers);
        stats.put("todayPosts", todayPosts);
        stats.put("totalAnnouncements", totalAnnouncements);
        stats.put("publishedAnnouncements", publishedAnnouncements);
        stats.put("pinnedAnnouncements", pinnedAnnouncements);

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
            Map<String, Object> data = new HashMap<>();
            data.put("token", "admin_token_" + System.currentTimeMillis());
            data.put("username", username);

            response.put("success", true);
            response.put("message", "登录成功");
            response.put("data", data);
        } else {
            response.put("success", false);
            response.put("message", "用户名或密码错误");
        }

        return ResponseEntity.ok(response);
    }

    // 删除博客
    @DeleteMapping("/blogs/{id}")
    public ResponseEntity<Map<String, Object>> deleteBlog(@PathVariable Long id, HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        token = token.substring(7);
        try {
            // 检查是否为管理员token格式
            if (token.startsWith("admin_token_")) {
                // 管理员token格式：admin_token_timestamp
                // 直接执行删除操作，无需验证用户表
                blogService.deleteBlog(id);
                response.put("success", true);
                response.put("message", "博客删除成功");
            } else {
                // 解析普通用户token获取用户信息
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    Optional<User> userOpt = userService.findById(userId);

                    if (userOpt.isPresent()) {
                        User user = userOpt.get();
                        String userRole = user.getIsAdmin() ? "admin" : "user";

                        // 检查是否为管理员
                        if (!"admin".equals(userRole)) {
                            response.put("success", false);
                            response.put("message", "权限不足，只有管理员可以删除博客");
                            return ResponseEntity.status(403).body(response);
                        }

                        // 执行删除操作
                        blogService.deleteBlog(id);
                        response.put("success", true);
                        response.put("message", "博客删除成功");
                    } else {
                        response.put("success", false);
                        response.put("message", "用户不存在");
                        return ResponseEntity.status(401).body(response);
                    }
                } else {
                    response.put("success", false);
                    response.put("message", "token格式错误");
                    return ResponseEntity.status(401).body(response);
                }
            }
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("message", "token解析错误");
            return ResponseEntity.status(401).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "删除失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
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
            String statusStr = (String) request.get("status");
            ArticleStatus status = ArticleStatus.valueOf(statusStr.toUpperCase());
            Blog updatedBlog = blogService.updateBlogStatus(id, status);
            response.put("success", true);
            response.put("message", "状态更新成功");
            response.put("data", updatedBlog);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "更新失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // ==================== 公告管理接口 ====================

    // 获取所有公告（管理员，支持分页和搜索）
    @GetMapping("/announcements")
    public ResponseEntity<Map<String, Object>> getAllAnnouncements(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword) {
        Map<String, Object> response = new HashMap<>();
        try {
            Page<Announcement> announcements;
            if (keyword != null && !keyword.trim().isEmpty()) {
                announcements = announcementService.searchAnnouncements(keyword.trim(), page, size);
            } else {
                announcements = announcementService.findAllAnnouncements(page, size);
            }
            response.put("success", true);
            response.put("data", announcements);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "获取公告列表失败: " + e.getMessage());
        }
        return ResponseEntity.ok(response);
    }

    // 创建公告
    @PostMapping("/announcements")
    public ResponseEntity<Map<String, Object>> createAnnouncement(
            @RequestBody Announcement announcement,
            HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        try {
            // 设置作者信息（简化处理，实际应从token解析）
            announcement.setAuthorId(1L);
            announcement.setAuthorName("管理员");

            Announcement createdAnnouncement = announcementService.createAnnouncement(announcement);
            response.put("success", true);
            response.put("message", "公告创建成功");
            response.put("data", createdAnnouncement);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "创建公告失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // 更新公告
    @PutMapping("/announcements/{id}")
    public ResponseEntity<Map<String, Object>> updateAnnouncement(
            @PathVariable Long id,
            @RequestBody Announcement announcement,
            HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        try {
            Announcement updatedAnnouncement = announcementService.updateAnnouncement(id, announcement);
            if (updatedAnnouncement != null) {
                response.put("success", true);
                response.put("message", "公告更新成功");
                response.put("data", updatedAnnouncement);
            } else {
                response.put("success", false);
                response.put("message", "公告不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "更新公告失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // 发布/取消发布公告
    @PutMapping("/announcements/{id}/publish")
    public ResponseEntity<Map<String, Object>> togglePublishAnnouncement(
            @PathVariable Long id,
            @RequestBody Map<String, Boolean> request,
            HttpServletRequest httpRequest) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = httpRequest.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        try {
            Boolean isPublished = request.get("isPublished");
            Announcement updatedAnnouncement;

            if (isPublished) {
                updatedAnnouncement = announcementService.publishAnnouncement(id);
            } else {
                updatedAnnouncement = announcementService.unpublishAnnouncement(id);
            }

            if (updatedAnnouncement != null) {
                response.put("success", true);
                response.put("message", isPublished ? "公告发布成功" : "公告取消发布成功");
                response.put("data", updatedAnnouncement);
            } else {
                response.put("success", false);
                response.put("message", "公告不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "操作失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // 置顶/取消置顶公告 List<Announcement> announcements =
    // announcementService.getAllAnnouncements();

    @PutMapping("/announcements/{id}/pin")
    public ResponseEntity<Map<String, Object>> togglePinAnnouncement(
            @PathVariable Long id,
            HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        try {
            Announcement updatedAnnouncement = announcementService.togglePinAnnouncement(id);
            if (updatedAnnouncement != null) {
                response.put("success", true);
                response.put("message", updatedAnnouncement.getIsPinned() ? "公告置顶成功" : "公告取消置顶成功");
                response.put("data", updatedAnnouncement);
            } else {
                response.put("success", false);
                response.put("message", "公告不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "操作失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }

    // 删除公告
    @DeleteMapping("/announcements/{id}")
    public ResponseEntity<Map<String, Object>> deleteAnnouncement(
            @PathVariable Long id,
            HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        // 验证管理员权限
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            response.put("success", false);
            response.put("message", "未授权访问");
            return ResponseEntity.status(401).body(response);
        }

        try {
            boolean deleted = announcementService.deleteAnnouncement(id);
            if (deleted) {
                response.put("success", true);
                response.put("message", "公告删除成功");
            } else {
                response.put("success", false);
                response.put("message", "公告不存在");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "删除公告失败: " + e.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}
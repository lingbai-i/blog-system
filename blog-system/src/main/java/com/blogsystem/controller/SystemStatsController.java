package com.blogsystem.controller;

import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/system")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class SystemStatsController {

    private final BlogService blogService;
    private final UserService userService;

    // 获取公开的系统统计数据
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getSystemStats() {
        Map<String, Object> stats = new HashMap<>();

        try {
            // 获取已发布博客数量
            long totalPublishedBlogs = blogService.getPublishedBlogsCount();
            stats.put("totalPublishedBlogs", totalPublishedBlogs);

            // 获取注册用户总数
            long totalUsers = userService.getTotalUsersCount();
            stats.put("totalUsers", totalUsers);

            // 获取总浏览量
            long totalViews = blogService.getTotalViewsCount();
            stats.put("totalViews", totalViews);

            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            // 如果出错，返回默认值
            stats.put("totalPublishedBlogs", 0);
            stats.put("totalUsers", 0);
            stats.put("totalViews", 0);
            return ResponseEntity.ok(stats);
        }
    }
}
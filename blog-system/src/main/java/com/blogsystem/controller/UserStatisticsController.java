package com.blogsystem.controller;

import com.blogsystem.service.UserStatisticsService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/user-statistics")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class UserStatisticsController {

    private final UserStatisticsService userStatisticsService;

    /**
     * 获取用户发布文章统计
     */
    @GetMapping("/publish/{authorName}")
    public ResponseEntity<Map<String, Object>> getUserPublishStatistics(@PathVariable String authorName) {
        try {
            Map<String, Object> statistics = userStatisticsService.getUserPublishStatistics(authorName);
            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 获取用户文章热度统计
     */
    @GetMapping("/popularity/{authorName}")
    public ResponseEntity<Map<String, Object>> getUserPopularityStatistics(@PathVariable String authorName) {
        try {
            Map<String, Object> statistics = userStatisticsService.getUserPopularityStatistics(authorName);
            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 获取用户点赞统计
     */
    @GetMapping("/likes/{userId}")
    public ResponseEntity<Map<String, Object>> getUserLikeStatistics(@PathVariable Long userId) {
        try {
            Map<String, Object> statistics = userStatisticsService.getUserLikeStatistics(userId);
            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 获取用户点赞的文章列表
     */
    @GetMapping("/liked-articles/{userId}")
    public ResponseEntity<Page<Map<String, Object>>> getUserLikedArticles(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<Map<String, Object>> likedArticles = userStatisticsService.getUserLikedArticles(userId, page, size);
            return ResponseEntity.ok(likedArticles);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 获取用户综合统计数据
     */
    @GetMapping("/comprehensive")
    public ResponseEntity<Map<String, Object>> getUserComprehensiveStatistics(
            @RequestParam Long userId,
            @RequestParam String authorName) {
        try {
            Map<String, Object> statistics = userStatisticsService.getUserComprehensiveStatistics(userId, authorName);
            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * 获取当前用户的综合统计数据（从请求头获取用户信息）
     */
    @GetMapping("/my-stats")
    public ResponseEntity<Map<String, Object>> getMyStatistics(
            @RequestHeader(value = "User-Id", required = false) Long userId,
            @RequestHeader(value = "Username", required = false) String username) {
        try {
            if (userId == null || username == null) {
                return ResponseEntity.badRequest().build();
            }
            Map<String, Object> statistics = userStatisticsService.getUserComprehensiveStatistics(userId, username);
            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
package com.blogsystem.service;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.UserLike;
import com.blogsystem.entity.TargetType;
import com.blogsystem.enums.ArticleStatus;
import com.blogsystem.repository.BlogRepository;
import com.blogsystem.repository.UserLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserStatisticsService {

    private final BlogRepository blogRepository;
    private final UserLikeRepository userLikeRepository;

    /**
     * 获取用户发布文章统计
     */
    public Map<String, Object> getUserPublishStatistics(String username) {
        Map<String, Object> result = new HashMap<>();
        
        // 总发布文章数
        long totalPublished = blogRepository.countByUserUsernameAndStatus(username, ArticleStatus.PUBLISHED);
        result.put("totalPublished", totalPublished);
        
        // 草稿数
        long totalDrafts = blogRepository.countByUserUsernameAndStatus(username, ArticleStatus.DRAFT);
        result.put("totalDrafts", totalDrafts);
        
        // 总文章数
        result.put("totalArticles", totalPublished + totalDrafts);
        
        // 本月发布文章数量
        LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
        LocalDateTime endOfMonth = startOfMonth.plusMonths(1).minusNanos(1);
        long thisMonthCount = blogRepository.countByUserUsernameAndStatusAndCreatedAtBetween(username, ArticleStatus.PUBLISHED, startOfMonth, endOfMonth);
        result.put("thisMonthCount", thisMonthCount);
        
        // 按月份统计发布文章数量（最近12个月）
        LocalDateTime startDate = LocalDateTime.now().minusMonths(12);
        List<Object[]> monthlyStats = blogRepository.findMonthlyPublishStatsByUser(username, ArticleStatus.PUBLISHED, startDate);
        List<Map<String, Object>> monthlyData = monthlyStats.stream()
            .map(row -> {
                Map<String, Object> monthData = new HashMap<>();
                Integer year = (Integer) row[0];
                Integer month = (Integer) row[1];
                String monthStr = String.format("%d-%02d", year, month);
                monthData.put("month", monthStr);
                monthData.put("count", row[2]);
                return monthData;
            })
            .collect(Collectors.toList());
        result.put("monthlyStats", monthlyData);
        
        // 按分类统计
        List<Object[]> categoryStats = blogRepository.findCategoryStatsByUser(username, ArticleStatus.PUBLISHED);
        List<Map<String, Object>> categoryData = categoryStats.stream()
            .map(row -> {
                Map<String, Object> catData = new HashMap<>();
                catData.put("category", row[0] != null ? row[0] : "未分类");
                catData.put("count", row[1]);
                return catData;
            })
            .collect(Collectors.toList());
        result.put("categoryStats", categoryData);
        
        return result;
    }

    /**
     * 获取用户文章热度统计
     */
    public Map<String, Object> getUserPopularityStatistics(String username) {
        Map<String, Object> result = new HashMap<>();
        
        // 总浏览量
        Long totalViews = blogRepository.sumViewCountByUserUsername(username, ArticleStatus.PUBLISHED);
        result.put("totalViews", totalViews != null ? totalViews : 0);
        
        // 总点赞量
        Long totalLikes = blogRepository.sumLikeCountByUserUsername(username, ArticleStatus.PUBLISHED);
        result.put("totalLikes", totalLikes != null ? totalLikes : 0);
        
        // 平均浏览量
        long publishedCount = blogRepository.countByUserUsernameAndStatus(username, ArticleStatus.PUBLISHED);
        double avgViews = publishedCount > 0 ? (totalViews != null ? totalViews : 0) / (double) publishedCount : 0;
        result.put("avgViews", Math.round(avgViews * 100.0) / 100.0);
        
        // 平均点赞量
        double avgLikes = publishedCount > 0 ? (totalLikes != null ? totalLikes : 0) / (double) publishedCount : 0;
        result.put("avgLikes", Math.round(avgLikes * 100.0) / 100.0);
        
        // 最受欢迎的文章（按浏览量）
        Pageable topViewsPageable = PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "viewCount"));
        Page<Blog> topViewedBlogs = blogRepository.findByUserUsernameAndStatusOrderByViewCountDesc(username, ArticleStatus.PUBLISHED, topViewsPageable);
        List<Map<String, Object>> topViewed = topViewedBlogs.getContent().stream()
            .map(blog -> {
                Map<String, Object> blogData = new HashMap<>();
                blogData.put("id", blog.getId());
                blogData.put("title", blog.getTitle());
                blogData.put("viewCount", blog.getViewCount());
                blogData.put("likeCount", blog.getLikeCount());
                return blogData;
            })
            .collect(Collectors.toList());
        result.put("topViewedArticles", topViewed);
        
        // 最受欢迎的文章（按点赞量）
        Pageable topLikesPageable = PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "likeCount"));
        Page<Blog> topLikedBlogs = blogRepository.findByUserUsernameAndStatusOrderByLikeCountDesc(username, ArticleStatus.PUBLISHED, topLikesPageable);
        List<Map<String, Object>> topLiked = topLikedBlogs.getContent().stream()
            .map(blog -> {
                Map<String, Object> blogData = new HashMap<>();
                blogData.put("id", blog.getId());
                blogData.put("title", blog.getTitle());
                blogData.put("viewCount", blog.getViewCount());
                blogData.put("likeCount", blog.getLikeCount());
                return blogData;
            })
            .collect(Collectors.toList());
        result.put("topLikedArticles", topLiked);
        
        return result;
    }

    /**
     * 获取用户点赞统计
     */
    public Map<String, Object> getUserLikeStatistics(Long userId) {
        Map<String, Object> result = new HashMap<>();
        
        // 用户点赞的文章总数
        long totalLikedArticles = userLikeRepository.countByUserIdAndTargetType(userId, TargetType.ARTICLE);
        result.put("totalLikedArticles", totalLikedArticles);
        
        return result;
    }

    /**
     * 获取用户点赞的文章列表
     */
    public Page<Map<String, Object>> getUserLikedArticles(Long userId, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Long> blogIds = userLikeRepository.findBlogIdsByUserId(userId, pageable);
        
        return blogIds.map(blogId -> {
            Optional<Blog> blogOpt = blogRepository.findById(blogId);
            if (blogOpt.isPresent()) {
                Blog blog = blogOpt.get();
                Map<String, Object> articleData = new HashMap<>();
                articleData.put("id", blog.getId());
                articleData.put("title", blog.getTitle());
                articleData.put("summary", blog.getSummary());
                articleData.put("authorName", blog.getUser() != null ? blog.getUser().getUsername() : "未知作者");
                articleData.put("category", blog.getCategory());
                articleData.put("viewCount", blog.getViewCount());
                articleData.put("likeCount", blog.getLikeCount());
                articleData.put("createdAt", blog.getCreatedAt());
                // 获取点赞时间
                Optional<UserLike> userLike = userLikeRepository.findByUserIdAndTargetTypeAndTargetId(userId, TargetType.ARTICLE, blogId);
                articleData.put("likedAt", userLike.map(UserLike::getCreatedAt).orElse(null));
                return articleData;
            }
            return new HashMap<String, Object>();
        });
    }

    /**
     * 获取用户综合统计数据
     */
    public Map<String, Object> getUserComprehensiveStatistics(Long userId, String username) {
        Map<String, Object> result = new HashMap<>();
        
        // 发布统计
        result.put("publishStats", getUserPublishStatistics(username));
        
        // 热度统计
        result.put("popularityStats", getUserPopularityStatistics(username));
        
        // 点赞统计
        result.put("likeStats", getUserLikeStatistics(userId));
        
        // 最近活动（最近发布的文章）
        Pageable recentPageable = PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<Blog> recentBlogs = blogRepository.findByUserUsernameAndStatus(username, ArticleStatus.PUBLISHED, recentPageable);
        List<Map<String, Object>> recentActivity = recentBlogs.getContent().stream()
            .map(blog -> {
                Map<String, Object> activityData = new HashMap<>();
                activityData.put("id", blog.getId());
                activityData.put("title", blog.getTitle());
                activityData.put("createdAt", blog.getCreatedAt());
                activityData.put("viewCount", blog.getViewCount());
                activityData.put("likeCount", blog.getLikeCount());
                return activityData;
            })
            .collect(Collectors.toList());
        result.put("recentActivity", recentActivity);
        
        return result;
    }
}
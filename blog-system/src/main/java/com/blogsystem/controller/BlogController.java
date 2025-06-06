package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/blogs")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class BlogController {

    private final BlogService blogService;
    private final UserService userService;

    // 获取所有已发布的博客（分页，支持多条件组合搜索）
    @GetMapping
    public ResponseEntity<Page<Blog>> getAllBlogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String tag,
            @RequestParam(defaultValue = "latest") String sort) {
        
        Page<Blog> blogs = blogService.searchBlogsWithFilters(keyword, category, tag, sort, page, size);
        return ResponseEntity.ok(blogs);
    }

    // 根据ID获取博客详情
    @GetMapping("/{id}")
    public ResponseEntity<Blog> getBlogById(@PathVariable Long id) {
        Optional<Blog> blog = blogService.findByIdAndIncrementView(id);
        return blog.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 创建新博客
    @PostMapping
    public ResponseEntity<Blog> createBlog(@RequestBody Blog blog, HttpServletRequest request) {
        try {
            // 从token中获取用户信息
            String token = request.getHeader("Authorization");
            if (token != null && token.startsWith("Bearer ")) {
                token = token.substring(7);
                // 解析token获取用户ID（token格式：token_userId_timestamp）
                try {
                    String[] parts = token.split("_");
                    if (parts.length >= 2) {
                        Long userId = Long.parseLong(parts[1]);
                        Optional<User> userOpt = userService.findById(userId);
                        if (userOpt.isPresent()) {
                            blog.setAuthorName(userOpt.get().getUsername());
                        }
                    }
                } catch (NumberFormatException e) {
                    // token格式错误，忽略
                }
            }
            Blog savedBlog = blogService.createBlog(blog);
            return ResponseEntity.ok(savedBlog);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // 更新博客
    @PutMapping("/{id}")
    public ResponseEntity<Blog> updateBlog(@PathVariable Long id, @RequestBody Blog blog, HttpServletRequest request) {
        Optional<Blog> existingBlog = blogService.findById(id);
        if (existingBlog.isPresent()) {
            try {
                // 从token中获取用户信息
                String token = request.getHeader("Authorization");
                if (token != null && token.startsWith("Bearer ")) {
                    token = token.substring(7);
                    // 解析token获取用户ID（token格式：token_userId_timestamp）
                    try {
                        String[] parts = token.split("_");
                        if (parts.length >= 2) {
                            Long userId = Long.parseLong(parts[1]);
                            Optional<User> userOpt = userService.findById(userId);
                            if (userOpt.isPresent()) {
                                blog.setAuthorName(userOpt.get().getUsername());
                            }
                        }
                    } catch (NumberFormatException e) {
                        // token格式错误，忽略
                    }
                }
                blog.setId(id);
                Blog updatedBlog = blogService.updateBlog(blog);
                return ResponseEntity.ok(updatedBlog);
            } catch (Exception e) {
                return ResponseEntity.badRequest().build();
            }
        }
        return ResponseEntity.notFound().build();
    }

    // 删除博客
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBlog(@PathVariable Long id) {
        Optional<Blog> blog = blogService.findById(id);
        if (blog.isPresent()) {
            blogService.deleteBlog(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    // 搜索博客
    @GetMapping("/search")
    public ResponseEntity<Page<Blog>> searchBlogs(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Blog> blogs = blogService.searchBlogs(keyword, page, size);
        return ResponseEntity.ok(blogs);
    }

    // 根据分类获取博客
    @GetMapping("/category/{category}")
    public ResponseEntity<Page<Blog>> getBlogsByCategory(
            @PathVariable String category,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Blog> blogs = blogService.findBlogsByCategory(category, page, size);
        return ResponseEntity.ok(blogs);
    }

    // 根据标签获取博客
    @GetMapping("/tag/{tag}")
    public ResponseEntity<Page<Blog>> getBlogsByTag(
            @PathVariable String tag,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Blog> blogs = blogService.findBlogsByTag(tag, page, size);
        return ResponseEntity.ok(blogs);
    }

    // 获取热门博客
    @GetMapping("/popular")
    public ResponseEntity<List<Blog>> getPopularBlogs(
            @RequestParam(defaultValue = "5") int limit) {
        List<Blog> blogs = blogService.getPopularBlogs(limit);
        return ResponseEntity.ok(blogs);
    }

    // 获取最新博客
    @GetMapping("/latest")
    public ResponseEntity<List<Blog>> getLatestBlogs(
            @RequestParam(defaultValue = "5") int limit) {
        List<Blog> blogs = blogService.getLatestBlogs(limit);
        return ResponseEntity.ok(blogs);
    }

    // 获取所有分类
    @GetMapping("/categories")
    public ResponseEntity<List<String>> getAllCategories() {
        List<String> categories = blogService.getAllCategories();
        return ResponseEntity.ok(categories);
    }

    // 发布博客
    @PutMapping("/{id}/publish")
    public ResponseEntity<Blog> publishBlog(@PathVariable Long id) {
        Blog blog = blogService.publishBlog(id);
        if (blog != null) {
            return ResponseEntity.ok(blog);
        }
        return ResponseEntity.notFound().build();
    }

    // 取消发布博客
    @PutMapping("/{id}/unpublish")
    public ResponseEntity<Blog> unpublishBlog(@PathVariable Long id) {
        Blog blog = blogService.unpublishBlog(id);
        if (blog != null) {
            return ResponseEntity.ok(blog);
        }
        return ResponseEntity.notFound().build();
    }

    // 点赞博客
    @PostMapping("/{id}/like")
    public ResponseEntity<Blog> likeBlog(@PathVariable Long id) {
        Blog blog = blogService.likeBlog(id);
        if (blog != null) {
            return ResponseEntity.ok(blog);
        }
        return ResponseEntity.notFound().build();
    }

    // 获取当前用户的博客
    @GetMapping("/my")
    public ResponseEntity<List<Blog>> getMyBlogs(HttpServletRequest request) {
        // 从Authorization头中获取token
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            // 解析token获取用户ID（token格式：token_userId_timestamp）
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long currentUserId = Long.parseLong(parts[1]);
                    List<Blog> userBlogs = blogService.findBlogsByUserId(currentUserId);
                    return ResponseEntity.ok(userBlogs);
                }
            } catch (NumberFormatException e) {
                // token格式错误，返回空列表
            }
        }

        // 如果没有有效token，返回空列表
        return ResponseEntity.ok(new ArrayList<>());
    }

    // 获取博客统计信息
    @GetMapping("/stats")
    public ResponseEntity<Object> getBlogStats() {
        long totalBlogs = blogService.getTotalPublishedBlogs();
        return ResponseEntity.ok(new Object() {
            public final long totalPublishedBlogs = totalBlogs;
        });
    }
}
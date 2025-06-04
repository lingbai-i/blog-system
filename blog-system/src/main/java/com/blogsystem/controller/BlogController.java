package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.service.BlogService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/blogs")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class BlogController {

    private final BlogService blogService;

    // 获取所有已发布的博客（分页）
    @GetMapping
    public ResponseEntity<Page<Blog>> getAllBlogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Blog> blogs = blogService.findPublishedBlogs(page, size);
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
    public ResponseEntity<Blog> createBlog(@RequestBody Blog blog) {
        Blog savedBlog = blogService.createBlog(blog);
        return ResponseEntity.ok(savedBlog);
    }

    // 更新博客
    @PutMapping("/{id}")
    public ResponseEntity<Blog> updateBlog(@PathVariable Long id, @RequestBody Blog blog) {
        Optional<Blog> existingBlog = blogService.findById(id);
        if (existingBlog.isPresent()) {
            blog.setId(id);
            Blog updatedBlog = blogService.updateBlog(blog);
            return ResponseEntity.ok(updatedBlog);
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

    // 获取博客统计信息
    @GetMapping("/stats")
    public ResponseEntity<Object> getBlogStats() {
        long totalBlogs = blogService.getTotalPublishedBlogs();
        return ResponseEntity.ok(new Object() {
            public final long totalPublishedBlogs = totalBlogs;
        });
    }
}
package com.blogsystem.controller;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.dto.BlogDTO;
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
    public ResponseEntity<Page<BlogDTO>> getAllBlogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String tag,
            @RequestParam(defaultValue = "publishTime") String sort) {

        Page<Blog> blogs = blogService.searchBlogsWithFilters(keyword, category, tag, sort, page, size);

        // 将Page<Blog>转换为Page<BlogDTO>，包含作者头像信息
        Page<BlogDTO> blogDTOs = blogs.map(blog -> {
            User author = null;
            if (blog.getUser() != null) {
                author = blog.getUser();
            }
            return BlogDTO.fromEntity(blog, author);
        });

        return ResponseEntity.ok(blogDTOs);
    }

    // 根据ID获取博客详情
    @GetMapping("/{id}")
    public ResponseEntity<BlogDTO> getBlogById(@PathVariable Long id) {
        Optional<Blog> blogOpt = blogService.findByIdAndIncrementView(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            // 根据作者关联获取作者信息
            User author = blog.getUser();
            BlogDTO blogDTO = BlogDTO.fromEntity(blog, author);
            return ResponseEntity.ok(blogDTO);
        }
        return ResponseEntity.notFound().build();
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
                            blog.setUser(userOpt.get());
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
        Optional<Blog> existingBlogOpt = blogService.findById(id);
        if (!existingBlogOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        Blog existingBlog = existingBlogOpt.get();

        // 验证权限：只有文章作者或管理员可以更新
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build(); // 未授权
        }

        token = token.substring(7);
        try {
            // 解析token获取用户信息
            String[] parts = token.split("_");
            if (parts.length >= 2) {
                Long userId = Long.parseLong(parts[1]);
                Optional<User> userOpt = userService.findById(userId);

                if (userOpt.isPresent()) {
                    User currentUser = userOpt.get();
                    String currentUsername = currentUser.getUsername();
                    String userRole = currentUser.getIsAdmin() ? "admin" : "user";

                    // 检查权限：管理员或文章作者可以更新
                    if ("admin".equals(userRole) || (existingBlog.getUser() != null && currentUsername.equals(existingBlog.getUser().getUsername()))) {
                        // 设置作者信息
                        blog.setUser(currentUser);
                        blog.setId(id);
                        Blog updatedBlog = blogService.updateBlog(blog);
                        return ResponseEntity.ok(updatedBlog);
                    } else {
                        return ResponseEntity.status(403).build(); // 禁止访问
                    }
                } else {
                    return ResponseEntity.status(401).build(); // 用户不存在
                }
            } else {
                return ResponseEntity.status(401).build(); // token格式错误
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.status(401).build(); // token解析错误
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // 删除博客
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBlog(@PathVariable Long id, HttpServletRequest request) {
        Optional<Blog> blogOpt = blogService.findById(id);
        if (!blogOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        Blog blog = blogOpt.get();

        // 验证权限：只有文章作者或管理员可以删除
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build(); // 未授权
        }

        token = token.substring(7);
        try {
            // 解析token获取用户信息
            String[] parts = token.split("_");
            if (parts.length >= 2) {
                Long userId = Long.parseLong(parts[1]);
                Optional<User> userOpt = userService.findById(userId);

                if (userOpt.isPresent()) {
                    User deleteUser = userOpt.get();
                    String currentUsername = deleteUser.getUsername();
                    String userRole = deleteUser.getIsAdmin() ? "admin" : "user";

                    // 检查权限：管理员或文章作者可以删除
                    if ("admin".equals(userRole) || (blog.getUser() != null && currentUsername.equals(blog.getUser().getUsername()))) {
                        blogService.deleteBlog(id);
                        return ResponseEntity.ok().build();
                    } else {
                        return ResponseEntity.status(403).build(); // 禁止访问
                    }
                } else {
                    return ResponseEntity.status(401).build(); // 用户不存在
                }
            } else {
                return ResponseEntity.status(401).build(); // token格式错误
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.status(401).build(); // token解析错误
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
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
    public ResponseEntity<List<BlogDTO>> getLatestBlogs(
            @RequestParam(defaultValue = "5") int limit) {
        List<Blog> blogs = blogService.getLatestBlogs(limit);

        // 将List<Blog>转换为List<BlogDTO>，包含作者头像信息
        List<BlogDTO> blogDTOs = new ArrayList<>();
        for (Blog blog : blogs) {
            User author = blog.getUser(); // 直接使用关联的用户
            blogDTOs.add(BlogDTO.fromEntity(blog, author));
        }

        return ResponseEntity.ok(blogDTOs);
    }

    // 获取所有分类
    @GetMapping("/categories")
    public ResponseEntity<List<String>> getAllCategories() {
        List<String> categories = blogService.getAllCategories();
        return ResponseEntity.ok(categories);
    }

    // 发布博客
    @PutMapping("/{id}/publish")
    public ResponseEntity<Blog> publishBlog(@PathVariable Long id, HttpServletRequest request) {
        Optional<Blog> blogOpt = blogService.findById(id);
        if (!blogOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        Blog existingBlog = blogOpt.get();

        // 验证权限：只有文章作者或管理员可以发布
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build(); // 未授权
        }

        token = token.substring(7);
        try {
            // 解析token获取用户信息
            String[] parts = token.split("_");
            if (parts.length >= 2) {
                Long userId = Long.parseLong(parts[1]);
                Optional<User> userOpt = userService.findById(userId);

                if (userOpt.isPresent()) {
                    User publishUser = userOpt.get();
                    String currentUsername = publishUser.getUsername();
                    String userRole = publishUser.getIsAdmin() ? "admin" : "user";

                    // 检查权限：管理员或文章作者可以发布
                    if ("admin".equals(userRole) || (existingBlog.getUser() != null && currentUsername.equals(existingBlog.getUser().getUsername()))) {
                        Blog blog = blogService.publishBlog(id);
                        if (blog != null) {
                            return ResponseEntity.ok(blog);
                        }
                        return ResponseEntity.notFound().build();
                    } else {
                        return ResponseEntity.status(403).build(); // 禁止访问
                    }
                } else {
                    return ResponseEntity.status(401).build(); // 用户不存在
                }
            } else {
                return ResponseEntity.status(401).build(); // token格式错误
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.status(401).build(); // token解析错误
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // 取消发布博客
    @PutMapping("/{id}/unpublish")
    public ResponseEntity<Blog> unpublishBlog(@PathVariable Long id, HttpServletRequest request) {
        Optional<Blog> blogOpt = blogService.findById(id);
        if (!blogOpt.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        Blog existingBlog = blogOpt.get();

        // 验证权限：只有文章作者或管理员可以取消发布
        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            return ResponseEntity.status(401).build(); // 未授权
        }

        token = token.substring(7);
        try {
            // 解析token获取用户信息
            String[] parts = token.split("_");
            if (parts.length >= 2) {
                Long userId = Long.parseLong(parts[1]);
                Optional<User> userOpt = userService.findById(userId);

                if (userOpt.isPresent()) {
                    User unpublishUser = userOpt.get();
                    String currentUsername = unpublishUser.getUsername();
                    String userRole = unpublishUser.getIsAdmin() ? "admin" : "user";

                    // 检查权限：管理员或文章作者可以取消发布
                    if ("admin".equals(userRole) || (existingBlog.getUser() != null && currentUsername.equals(existingBlog.getUser().getUsername()))) {
                        Blog blog = blogService.unpublishBlog(id);
                        if (blog != null) {
                            return ResponseEntity.ok(blog);
                        }
                        return ResponseEntity.notFound().build();
                    } else {
                        return ResponseEntity.status(403).build(); // 禁止访问
                    }
                } else {
                    return ResponseEntity.status(401).build(); // 用户不存在
                }
            } else {
                return ResponseEntity.status(401).build(); // token格式错误
            }
        } catch (NumberFormatException e) {
            return ResponseEntity.status(401).build(); // token解析错误
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // 点赞博客
    @PostMapping("/{id}/like")
    public ResponseEntity<Blog> likeBlog(@PathVariable Long id, HttpServletRequest request) {
        // 从Authorization头中获取token
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            // 解析token获取用户ID（token格式：token_userId_timestamp）
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    Blog blog = blogService.likeBlog(id, userId);
                    if (blog != null) {
                        return ResponseEntity.ok(blog);
                    }
                }
            } catch (NumberFormatException e) {
                return ResponseEntity.badRequest().build();
            }
        }
        return ResponseEntity.notFound().build();
    }

    // 取消点赞博客
    @DeleteMapping("/{id}/like")
    public ResponseEntity<Blog> unlikeBlog(@PathVariable Long id, HttpServletRequest request) {
        // 从Authorization头中获取token
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            // 解析token获取用户ID（token格式：token_userId_timestamp）
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    Blog blog = blogService.unlikeBlog(id, userId);
                    if (blog != null) {
                        return ResponseEntity.ok(blog);
                    }
                }
            } catch (NumberFormatException e) {
                return ResponseEntity.badRequest().build();
            }
        }
        return ResponseEntity.notFound().build();
    }

    // 获取用户对博客的点赞状态
    @GetMapping("/{id}/like-status")
    public ResponseEntity<Object> getLikeStatus(@PathVariable Long id, HttpServletRequest request) {
        // 从Authorization头中获取token
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            // 解析token获取用户ID（token格式：token_userId_timestamp）
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    boolean hasLiked = blogService.hasUserLikedBlog(id, userId);
                    return ResponseEntity.ok(new Object() {
                        public final boolean liked = hasLiked;
                    });
                }
            } catch (NumberFormatException e) {
                return ResponseEntity.badRequest().build();
            }
        }
        return ResponseEntity.ok(new Object() {
            public final boolean liked = false;
        });
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
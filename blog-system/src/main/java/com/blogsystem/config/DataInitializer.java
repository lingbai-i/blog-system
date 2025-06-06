package com.blogsystem.config;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.entity.Comment;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;
import com.blogsystem.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserService userService;
    private final BlogService blogService;
    private final CommentService commentService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 检查是否已有数据，避免重复初始化
        if (userService.getAllUsers().isEmpty()) {
            initializeData();
        }
    }

    private void initializeData() {
        // 创建管理员用户
        User admin = new User();
        admin.setAccount("admin"); // 确保方法名正确
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setUsername("Admin User");
        admin.setEmail("admin@example.com");
        admin.setIsAdmin(true);
        admin = userService.createUser(admin);

        // 创建普通用户
        User user1 = new User();
        user1.setAccount("blogger");
        user1.setUsername("blogger");
        user1.setEmail("blogger@blog.com");
        user1.setPassword("blogger123");
        user1.setFullName("博客作者");
        user1.setBio("热爱写作的程序员");
        user1.setIsAdmin(false);
        user1 = userService.createUser(user1);

        User user2 = new User();
        user2.setAccount("reader");
        user2.setUsername("reader");
        user2.setEmail("reader@blog.com");
        user2.setPassword("reader123");
        user2.setFullName("博客读者");
        user2.setBio("喜欢阅读技术文章");
        user2.setIsAdmin(false);
        user2 = userService.createUser(user2);

        // 创建示例博客文章
        Blog blog1 = new Blog();
        blog1.setTitle("Spring Boot 入门指南");
        blog1.setContent("Spring Boot 是一个基于 Spring 框架的快速开发框架，它简化了 Spring 应用的配置和部署。\n\n" +
                "## 主要特性\n\n" +
                "1. **自动配置**: Spring Boot 可以根据类路径中的依赖自动配置应用\n" +
                "2. **起步依赖**: 提供了一系列的起步依赖，简化了依赖管理\n" +
                "3. **内嵌服务器**: 内置了 Tomcat、Jetty 等服务器\n" +
                "4. **生产就绪**: 提供了健康检查、指标监控等生产环境功能\n\n" +
                "## 快速开始\n\n" +
                "创建一个简单的 Spring Boot 应用非常简单，只需要几个步骤就可以完成。");
        blog1.setSummary("Spring Boot 是一个强大的 Java 开发框架，本文介绍了其主要特性和快速开始方法。");
        blog1.setAuthorName("博客作者");
        blog1.setCategory("技术教程");
        blog1.setTags("Spring Boot,Java,后端开发");
        blog1.setIsPublished(true);
        blog1.setViewCount(156);
        blog1.setLikeCount(23);
        blog1 = blogService.createBlog(blog1);

        Blog blog2 = new Blog();
        blog2.setTitle("MySQL 数据库优化技巧");
        blog2.setContent("数据库优化是提高应用性能的重要手段，本文将介绍一些常用的 MySQL 优化技巧。\n\n" +
                "## 索引优化\n\n" +
                "1. **选择合适的索引类型**: 根据查询需求选择 B-Tree、Hash 等索引类型\n" +
                "2. **避免过多索引**: 索引会影响写入性能，需要权衡\n" +
                "3. **复合索引**: 对于多字段查询，使用复合索引可以提高效率\n\n" +
                "## 查询优化\n\n" +
                "1. **避免 SELECT ***: 只查询需要的字段\n" +
                "2. **使用 LIMIT**: 对于大结果集，使用分页查询\n" +
                "3. **优化 WHERE 条件**: 将选择性高的条件放在前面");
        blog2.setSummary("介绍 MySQL 数据库的各种优化技巧，包括索引优化、查询优化等方面。");
        blog2.setAuthorName("博客作者");
        blog2.setCategory("数据库");
        blog2.setTags("MySQL,数据库,性能优化");
        blog2.setIsPublished(true);
        blog2.setViewCount(89);
        blog2.setLikeCount(15);
        blog2 = blogService.createBlog(blog2);

        Blog blog3 = new Blog();
        blog3.setTitle("前端开发趋势分析");
        blog3.setContent("前端技术发展迅速，本文分析当前前端开发的主要趋势和技术方向。\n\n" +
                "## 主要趋势\n\n" +
                "1. **组件化开发**: React、Vue、Angular 等框架的普及\n" +
                "2. **TypeScript**: 静态类型检查提高代码质量\n" +
                "3. **微前端**: 大型应用的模块化解决方案\n" +
                "4. **Serverless**: 无服务器架构的兴起\n\n" +
                "## 技术选型\n\n" +
                "选择合适的技术栈对项目成功至关重要，需要考虑团队技能、项目需求等因素。");
        blog3.setSummary("分析当前前端开发的主要趋势，包括组件化、TypeScript、微前端等技术方向。");
        blog3.setAuthorName("博客作者");
        blog3.setCategory("前端开发");
        blog3.setTags("前端,React,Vue,TypeScript");
        blog3.setIsPublished(true);
        blog3.setViewCount(234);
        blog3.setLikeCount(31);
        blog3 = blogService.createBlog(blog3);

        // 创建示例评论
        Comment comment1 = new Comment();
        comment1.setBlog(blog1);
        comment1.setUser(user2);
        comment1.setAuthorName("博客读者");
        comment1.setAuthorEmail("reader@blog.com");
        comment1.setContent("这篇文章写得很好，对 Spring Boot 的介绍很全面，特别是自动配置的部分讲解得很清楚。");
        comment1.setIsApproved(true);
        comment1 = commentService.createComment(comment1);

        Comment comment2 = new Comment();
        comment2.setBlog(blog1);
        comment2.setAuthorName("匿名用户");
        comment2.setAuthorEmail("anonymous@example.com");
        comment2.setContent("能否提供一些实际的代码示例？这样更容易理解。");
        comment2.setIsApproved(true);
        commentService.createComment(comment2);

        // 创建回复评论
        Comment reply1 = new Comment();
        reply1.setBlog(blog1);
        reply1.setUser(user1);
        reply1.setParent(comment2);
        reply1.setAuthorName("博客作者");
        reply1.setAuthorEmail("blogger@blog.com");
        reply1.setContent("感谢建议！我会在后续文章中添加更多代码示例。");
        reply1.setIsApproved(true);
        commentService.createComment(reply1);

        Comment comment3 = new Comment();
        comment3.setBlog(blog2);
        comment3.setUser(user2);
        comment3.setAuthorName("博客读者");
        comment3.setAuthorEmail("reader@blog.com");
        comment3.setContent("数据库优化确实很重要，特别是在高并发场景下。文章提到的索引优化技巧很实用。");
        comment3.setIsApproved(true);
        commentService.createComment(comment3);

        System.out.println("示例数据初始化完成！");
        System.out.println("管理员账号: admin / admin123");
        System.out.println("普通用户账号: blogger / blogger123");
        System.out.println("访问地址: http://localhost:8080");
    }
}
package com.blogsystem.config;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.entity.Comment;
import com.blogsystem.entity.Tag;
import com.blogsystem.entity.Category;
import com.blogsystem.service.BlogService;
import com.blogsystem.service.UserService;
import com.blogsystem.service.CommentService;
import com.blogsystem.service.TagService;
import com.blogsystem.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;

import java.time.LocalDateTime;

// @Component
@RequiredArgsConstructor
public class DataInitializer {

    private final UserService userService;
    private final BlogService blogService;
    private final CommentService commentService;
    private final TagService tagService;
    private final CategoryService categoryService;
    private final PasswordEncoder passwordEncoder;

    // @EventListener(ApplicationReadyEvent.class)
    // @Async
    // public void initializeData() {
    //     try {
    //         System.out.println("DataInitializer 已启动，开始简化的数据初始化...");
    //         // 简化的数据初始化，只创建基础标签和分类
    //         initializeBasicData();
    //         System.out.println("基础数据初始化完成！");
    //     } catch (Exception e) {
    //         System.err.println("数据初始化过程中发生错误: " + e.getMessage());
    //         e.printStackTrace();
    //         // 不抛出异常，避免应用启动失败
    //     }
    // }

    // private void initializeBasicData() {
    //     // 只创建基础标签和分类，避免复杂的用户创建逻辑
    //     System.out.println("开始创建基础标签...");

    //     // 创建基础标签
    //     createTagIfNotExists("Java", "Java编程语言相关内容", true);
    //     createTagIfNotExists("Spring Boot", "Spring Boot框架相关内容", true);
    //     createTagIfNotExists("前端开发", "前端开发技术相关内容", true);
    //     createTagIfNotExists("数据库", "数据库相关技术内容", true);
    //     createTagIfNotExists("算法", "算法和数据结构相关内容", true);
        
    //     // 创建一些禁用状态的标签用于测试筛选功能
    //     createTagIfNotExists("CSS", "CSS样式相关内容", false);
    //     createTagIfNotExists("JavaScript", "JavaScript编程相关内容", false);
    //     createTagIfNotExists("HTML", "HTML标记语言相关内容", false);
    //     createTagIfNotExists("React", "React框架相关内容", false);
    //     createTagIfNotExists("Vue.js", "Vue.js框架相关内容", false);

    //     System.out.println("开始创建基础分类...");

    //     // 创建基础分类
    //     createCategoryIfNotExists("技术分享", "技术相关的文章分类");
    //     createCategoryIfNotExists("学习笔记", "学习过程中的笔记和总结");
    //     createCategoryIfNotExists("项目实战", "实际项目开发经验分享");

    //     System.out.println("基础标签和分类创建完成！");
    // }

    // private void createTagIfNotExists(String name, String description, Boolean isActive) {
    //     try {
    //         if (!tagService.findByName(name).isPresent()) {
    //             Tag tag = new Tag();
    //             tag.setName(name);
    //             tag.setSlug(name.toLowerCase().replace(" ", "-"));
    //             tag.setDescription(description);
    //             tag.setIsActive(isActive);
    //             tagService.createTag(tag);
    //             System.out.println("创建标签: " + name + " (状态: " + (isActive ? "激活" : "禁用") + ")");
    //         } else {
    //             System.out.println("标签已存在: " + name);
    //         }
    //     } catch (Exception e) {
    //         System.err.println("创建标签时出错: " + e.getMessage());
    //     }
    // }

    // private void createCategoryIfNotExists(String name, String description) {
    //     try {
    //         if (!categoryService.findByName(name).isPresent()) {
    //             Category category = new Category();
    //             category.setName(name);
    //             category.setSlug(name.toLowerCase().replace(" ", "-"));
    //             category.setDescription(description);
    //             categoryService.createCategory(category);
    //             System.out.println("创建分类: " + name);
    //         } else {
    //             System.out.println("分类已存在: " + name);
    //         }
    //     } catch (Exception e) {
    //         System.err.println("创建分类时出错: " + e.getMessage());
    //     }
    // }
}
package com.blogsystem.controller;

import com.blogsystem.entity.Category;
import com.blogsystem.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
@CrossOrigin(origins = { "http://localhost:3000", "http://127.0.0.1:3000" }, allowCredentials = "true")
public class CategoryController {

    private final CategoryService categoryService;

    // 创建分类
    @PostMapping
    public ResponseEntity<?> createCategory(@Valid @RequestBody Category category) {
        try {
            Category createdCategory = categoryService.createCategory(category);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdCategory);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 更新分类
    @PutMapping("/{id}")
    public ResponseEntity<?> updateCategory(@PathVariable Long id, @Valid @RequestBody Category categoryDetails) {
        try {
            Category updatedCategory = categoryService.updateCategory(id, categoryDetails);
            return ResponseEntity.ok(updatedCategory);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 根据ID获取分类
    @GetMapping("/{id}")
    public ResponseEntity<?> getCategoryById(@PathVariable Long id) {
        Optional<Category> category = categoryService.findById(id);
        if (category.isPresent()) {
            return ResponseEntity.ok(category.get());
        } else {
            Map<String, String> error = new HashMap<>();
            error.put("error", "分类不存在，ID: " + id);
            return ResponseEntity.notFound().build();
        }
    }

    // 获取所有激活的分类
    @GetMapping("/active")
    public ResponseEntity<List<Category>> getAllActiveCategories() {
        List<Category> categories = categoryService.getAllActiveCategories();
        return ResponseEntity.ok(categories);
    }

    // 获取所有分类（默认返回激活的分类列表）
    @GetMapping
    public ResponseEntity<List<Category>> getAllCategories(
            @RequestParam(required = false) Boolean paginated) {
        if (paginated != null && paginated) {
            // 如果明确要求分页，则重定向到分页接口
            return ResponseEntity.status(302).header("Location", "/api/categories/paged").build();
        }
        // 默认返回所有激活的分类
        List<Category> categories = categoryService.getAllActiveCategories();
        return ResponseEntity.ok(categories);
    }

    // 分页获取所有分类
    @GetMapping("/paged")
    public ResponseEntity<Page<Category>> getAllCategoriesPaged(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Category> categories = categoryService.getAllCategories(page, size);
        return ResponseEntity.ok(categories);
    }

    // 根据激活状态分页获取分类
    @GetMapping("/status/{isActive}")
    public ResponseEntity<Page<Category>> getCategoriesByStatus(
            @PathVariable Boolean isActive,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Category> categories = categoryService.getCategoriesByStatus(isActive, page, size);
        return ResponseEntity.ok(categories);
    }

    // 搜索分类
    @GetMapping("/search")
    public ResponseEntity<Page<Category>> searchCategories(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Page<Category> categories = categoryService.searchCategories(keyword, page, size);
        return ResponseEntity.ok(categories);
    }

    // 删除分类
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable Long id) {
        try {
            categoryService.deleteCategory(id);
            Map<String, String> response = new HashMap<>();
            response.put("message", "分类删除成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 启用/禁用分类
    @PatchMapping("/{id}/toggle-status")
    public ResponseEntity<?> toggleCategoryStatus(@PathVariable Long id) {
        try {
            Category category = categoryService.toggleCategoryStatus(id);
            return ResponseEntity.ok(category);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 获取分类统计信息
    @GetMapping("/stats")
    public ResponseEntity<List<Category>> getCategoriesWithBlogCount() {
        List<Category> categories = categoryService.getCategoriesWithBlogCount();
        return ResponseEntity.ok(categories);
    }

    // 获取有博客的分类
    @GetMapping("/with-blogs")
    public ResponseEntity<List<Category>> getCategoriesWithPublishedBlogs() {
        List<Category> categories = categoryService.getCategoriesWithPublishedBlogs();
        return ResponseEntity.ok(categories);
    }

    // 获取分类统计数据
    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getCategoryDashboard() {
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("totalCategories", categoryService.getAllActiveCategories().size());
        dashboard.put("activeCategories", categoryService.countActiveCategories());
        dashboard.put("categoriesWithBlogs", categoryService.getCategoriesWithPublishedBlogs().size());
        dashboard.put("categoriesStats", categoryService.getCategoriesWithBlogCount());
        return ResponseEntity.ok(dashboard);
    }
}
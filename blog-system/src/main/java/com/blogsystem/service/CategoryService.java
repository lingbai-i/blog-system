package com.blogsystem.service;

import com.blogsystem.entity.Category;
import com.blogsystem.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {

    private final CategoryRepository categoryRepository;

    // 创建分类
    public Category createCategory(Category category) {
        // 检查分类名称是否已存在
        if (categoryRepository.findByName(category.getName()).isPresent()) {
            throw new RuntimeException("分类名称已存在: " + category.getName());
        }
        return categoryRepository.save(category);
    }

    // 更新分类
    public Category updateCategory(Long id, Category categoryDetails) {
        Optional<Category> categoryOpt = categoryRepository.findById(id);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();

            // 检查新名称是否与其他分类冲突
            Optional<Category> existingCategory = categoryRepository.findByName(categoryDetails.getName());
            if (existingCategory.isPresent() && !existingCategory.get().getId().equals(id)) {
                throw new RuntimeException("分类名称已存在: " + categoryDetails.getName());
            }

            category.setName(categoryDetails.getName());
            category.setDescription(categoryDetails.getDescription());
            category.setColorCode(categoryDetails.getColorCode());
            category.setIsActive(categoryDetails.getIsActive());

            return categoryRepository.save(category);
        }
        throw new RuntimeException("分类不存在，ID: " + id);
    }

    // 根据ID查找分类
    public Optional<Category> findById(Long id) {
        return categoryRepository.findById(id);
    }

    // 根据名称查找分类
    public Optional<Category> findByName(String name) {
        return categoryRepository.findByName(name);
    }

    // 获取所有激活的分类
    public List<Category> getAllActiveCategories() {
        return categoryRepository.findByIsActiveTrueOrderByNameAsc();
    }

    // 分页获取所有分类
    public Page<Category> getAllCategories(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return categoryRepository.findAllByOrderByCreatedAtDesc(pageable);
    }

    // 根据激活状态分页获取分类
    public Page<Category> getCategoriesByStatus(Boolean isActive, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return categoryRepository.findByIsActiveOrderByCreatedAtDesc(isActive, pageable);
    }

    // 搜索分类
    public Page<Category> searchCategories(String keyword, Boolean isActive, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        if (isActive != null) {
            // 如果指定了状态，按关键词和状态搜索
            return categoryRepository.findByNameContainingIgnoreCaseAndIsActiveOrderByNameAsc(keyword, isActive, pageable);
        } else {
            // 如果没有指定状态，只按关键词搜索
            return categoryRepository.findByNameContainingIgnoreCaseOrderByNameAsc(keyword, pageable);
        }
    }

    // 删除分类
    public void deleteCategory(Long id) {
        Optional<Category> categoryOpt = categoryRepository.findById(id);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            // 检查是否有关联的博客
            if (category.getBlogs() != null && !category.getBlogs().isEmpty()) {
                throw new RuntimeException("无法删除分类，存在关联的博客");
            }
            categoryRepository.deleteById(id);
        } else {
            throw new RuntimeException("分类不存在，ID: " + id);
        }
    }

    // 启用/禁用分类
    public Category toggleCategoryStatus(Long id) {
        Optional<Category> categoryOpt = categoryRepository.findById(id);
        if (categoryOpt.isPresent()) {
            Category category = categoryOpt.get();
            category.setIsActive(!category.getIsActive());
            return categoryRepository.save(category);
        }
        throw new RuntimeException("分类不存在，ID: " + id);
    }

    // 获取分类统计信息
    public List<Category> getCategoriesWithBlogCount() {
        List<Object[]> results = categoryRepository.findCategoriesWithBlogCount();
        return results.stream().map(result -> {
            Category category = (Category) result[0];
            Long blogCount = (Long) result[1];
            category.setBlogCount(blogCount);
            return category;
        }).collect(Collectors.toList());
    }

    // 获取有博客的分类
    public List<Category> getCategoriesWithPublishedBlogs() {
        return categoryRepository.findCategoriesWithPublishedBlogs();
    }

    // 统计激活的分类数量
    public long countActiveCategories() {
        return categoryRepository.countByIsActiveTrue();
    }
}
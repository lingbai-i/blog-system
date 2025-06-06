package com.blogsystem.repository;

import com.blogsystem.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    // 根据名称查找分类
    Optional<Category> findByName(String name);

    // 查找所有激活的分类
    List<Category> findByIsActiveTrueOrderByNameAsc();

    // 分页查找所有分类
    Page<Category> findAllByOrderByCreatedAtDesc(Pageable pageable);

    // 根据激活状态分页查找
    Page<Category> findByIsActiveOrderByCreatedAtDesc(Boolean isActive, Pageable pageable);

    // 根据名称模糊搜索
    Page<Category> findByNameContainingIgnoreCaseOrderByNameAsc(String name, Pageable pageable);
    
    // 根据名称模糊搜索并按状态筛选
    Page<Category> findByNameContainingIgnoreCaseAndIsActiveOrderByNameAsc(String name, Boolean isActive, Pageable pageable);

    // 统计激活的分类数量
    long countByIsActiveTrue();

    // 查询分类及其博客数量
    @Query("SELECT c, COUNT(b) as blogCount FROM Category c LEFT JOIN c.blogs b WHERE c.isActive = true GROUP BY c ORDER BY c.name ASC")
    List<Object[]> findCategoriesWithBlogCount();

    // 查询有博客的分类
    @Query("SELECT DISTINCT c FROM Category c JOIN c.blogs b WHERE c.isActive = true AND b.isPublished = true ORDER BY c.name ASC")
    List<Category> findCategoriesWithPublishedBlogs();
}
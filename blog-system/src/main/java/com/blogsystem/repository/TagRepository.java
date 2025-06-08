package com.blogsystem.repository;

import com.blogsystem.entity.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {

    // 根据名称查找标签
    Optional<Tag> findByName(String name);

    // 查找所有激活的标签
    List<Tag> findByIsActiveTrueOrderByNameAsc();

    // 分页查找所有标签
    Page<Tag> findAllByOrderByCreatedAtDesc(Pageable pageable);

    // 根据激活状态分页查找
    Page<Tag> findByIsActiveOrderByCreatedAtDesc(Boolean isActive, Pageable pageable);

    // 根据名称模糊搜索
    Page<Tag> findByNameContainingIgnoreCaseOrderByNameAsc(String name, Pageable pageable);

    // 根据名称模糊搜索并按状态筛选
    Page<Tag> findByNameContainingIgnoreCaseAndIsActiveOrderByNameAsc(String name, Boolean isActive, Pageable pageable);

    // 根据名称列表查找标签
    List<Tag> findByNameIn(List<String> names);

    // 统计激活的标签数量
    long countByIsActiveTrue();

    // 查询标签及其博客数量（只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.isActive = true AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY t.name ASC")
    List<Object[]> findTagsWithBlogCount();

    // 查询有博客的标签
    @Query("SELECT DISTINCT t FROM Tag t JOIN t.blogs b WHERE t.isActive = true AND b.isPublished = true ORDER BY t.name ASC")
    List<Tag> findTagsWithPublishedBlogs();

    // 查询热门标签（按博客数量排序）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.isActive = true AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    List<Object[]> findPopularTags(Pageable pageable);

    // 查询所有标签并按博客数量排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    Page<Object[]> findAllTagsWithBlogCountOrderByUsageDesc(Pageable pageable);

    // 查询所有标签并按博客数量升序排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    Page<Object[]> findAllTagsWithBlogCountOrderByUsageAsc(Pageable pageable);

    // 根据状态查询标签并按博客数量排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.isActive = :isActive AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    Page<Object[]> findTagsByStatusWithBlogCountOrderByUsageDesc(Boolean isActive, Pageable pageable);

    // 根据状态查询标签并按博客数量升序排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.isActive = :isActive AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    Page<Object[]> findTagsByStatusWithBlogCountOrderByUsageAsc(Boolean isActive, Pageable pageable);

    // 搜索标签并按博客数量排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE %:keyword% AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    Page<Object[]> findTagsByKeywordWithBlogCountOrderByUsageDesc(String keyword, Pageable pageable);

    // 搜索标签并按博客数量升序排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE %:keyword% AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    Page<Object[]> findTagsByKeywordWithBlogCountOrderByUsageAsc(String keyword, Pageable pageable);

    // 根据关键词和状态搜索标签并按博客数量排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE %:keyword% AND t.isActive = :isActive AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    Page<Object[]> findTagsByKeywordAndStatusWithBlogCountOrderByUsageDesc(String keyword, Boolean isActive,
            Pageable pageable);

    // 根据关键词和状态搜索标签并按博客数量升序排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE %:keyword% AND t.isActive = :isActive AND (b IS NULL OR b.isPublished = true) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    Page<Object[]> findTagsByKeywordAndStatusWithBlogCountOrderByUsageAsc(String keyword, Boolean isActive,
            Pageable pageable);
}
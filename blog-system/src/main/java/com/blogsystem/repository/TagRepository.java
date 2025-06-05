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

    // 根据名称列表查找标签
    List<Tag> findByNameIn(List<String> names);

    // 统计激活的标签数量
    long countByIsActiveTrue();

    // 查询标签及其博客数量
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.isActive = true GROUP BY t ORDER BY t.name ASC")
    List<Object[]> findTagsWithBlogCount();

    // 查询有博客的标签
    @Query("SELECT DISTINCT t FROM Tag t JOIN t.blogs b WHERE t.isActive = true AND b.isPublished = true ORDER BY t.name ASC")
    List<Tag> findTagsWithPublishedBlogs();

    // 查询热门标签（按博客数量排序）
    @Query("SELECT t FROM Tag t JOIN t.blogs b WHERE t.isActive = true AND b.isPublished = true GROUP BY t ORDER BY COUNT(b) DESC")
    List<Tag> findPopularTags(Pageable pageable);
}
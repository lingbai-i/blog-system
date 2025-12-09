package com.blogsystem.repository;

import com.blogsystem.entity.Tag;
import com.blogsystem.enums.ArticleStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TagRepository extends JpaRepository<Tag, Long> {

    // 根据名称查找标签
    Optional<Tag> findByName(String name);

    // 分页查找所有标签
    Page<Tag> findAllByOrderByCreatedAtDesc(Pageable pageable);

    // 根据名称模糊搜索
    Page<Tag> findByNameContainingIgnoreCaseOrderByNameAsc(String name, Pageable pageable);

    // 根据名称列表查找标签
    List<Tag> findByNameIn(List<String> names);

    // 查询标签及其博客数量（只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.status = :status) GROUP BY t ORDER BY t.name ASC")
    List<Object[]> findTagsWithBlogCount(@Param("status") ArticleStatus status);

    // 查询有博客的标签
    @Query("SELECT DISTINCT t FROM Tag t JOIN t.blogs b WHERE b.status = :status ORDER BY t.name ASC")
    List<Tag> findTagsWithPublishedBlogs(@Param("status") ArticleStatus status);

    // 查询热门标签（按博客数量排序）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.status = :status) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    List<Object[]> findPopularTags(@Param("status") ArticleStatus status, Pageable pageable);

    // 查询所有标签并按博客数量排序（支持分页，只统计已发布的博客）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.status = :status) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    List<Object[]> findTagsWithBlogCountOrderByCountDesc(@Param("status") ArticleStatus status, Pageable pageable);

    // 查找标签及其博客数量（按博客数量升序排序）
    @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE (b IS NULL OR b.status = :status) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    List<Object[]> findTagsWithBlogCountOrderByCountAsc(@Param("status") ArticleStatus status, Pageable pageable);

    // 根据关键词搜索标签及其博客数量（按博客数量降序排序）
    // @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE CONCAT('%', :keyword, '%') AND (b IS NULL OR b.status = :status) GROUP BY t ORDER BY COUNT(b) DESC, t.createdAt DESC")
    // List<Object[]> searchTagsWithBlogCountOrderByCountDesc(@Param("keyword") String keyword, @Param("status") ArticleStatus status, Pageable pageable);

    // 根据关键词搜索标签及其博客数量（按博客数量升序排序）
    // @Query("SELECT t, COUNT(b) as blogCount FROM Tag t LEFT JOIN t.blogs b WHERE t.name LIKE CONCAT('%', :keyword, '%') AND (b IS NULL OR b.status = :status) GROUP BY t ORDER BY COUNT(b) ASC, t.createdAt DESC")
    // List<Object[]> searchTagsWithBlogCountOrderByCountAsc(@Param("keyword") String keyword, @Param("status") ArticleStatus status, Pageable pageable);
}
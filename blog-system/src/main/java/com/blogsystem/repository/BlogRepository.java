package com.blogsystem.repository;

import com.blogsystem.entity.Blog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BlogRepository extends JpaRepository<Blog, Long> {

    // 查找已发布的博客
    Page<Blog> findByIsPublishedTrueOrderByCreatedAtDesc(Pageable pageable);

    // 根据标题搜索博客
    Page<Blog> findByTitleContainingIgnoreCaseAndIsPublishedTrue(String title, Pageable pageable);

    // 根据分类查找博客
    Page<Blog> findByCategoryAndIsPublishedTrueOrderByCreatedAtDesc(String category, Pageable pageable);

    // 根据作者查找博客
    Page<Blog> findByAuthorNameAndIsPublishedTrueOrderByCreatedAtDesc(String authorName, Pageable pageable);

    // 根据作者名称查找博客（包括未发布的）
    List<Blog> findByAuthorNameOrderByCreatedAtDesc(String authorName);

    // 查找热门博客（按浏览量排序）
    @Query("SELECT b FROM Blog b WHERE b.isPublished = true ORDER BY b.viewCount DESC")
    List<Blog> findPopularBlogs(Pageable pageable);

    // 查找最新博客
    @Query("SELECT b FROM Blog b WHERE b.isPublished = true ORDER BY b.createdAt DESC")
    List<Blog> findLatestBlogs(Pageable pageable);

    // 根据标签搜索博客
    @Query("SELECT b FROM Blog b WHERE b.tags LIKE %:tag% AND b.isPublished = true ORDER BY b.createdAt DESC")
    Page<Blog> findByTagsContaining(@Param("tag") String tag, Pageable pageable);

    // 获取所有分类
    @Query("SELECT DISTINCT b.category FROM Blog b WHERE b.category IS NOT NULL AND b.isPublished = true")
    List<String> findAllCategories();

    // 统计已发布博客数量
    long countByIsPublishedTrue();
}
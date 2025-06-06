package com.blogsystem.repository;

import com.blogsystem.entity.Blog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BlogRepository extends JpaRepository<Blog, Long> {

    // 查找已发布的博客
    Page<Blog> findByIsPublishedTrueOrderByCreatedAtDesc(Pageable pageable);
    
    // 查找已发布的博客（升序）
    Page<Blog> findByIsPublishedTrueOrderByCreatedAtAsc(Pageable pageable);

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
    @Query("SELECT DISTINCT b FROM Blog b JOIN b.tagEntities t WHERE t.name = :tag AND b.isPublished = true ORDER BY b.createdAt DESC")
    Page<Blog> findByTagsContaining(@Param("tag") String tag, Pageable pageable);

    // 获取所有分类
    @Query("SELECT DISTINCT b.category FROM Blog b WHERE b.category IS NOT NULL AND b.isPublished = true")
    List<String> findAllCategories();

    // 统计已发布博客数量
    long countByIsPublishedTrue();

    // 统计指定时间范围内已发布的博客数量
    long countByIsPublishedTrueAndCreatedAtBetween(LocalDateTime startDate, LocalDateTime endDate);

    // 管理员搜索所有博客（包括草稿）
    Page<Blog> findByTitleContainingIgnoreCase(String title, Pageable pageable);

    // 管理员搜索草稿博客
    Page<Blog> findByTitleContainingIgnoreCaseAndIsPublishedFalse(String title, Pageable pageable);

    // 获取草稿博客
    Page<Blog> findByIsPublishedFalseOrderByCreatedAtDesc(Pageable pageable);
    
    // 获取草稿博客（升序）
    Page<Blog> findByIsPublishedFalseOrderByCreatedAtAsc(Pageable pageable);

    // 多条件组合搜索博客
    @Query("SELECT DISTINCT b FROM Blog b LEFT JOIN b.tagEntities t WHERE " +
           "b.isPublished = true AND " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:category IS NULL OR b.category = :category) AND " +
           "(:tag IS NULL OR t.name = :tag)")
    Page<Blog> findBlogsWithFilters(@Param("keyword") String keyword, 
                                   @Param("category") String category, 
                                   @Param("tag") String tag, 
                                   Pageable pageable);

    // 按点赞数排序查询
    @Query("SELECT b FROM Blog b WHERE " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:category IS NULL OR b.category = :category) AND " +
           "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
           "b.isPublished = true ORDER BY b.likeCount DESC")
    Page<Blog> findBlogsWithFiltersOrderByLikes(@Param("keyword") String keyword,
                                              @Param("category") String category,
                                              @Param("tag") String tag,
                                              Pageable pageable);

    // 按浏览量排序查询
    @Query("SELECT b FROM Blog b WHERE " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:category IS NULL OR b.category = :category) AND " +
           "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
           "b.isPublished = true ORDER BY b.viewCount DESC")
    Page<Blog> findBlogsWithFiltersOrderByViews(@Param("keyword") String keyword,
                                              @Param("category") String category,
                                              @Param("tag") String tag,
                                              Pageable pageable);

    // 按热度排序查询（浏览量 + 点赞数 * 5）
    @Query("SELECT b FROM Blog b WHERE " +
           "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
           "(:category IS NULL OR b.category = :category) AND " +
           "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
           "b.isPublished = true ORDER BY (b.viewCount + b.likeCount * 5) DESC")
    Page<Blog> findBlogsWithFiltersOrderByPopularity(@Param("keyword") String keyword,
                                                    @Param("category") String category,
                                                    @Param("tag") String tag,
                                                    Pageable pageable);
}
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

       // 查找已发布的博客（按创建时间排序）
       Page<Blog> findByIsPublishedTrueOrderByCreatedAtDesc(Pageable pageable);

       // 查找已发布的博客（按创建时间升序）
       Page<Blog> findByIsPublishedTrueOrderByCreatedAtAsc(Pageable pageable);

       // 查找已发布的博客（按发布时间排序）
       Page<Blog> findByIsPublishedTrueOrderByPublishedAtDesc(Pageable pageable);

       // 查找已发布的博客（按发布时间升序）
       Page<Blog> findByIsPublishedTrueOrderByPublishedAtAsc(Pageable pageable);

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

       // 查找最新博客（按发布时间排序）
       @Query("SELECT b FROM Blog b WHERE b.isPublished = true ORDER BY b.publishedAt DESC")
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
                     "(:tag IS NULL OR t.name = :tag) ORDER BY b.createdAt DESC")
       Page<Blog> findBlogsWithFilters(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     Pageable pageable);

       // 按点赞数排序查询
       @Query("SELECT b FROM Blog b WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
                     "b.isPublished = true ORDER BY b.likeCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByLikes(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     Pageable pageable);

       // 按浏览量排序查询
       @Query("SELECT b FROM Blog b WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
                     "b.isPublished = true ORDER BY b.viewCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByViews(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     Pageable pageable);

       // 按热度排序查询（按浏览量降序排序）
       @Query("SELECT b FROM Blog b WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR b.tags LIKE CONCAT('%', :tag, '%')) AND " +
                     "b.isPublished = true ORDER BY b.viewCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByPopularity(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     Pageable pageable);

       // ========== 用户统计相关查询方法 ==========

       // 统计用户发布的文章数量
       long countByAuthorNameAndIsPublished(String authorName, boolean isPublished);

       // 获取用户文章的总浏览量
       @Query("SELECT SUM(b.viewCount) FROM Blog b WHERE b.authorName = :authorName AND b.isPublished = true")
       Long sumViewCountByAuthorName(@Param("authorName") String authorName);

       // 获取用户文章的总点赞量
       @Query("SELECT SUM(b.likeCount) FROM Blog b WHERE b.authorName = :authorName AND b.isPublished = true")
       Long sumLikeCountByAuthorName(@Param("authorName") String authorName);

       // 按月份统计用户发布文章数量（最近12个月）
       @Query("SELECT YEAR(b.createdAt) as year, MONTH(b.createdAt) as month, COUNT(b.id) as count " +
                     "FROM Blog b WHERE b.authorName = :authorName AND b.isPublished = true " +
                     "AND b.createdAt >= :startDate " +
                     "GROUP BY YEAR(b.createdAt), MONTH(b.createdAt) " +
                     "ORDER BY YEAR(b.createdAt) DESC, MONTH(b.createdAt) DESC")
       List<Object[]> findMonthlyPublishStatsByAuthor(@Param("authorName") String authorName,
                     @Param("startDate") LocalDateTime startDate);

       // 按分类统计用户文章数量
       @Query("SELECT b.category, COUNT(b.id) as count " +
                     "FROM Blog b WHERE b.authorName = :authorName AND b.isPublished = true " +
                     "GROUP BY b.category " +
                     "ORDER BY count DESC")
       List<Object[]> findCategoryStatsByAuthor(@Param("authorName") String authorName);

       // 获取用户最受欢迎的文章（按浏览量）
       Page<Blog> findByAuthorNameAndIsPublishedOrderByViewCountDesc(String authorName, boolean isPublished,
                     Pageable pageable);

       // 获取用户最受欢迎的文章（按点赞量）
       Page<Blog> findByAuthorNameAndIsPublishedOrderByLikeCountDesc(String authorName, boolean isPublished,
                     Pageable pageable);

       // 获取用户文章（支持分页）
       Page<Blog> findByAuthorNameAndIsPublished(String authorName, boolean isPublished, Pageable pageable);
}
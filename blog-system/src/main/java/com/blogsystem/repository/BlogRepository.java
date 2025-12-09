package com.blogsystem.repository;

import com.blogsystem.entity.Blog;
import com.blogsystem.enums.ArticleStatus;
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
       Page<Blog> findByStatusOrderByCreatedAtDesc(ArticleStatus status, Pageable pageable);

       // 查找已发布的博客（按创建时间升序）
       Page<Blog> findByStatusOrderByCreatedAtAsc(ArticleStatus status, Pageable pageable);

       // 查找已发布的博客（按发布时间排序）
       Page<Blog> findByStatusOrderByPublishedAtDesc(ArticleStatus status, Pageable pageable);

       // 查找已发布的博客（按发布时间升序）
       Page<Blog> findByStatusOrderByPublishedAtAsc(ArticleStatus status, Pageable pageable);

       // 根据标题搜索博客
       Page<Blog> findByTitleContainingIgnoreCaseAndStatus(String title, ArticleStatus status, Pageable pageable);

       // 根据分类查找博客
       Page<Blog> findByCategoryAndStatusOrderByCreatedAtDesc(String category, ArticleStatus status, Pageable pageable);

       // 根据作者查找博客
       Page<Blog> findByUserUsernameAndStatusOrderByCreatedAtDesc(String username, ArticleStatus status, Pageable pageable);

       // 根据作者名称查找博客（包括未发布的）
       List<Blog> findByUserUsernameOrderByCreatedAtDesc(String username);

       // 根据作者名称查找博客（包括未发布的），按发布时间和创建时间排序
       @Query("SELECT b FROM Blog b WHERE b.user.username = :username ORDER BY " +
              "CASE WHEN b.publishedAt IS NOT NULL THEN b.publishedAt " +
              "ELSE b.createdAt END DESC")
       List<Blog> findByUserUsernameOrderByPublishedAtDesc(@Param("username") String username);

       // 查找热门博客（按浏览量排序）
       @Query("SELECT b FROM Blog b WHERE b.status = :status ORDER BY b.viewCount DESC")
       List<Blog> findPopularBlogs(@Param("status") ArticleStatus status, Pageable pageable);

       // 查找最新博客（按发布时间排序）
       @Query("SELECT b FROM Blog b WHERE b.status = :status ORDER BY b.publishedAt DESC")
       List<Blog> findLatestBlogs(@Param("status") ArticleStatus status, Pageable pageable);

       // 根据标签搜索博客
       @Query("SELECT DISTINCT b FROM Blog b JOIN b.tagEntities t WHERE t.name = :tag AND b.status = :status ORDER BY b.createdAt DESC")
       Page<Blog> findByTagsContaining(@Param("tag") String tag, @Param("status") ArticleStatus status, Pageable pageable);

       // 获取所有分类
       @Query("SELECT DISTINCT b.category FROM Blog b WHERE b.category IS NOT NULL AND b.status = :status")
       List<String> findAllCategories(@Param("status") ArticleStatus status);

       // 统计已发布博客数量
       long countByStatus(ArticleStatus status);

       // 根据用户名查找博客
       List<Blog> findByUserUsername(String username);

       // 根据用户名和状态查找博客
       List<Blog> findByUserUsernameAndStatus(String username, ArticleStatus status);



       // 统计指定时间范围内已发布的博客数量
       long countByStatusAndCreatedAtBetween(ArticleStatus status, LocalDateTime startDate, LocalDateTime endDate);

       // 管理员搜索所有博客（包括草稿）
       Page<Blog> findByTitleContainingIgnoreCase(String title, Pageable pageable);

       // 多条件组合搜索博客
       @Query("SELECT DISTINCT b FROM Blog b LEFT JOIN b.tagEntities t WHERE " +
                     "b.status = :status AND " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND " +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR t.name = :tag) ORDER BY " +
                     "CASE WHEN b.publishedAt IS NOT NULL THEN b.publishedAt " +
                     "ELSE b.createdAt END DESC")
       Page<Blog> findBlogsWithFilters(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);

       // 按点赞数排序查询
       @Query("SELECT DISTINCT b FROM Blog b LEFT JOIN b.tagEntities t WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR t.name = :tag) AND " +
                     "b.status = :status ORDER BY b.likeCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByLikes(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);

       // 按浏览量排序查询
       @Query("SELECT DISTINCT b FROM Blog b LEFT JOIN b.tagEntities t WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR t.name = :tag) AND " +
                     "b.status = :status ORDER BY b.viewCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByViews(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);

       // 按热度排序查询（按浏览量降序排序）
       @Query("SELECT DISTINCT b FROM Blog b LEFT JOIN b.tagEntities t WHERE " +
                     "(:keyword IS NULL OR LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(b.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
                     +
                     "(:category IS NULL OR b.category = :category) AND " +
                     "(:tag IS NULL OR t.name = :tag) AND " +
                     "b.status = :status ORDER BY b.viewCount DESC")
       Page<Blog> findBlogsWithFiltersOrderByPopularity(@Param("keyword") String keyword,
                     @Param("category") String category,
                     @Param("tag") String tag,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);

       // ========== 用户统计相关查询方法 ==========

       // 统计用户发布的文章数量
       long countByUserUsernameAndStatus(String username, ArticleStatus status);

       // 统计用户在指定时间范围内发布的文章数量
       long countByUserUsernameAndStatusAndCreatedAtBetween(String username, ArticleStatus status, LocalDateTime startDate, LocalDateTime endDate);

       // 获取用户文章的总浏览量
       @Query("SELECT SUM(b.viewCount) FROM Blog b WHERE b.user.username = :username AND b.status = :status")
       Long sumViewCountByUserUsername(@Param("username") String username, @Param("status") ArticleStatus status);

       // 获取用户文章的总点赞量
       @Query("SELECT SUM(b.likeCount) FROM Blog b WHERE b.user.username = :username AND b.status = :status")
       Long sumLikeCountByUserUsername(@Param("username") String username, @Param("status") ArticleStatus status);

       // 按月份统计用户发布文章数量（最近12个月）
       @Query("SELECT YEAR(b.createdAt) as year, MONTH(b.createdAt) as month, COUNT(b.id) as count " +
                     "FROM Blog b WHERE b.user.username = :username AND b.status = :status " +
                     "AND b.createdAt >= :startDate " +
                     "GROUP BY YEAR(b.createdAt), MONTH(b.createdAt) " +
                     "ORDER BY YEAR(b.createdAt) DESC, MONTH(b.createdAt) DESC")
       List<Object[]> findMonthlyPublishStatsByUser(@Param("username") String username,
                     @Param("status") ArticleStatus status,
                     @Param("startDate") LocalDateTime startDate);

       // 按分类统计用户文章数量
       @Query("SELECT b.category, COUNT(b.id) as count " +
                     "FROM Blog b WHERE b.user.username = :username AND b.status = :status " +
                     "GROUP BY b.category " +
                     "ORDER BY count DESC")
       List<Object[]> findCategoryStatsByUser(@Param("username") String username, @Param("status") ArticleStatus status);

       // 获取用户最受欢迎的文章（按浏览量）
       Page<Blog> findByUserUsernameAndStatusOrderByViewCountDesc(String username, ArticleStatus status,
                     Pageable pageable);

       // 获取用户最受欢迎的文章（按点赞量）
       Page<Blog> findByUserUsernameAndStatusOrderByLikeCountDesc(String username, ArticleStatus status,
                     Pageable pageable);

       // 获取用户文章（支持分页）
       Page<Blog> findByUserUsernameAndStatus(String username, ArticleStatus status, Pageable pageable);

       // 统计用户总浏览量
       @Query("SELECT SUM(b.viewCount) FROM Blog b WHERE b.user.username = :username AND b.status = :status")
       Long getTotalViewsByUsername(@Param("username") String username, @Param("status") ArticleStatus status);

       // 统计用户总点赞数
       @Query("SELECT SUM(b.likeCount) FROM Blog b WHERE b.user.username = :username AND b.status = :status")
       Long getTotalLikesByUsername(@Param("username") String username, @Param("status") ArticleStatus status);

       // 获取用户最受欢迎的博客（按浏览量排序）
       @Query("SELECT b " +
                     "FROM Blog b WHERE b.user.username = :username AND b.status = :status " +
                     "ORDER BY b.viewCount DESC")
       List<Blog> getMostPopularBlogsByUsername(@Param("username") String username,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);

       // 获取用户最新的博客（按发布时间排序）
       @Query("SELECT b " +
                     "FROM Blog b WHERE b.user.username = :username AND b.status = :status " +
                     "ORDER BY COALESCE(b.publishedAt, b.createdAt) DESC")
       List<Blog> getLatestBlogsByUsername(@Param("username") String username,
                     @Param("status") ArticleStatus status,
                     Pageable pageable);
}
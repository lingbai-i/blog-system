package com.blogsystem.repository;

import com.blogsystem.entity.UserLike;
import com.blogsystem.entity.TargetType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserLikeRepository extends JpaRepository<UserLike, Long> {

    /**
     * 查找用户是否已点赞某篇文章
     */
    Optional<UserLike> findByUserIdAndTargetTypeAndTargetId(Long userId, TargetType targetType, Long targetId);

    /**
     * 检查用户是否已点赞某篇文章
     */
    boolean existsByUserIdAndTargetTypeAndTargetId(Long userId, TargetType targetType, Long targetId);

    /**
     * 获取用户点赞的所有文章ID列表
     */
    @Query("SELECT ul.targetId FROM UserLike ul WHERE ul.userId = :userId AND ul.targetType = :targetType ORDER BY ul.createdAt DESC")
    List<Long> findTargetIdsByUserIdAndTargetType(@Param("userId") Long userId, @Param("targetType") TargetType targetType);

    /**
     * 分页获取用户点赞的文章ID列表
     */
    @Query("SELECT ul.targetId FROM UserLike ul WHERE ul.userId = :userId AND ul.targetType = :targetType ORDER BY ul.createdAt DESC")
    Page<Long> findTargetIdsByUserIdAndTargetType(@Param("userId") Long userId, @Param("targetType") TargetType targetType, Pageable pageable);

    /**
     * 获取用户点赞的文章数量
     */
    long countByUserIdAndTargetType(Long userId, TargetType targetType);

    /**
     * 获取文章的点赞数量
     */
    long countByTargetTypeAndTargetId(TargetType targetType, Long targetId);

    /**
     * 删除用户对某篇文章的点赞
     */
    void deleteByUserIdAndTargetTypeAndTargetId(Long userId, TargetType targetType, Long targetId);

    /**
     * 获取最受欢迎的文章（按点赞数排序）
     */
    @Query("SELECT ul.targetId, COUNT(ul.id) as likeCount FROM UserLike ul WHERE ul.targetType = :targetType GROUP BY ul.targetId ORDER BY likeCount DESC")
    Page<Object[]> findMostLikedTargets(@Param("targetType") TargetType targetType, Pageable pageable);

    // 为了兼容现有代码，添加便捷方法
    default Optional<UserLike> findByUserIdAndBlogId(Long userId, Long blogId) {
        return findByUserIdAndTargetTypeAndTargetId(userId, TargetType.ARTICLE, blogId);
    }

    default boolean existsByUserIdAndBlogId(Long userId, Long blogId) {
        return existsByUserIdAndTargetTypeAndTargetId(userId, TargetType.ARTICLE, blogId);
    }

    default List<Long> findBlogIdsByUserId(Long userId) {
        return findTargetIdsByUserIdAndTargetType(userId, TargetType.ARTICLE);
    }

    default Page<Long> findBlogIdsByUserId(Long userId, Pageable pageable) {
        return findTargetIdsByUserIdAndTargetType(userId, TargetType.ARTICLE, pageable);
    }

    default long countByBlogId(Long blogId) {
        return countByTargetTypeAndTargetId(TargetType.ARTICLE, blogId);
    }

    default void deleteByUserIdAndBlogId(Long userId, Long blogId) {
        deleteByUserIdAndTargetTypeAndTargetId(userId, TargetType.ARTICLE, blogId);
    }

    default Page<Object[]> findMostLikedBlogs(Pageable pageable) {
        return findMostLikedTargets(TargetType.ARTICLE, pageable);
    }
}
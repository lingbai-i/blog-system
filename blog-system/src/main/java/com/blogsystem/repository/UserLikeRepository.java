package com.blogsystem.repository;

import com.blogsystem.entity.UserLike;
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
    Optional<UserLike> findByUserIdAndBlogId(Long userId, Long blogId);

    /**
     * 检查用户是否已点赞某篇文章
     */
    boolean existsByUserIdAndBlogId(Long userId, Long blogId);

    /**
     * 获取用户点赞的所有文章ID列表
     */
    @Query("SELECT ul.blogId FROM UserLike ul WHERE ul.userId = :userId ORDER BY ul.createdAt DESC")
    List<Long> findBlogIdsByUserId(@Param("userId") Long userId);

    /**
     * 分页获取用户点赞的文章ID列表
     */
    @Query("SELECT ul.blogId FROM UserLike ul WHERE ul.userId = :userId ORDER BY ul.createdAt DESC")
    Page<Long> findBlogIdsByUserId(@Param("userId") Long userId, Pageable pageable);

    /**
     * 获取用户点赞的文章数量
     */
    long countByUserId(Long userId);

    /**
     * 获取文章的点赞数量
     */
    long countByBlogId(Long blogId);

    /**
     * 删除用户对某篇文章的点赞
     */
    void deleteByUserIdAndBlogId(Long userId, Long blogId);



    /**
     * 获取最受欢迎的文章（按点赞数排序）
     */
    @Query("SELECT ul.blogId, COUNT(ul.id) as likeCount FROM UserLike ul GROUP BY ul.blogId ORDER BY likeCount DESC")
    Page<Object[]> findMostLikedBlogs(Pageable pageable);
}
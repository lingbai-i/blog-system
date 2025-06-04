package com.blogsystem.repository;

import com.blogsystem.entity.Comment;
import com.blogsystem.entity.Blog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {

    // 根据博客ID查找已审核的评论
    List<Comment> findByBlogAndIsApprovedTrueOrderByCreatedAtAsc(Blog blog);

    // 根据博客ID查找所有评论（包括未审核）
    List<Comment> findByBlogOrderByCreatedAtAsc(Blog blog);

    // 查找待审核的评论
    Page<Comment> findByIsApprovedFalseOrderByCreatedAtDesc(Pageable pageable);

    // 根据博客ID统计评论数量
    long countByBlogAndIsApprovedTrue(Blog blog);

    // 查找某个评论的回复
    List<Comment> findByParentAndIsApprovedTrueOrderByCreatedAtAsc(Comment parent);

    // 查找顶级评论（没有父评论）
    List<Comment> findByBlogAndParentIsNullAndIsApprovedTrueOrderByCreatedAtAsc(Blog blog);

    // 统计总评论数
    long countByIsApprovedTrue();
}
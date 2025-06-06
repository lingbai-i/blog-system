package com.blogsystem.service;

import com.blogsystem.entity.Comment;
import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.repository.CommentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CommentService {

    private final CommentRepository commentRepository;

    // 创建评论
    public Comment createComment(Comment comment) {
        return commentRepository.save(comment);
    }

    // 创建评论（简化方法）
    public Comment createComment(Blog blog, User user, String content, String authorName, String authorEmail) {
        Comment comment = new Comment();
        comment.setBlog(blog);
        comment.setUser(user);
        comment.setContent(content);
        comment.setAuthorName(authorName);
        comment.setAuthorEmail(authorEmail);
        comment.setIsApproved(true); // 直接通过，无需审核

        return commentRepository.save(comment);
    }

    // 创建回复评论
    public Comment createReply(Blog blog, User user, Comment parent, String content, String authorName,
            String authorEmail) {
        Comment reply = new Comment();
        reply.setBlog(blog);
        reply.setUser(user);
        reply.setParent(parent);
        reply.setContent(content);
        reply.setAuthorName(authorName);
        reply.setAuthorEmail(authorEmail);
        reply.setIsApproved(true); // 直接通过，无需审核

        return commentRepository.save(reply);
    }

    // 根据ID查找评论
    public Optional<Comment> findById(Long id) {
        return commentRepository.findById(id);
    }

    // 删除评论
    public void deleteComment(Long id) {
        commentRepository.deleteById(id);
    }

    // 获取博客的所有已审核评论
    public List<Comment> getApprovedCommentsByBlog(Blog blog) {
        return commentRepository.findByBlogAndIsApprovedTrueOrderByCreatedAtAsc(blog);
    }

    // 获取博客的所有评论（包括未审核）
    public List<Comment> getAllCommentsByBlog(Blog blog) {
        return commentRepository.findByBlogOrderByCreatedAtAsc(blog);
    }

    // 获取博客的顶级评论（不包括回复）
    public List<Comment> getTopLevelCommentsByBlog(Blog blog) {
        return commentRepository.findByBlogAndParentIsNullOrderByCreatedAtAsc(blog);
    }

    // 获取评论的回复
    public List<Comment> getRepliesByComment(Comment parent) {
        return commentRepository.findByParentOrderByCreatedAtAsc(parent);
    }

    // 获取待审核的评论（分页）
    public Page<Comment> getPendingComments(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return commentRepository.findByIsApprovedFalseOrderByCreatedAtDesc(pageable);
    }

    // 审核通过评论
    public Comment approveComment(Long id) {
        Optional<Comment> commentOpt = commentRepository.findById(id);
        if (commentOpt.isPresent()) {
            Comment comment = commentOpt.get();
            comment.setIsApproved(true);
            return commentRepository.save(comment);
        }
        return null;
    }

    // 拒绝评论
    public void rejectComment(Long id) {
        commentRepository.deleteById(id);
    }

    // 统计博客的评论数量
    public long getCommentCountByBlog(Blog blog) {
        return commentRepository.countByBlogAndIsApprovedTrue(blog);
    }

    // 获取总评论数
    public long getTotalApprovedComments() {
        return commentRepository.countByIsApprovedTrue();
    }

    // 批量审核评论
    public void approveComments(List<Long> commentIds) {
        for (Long id : commentIds) {
            approveComment(id);
        }
    }

    // 批量删除评论
    public void deleteComments(List<Long> commentIds) {
        for (Long id : commentIds) {
            deleteComment(id);
        }
    }
}
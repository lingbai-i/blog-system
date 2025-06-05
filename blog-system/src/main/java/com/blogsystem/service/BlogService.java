package com.blogsystem.service;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.repository.BlogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class BlogService {

    private final BlogRepository blogRepository;
    private final UserService userService;

    // 创建博客
    public Blog createBlog(Blog blog) {
        return blogRepository.save(blog);
    }

    // 更新博客
    public Blog updateBlog(Blog blog) {
        return blogRepository.save(blog);
    }

    // 根据ID查找博客
    public Optional<Blog> findById(Long id) {
        return blogRepository.findById(id);
    }

    // 根据ID查找博客并增加浏览量
    public Optional<Blog> findByIdAndIncrementView(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setViewCount(blog.getViewCount() + 1);
            blogRepository.save(blog);
        }
        return blogOpt;
    }

    // 删除博客
    public void deleteBlog(Long id) {
        blogRepository.deleteById(id);
    }

    // 获取所有已发布的博客（分页）
    public Page<Blog> findPublishedBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByIsPublishedTrueOrderByCreatedAtDesc(pageable);
    }

    // 搜索博客
    public Page<Blog> searchBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCaseAndIsPublishedTrue(keyword, pageable);
    }

    // 根据分类查找博客
    public Page<Blog> findBlogsByCategory(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByCategoryAndIsPublishedTrueOrderByCreatedAtDesc(category, pageable);
    }

    // 根据标签查找博客
    public Page<Blog> findBlogsByTag(String tag, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTagsContaining(tag, pageable);
    }

    // 获取热门博客
    public List<Blog> getPopularBlogs(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return blogRepository.findPopularBlogs(pageable);
    }

    // 获取最新博客
    public List<Blog> getLatestBlogs(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return blogRepository.findLatestBlogs(pageable);
    }

    // 获取所有分类
    public List<String> getAllCategories() {
        return blogRepository.findAllCategories();
    }

    // 发布博客
    public Blog publishBlog(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setIsPublished(true);
            return blogRepository.save(blog);
        }
        return null;
    }

    // 取消发布博客
    public Blog unpublishBlog(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setIsPublished(false);
            return blogRepository.save(blog);
        }
        return null;
    }

    // 点赞博客
    public Blog likeBlog(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setLikeCount(blog.getLikeCount() + 1);
            return blogRepository.save(blog);
        }
        return null;
    }

    // 根据用户ID获取博客
    public List<Blog> findBlogsByUserId(Long userId) {
        // 根据userId获取用户名
        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isPresent()) {
            String authorName = userOpt.get().getUsername();
            return blogRepository.findByAuthorNameOrderByCreatedAtDesc(authorName);
        }
        return new ArrayList<>();
    }

    // 获取博客总数
    public long getTotalPublishedBlogs() {
        return blogRepository.countByIsPublishedTrue();
    }
}
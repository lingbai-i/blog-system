package com.blogsystem.service;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.entity.Category;
import com.blogsystem.entity.Tag;
import com.blogsystem.repository.BlogRepository;
import com.blogsystem.service.CategoryService;
import com.blogsystem.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Lazy;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BlogService {

    private final BlogRepository blogRepository;
    private final UserService userService;
    private final CategoryService categoryService;
    private final TagService tagService;

    public BlogService(BlogRepository blogRepository,
            UserService userService,
            @Lazy CategoryService categoryService,
            @Lazy TagService tagService) {
        this.blogRepository = blogRepository;
        this.userService = userService;
        this.categoryService = categoryService;
        this.tagService = tagService;
    }

    // 创建博客
    public Blog createBlog(Blog blog) {
        // 处理分类
        if (blog.getCategory() != null && !blog.getCategory().trim().isEmpty()) {
            Optional<Category> categoryOpt = categoryService.findByName(blog.getCategory());
            if (categoryOpt.isPresent()) {
                blog.setCategoryEntity(categoryOpt.get());
            }
        }

        // 处理标签
        if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) {
            List<Tag> tagEntities = tagService.parseAndCreateTags(blog.getTags());
            blog.setTagEntities(tagEntities);
        }

        return blogRepository.save(blog);
    }

    // 更新博客
    public Blog updateBlog(Blog blog) {
        // 处理分类
        if (blog.getCategory() != null && !blog.getCategory().trim().isEmpty()) {
            Optional<Category> categoryOpt = categoryService.findByName(blog.getCategory());
            if (categoryOpt.isPresent()) {
                blog.setCategoryEntity(categoryOpt.get());
            }
        }

        // 处理标签
        if (blog.getTags() != null && !blog.getTags().trim().isEmpty()) {
            List<Tag> tagEntities = tagService.parseAndCreateTags(blog.getTags());
            blog.setTagEntities(tagEntities);
        }

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

    // 管理员搜索所有博客（包括草稿）
    public Page<Blog> searchAllBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCase(keyword, pageable);
    }

    // 管理员搜索草稿博客
    public Page<Blog> searchDraftBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCaseAndIsPublishedFalse(keyword, pageable);
    }

    // 获取所有博客（管理员）
    public Page<Blog> findAllBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return blogRepository.findAll(pageable);
    }

    // 获取草稿博客
    public Page<Blog> findDraftBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return blogRepository.findByIsPublishedFalseOrderByCreatedAtDesc(pageable);
    }

    // 获取博客总数
    public long getTotalBlogsCount() {
        return blogRepository.count();
    }

    // 获取已发布博客数量
    public long getPublishedBlogsCount() {
        return blogRepository.countByIsPublishedTrue();
    }

    // 更新博客状态
    public Blog updateBlogStatus(Long id, Boolean isPublished) {
        Blog blog = blogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("博客不存在"));
        blog.setIsPublished(isPublished);
        return blogRepository.save(blog);
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
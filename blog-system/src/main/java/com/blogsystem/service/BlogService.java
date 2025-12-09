package com.blogsystem.service;

import com.blogsystem.entity.Blog;
import com.blogsystem.entity.User;
import com.blogsystem.entity.UserLike;
import com.blogsystem.entity.TargetType;
import com.blogsystem.entity.Category;
import com.blogsystem.entity.Tag;
import com.blogsystem.enums.ArticleStatus;
import com.blogsystem.repository.BlogRepository;
import com.blogsystem.repository.UserLikeRepository;
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

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class BlogService {

    private final BlogRepository blogRepository;
    private final UserService userService;
    private final CommentService commentService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final UserLikeRepository userLikeRepository;

    public BlogService(BlogRepository blogRepository,
            UserService userService,
            @Lazy CommentService commentService,
            @Lazy CategoryService categoryService,
            @Lazy TagService tagService,
            UserLikeRepository userLikeRepository) {
        this.blogRepository = blogRepository;
        this.userService = userService;
        this.commentService = commentService;
        this.categoryService = categoryService;
        this.tagService = tagService;
        this.userLikeRepository = userLikeRepository;
    }

    // 创建博客
    public Blog createBlog(Blog blog) {
        // 处理发布时间
        if (blog.getStatus() != null && blog.getStatus() == ArticleStatus.PUBLISHED) {
            // 如果是发布状态，设置发布时间为当前时间
            blog.setPublishedAt(LocalDateTime.now());
        }
        
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
        // 获取原有博客数据
        Optional<Blog> existingBlogOpt = blogRepository.findById(blog.getId());
        if (existingBlogOpt.isPresent()) {
            Blog existingBlog = existingBlogOpt.get();
            
            // 处理发布时间逻辑
            if (blog.getStatus() != null && blog.getStatus() == ArticleStatus.PUBLISHED) {
                // 如果当前要发布文章
                if (existingBlog.getPublishedAt() == null) {
                    // 如果原来没有发布时间，设置为当前时间（首次发布）
                    blog.setPublishedAt(LocalDateTime.now());
                } else {
                    // 如果原来有发布时间，保持原有发布时间（再次编辑已发布文章）
                    blog.setPublishedAt(existingBlog.getPublishedAt());
                }
            } else {
                // 如果是草稿，保持原有发布时间（可能为null）
                blog.setPublishedAt(existingBlog.getPublishedAt());
            }
        }
        
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
        // 先查找博客
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            // 先删除相关评论
            commentService.deleteCommentsByBlog(blog);
            // 再删除博客
            blogRepository.deleteById(id);
        }
    }

    // 获取所有已发布的博客（分页）
    public Page<Blog> findPublishedBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByStatusOrderByCreatedAtAsc(ArticleStatus.PUBLISHED, pageable);
    }

    // 搜索博客
    public Page<Blog> searchBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCaseAndStatus(keyword, ArticleStatus.PUBLISHED, pageable);
    }

    // 根据分类查找博客
    public Page<Blog> findBlogsByCategory(String category, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByCategoryAndStatusOrderByCreatedAtDesc(category, ArticleStatus.PUBLISHED, pageable);
    }

    // 根据标签查找博客
    public Page<Blog> findBlogsByTag(String tag, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTagsContaining(tag, ArticleStatus.PUBLISHED, pageable);
    }

    // 多条件组合搜索博客
    public Page<Blog> searchBlogsWithFilters(String keyword, String category, String tag, String sort, int page,
            int size) {
        // 默认按发布时间降序排序（如果没有发布时间则按创建时间）
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "publishedAt"));

        // 如果没有任何过滤条件，根据排序方式返回所有已发布的博客
        if ((keyword == null || keyword.trim().isEmpty()) &&
                (category == null || category.trim().isEmpty()) &&
                (tag == null || tag.trim().isEmpty())) {

            // 根据排序方式使用不同的查询方法
            switch (sort) {
                case "liked":
                    return blogRepository.findBlogsWithFiltersOrderByLikes(null, null, null, ArticleStatus.PUBLISHED, pageable);
                case "popular":
                    return blogRepository.findBlogsWithFiltersOrderByPopularity(null, null, null, ArticleStatus.PUBLISHED, pageable);
                case "publishTime":
                default:
                    // 创建按发布时间降序排序的Pageable（查询中会自动处理publishedAt为空的情况）
                    Pageable publishTimePageable = PageRequest.of(page, size,
                            Sort.by(Sort.Direction.DESC, "publishedAt"));
                    return blogRepository.findBlogsWithFilters(null, null, null, ArticleStatus.PUBLISHED, publishTimePageable);
            }
        }

        // 使用对应的排序查询方法
        switch (sort) {
            case "liked":
                return blogRepository.findBlogsWithFiltersOrderByLikes(keyword, category, tag, ArticleStatus.PUBLISHED, pageable);
            case "popular":
                return blogRepository.findBlogsWithFiltersOrderByPopularity(keyword, category, tag, ArticleStatus.PUBLISHED, pageable);
            case "publishTime":
            default:
                // 创建按发布时间降序排序的Pageable（查询中会自动处理publishedAt为空的情况）
                Pageable publishTimePageable = PageRequest.of(page, size,
                        Sort.by(Sort.Direction.DESC, "publishedAt"));
                return blogRepository.findBlogsWithFilters(
                        keyword != null ? keyword.trim() : null,
                        category != null ? category.trim() : null,
                        tag != null ? tag.trim() : null,
                        ArticleStatus.PUBLISHED,
                        publishTimePageable);
        }
    }

    private Pageable createSortedPageable(int page, int size, String sort) {
        Sort sortOrder;
        switch (sort) {
            case "liked":
                sortOrder = Sort.by(Sort.Direction.DESC, "likeCount");
                break;
            case "popular":
                // 热度排序：按浏览量排序
                sortOrder = Sort.by(Sort.Direction.DESC, "viewCount");
                break;
            case "publishTime":
            default:
                sortOrder = Sort.by(Sort.Direction.DESC, "createdAt");
                break;
        }
        return PageRequest.of(page, size, sortOrder);
    }

    // 获取热门博客
    public List<Blog> getPopularBlogs(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return blogRepository.findPopularBlogs(ArticleStatus.PUBLISHED, pageable);
    }

    // 管理员搜索所有博客（包括草稿）
    public Page<Blog> searchAllBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCase(keyword, pageable);
    }

    // 管理员搜索草稿博客
    public Page<Blog> searchDraftBlogs(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return blogRepository.findByTitleContainingIgnoreCaseAndStatus(keyword, ArticleStatus.DRAFT, pageable);
    }

    // 获取所有博客（管理员）
    public Page<Blog> findAllBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "createdAt"));
        return blogRepository.findAll(pageable);
    }

    // 获取草稿博客
    public Page<Blog> findDraftBlogs(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "createdAt"));
        return blogRepository.findByStatusOrderByCreatedAtAsc(ArticleStatus.DRAFT, pageable);
    }

    // 获取博客总数
    public long getTotalBlogsCount() {
        return blogRepository.count();
    }

    // 获取已发布博客数量
    public long getPublishedBlogsCount() {
        return blogRepository.countByStatus(ArticleStatus.PUBLISHED);
    }

    // 获取总浏览量
    public long getTotalViewsCount() {
        return blogRepository.findAll().stream()
                .mapToLong(blog -> blog.getViewCount() != null ? blog.getViewCount() : 0)
                .sum();
    }

    // 获取今日发布的博客数量
    public long getTodayPublishedCount() {
        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(23, 59, 59);
        return blogRepository.countByStatusAndCreatedAtBetween(ArticleStatus.PUBLISHED, startOfDay, endOfDay);
    }

    // 更新博客状态
    public Blog updateBlogStatus(Long id, ArticleStatus status) {
        Blog blog = blogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("博客不存在"));
        blog.setStatus(status);
        return blogRepository.save(blog);
    }

    // 获取最新博客
    public List<Blog> getLatestBlogs(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return blogRepository.findLatestBlogs(ArticleStatus.PUBLISHED, pageable);
    }

    // 获取所有分类
    public List<String> getAllCategories() {
        return blogRepository.findAllCategories(ArticleStatus.PUBLISHED);
    }

    // 发布博客
    public Blog publishBlog(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setStatus(ArticleStatus.PUBLISHED);
            blog.setPublishedAt(LocalDateTime.now()); // 设置发布时间
            return blogRepository.save(blog);
        }
        return null;
    }

    // 取消发布博客
    public Blog unpublishBlog(Long id) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();
            blog.setStatus(ArticleStatus.DRAFT);
            return blogRepository.save(blog);
        }
        return null;
    }

    // 点赞博客
    public Blog likeBlog(Long id, Long userId) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();

            // 检查用户是否已经点赞过这篇博客
            if (!userLikeRepository.existsByUserIdAndBlogId(userId, id)) {
                // 增加博客点赞数
                blog.setLikeCount(blog.getLikeCount() + 1);

                // 创建用户点赞记录
                UserLike userLike = new UserLike(userId, TargetType.ARTICLE, id);
                userLikeRepository.save(userLike);

                return blogRepository.save(blog);
            }
        }
        return null;
    }

    // 取消点赞博客
    public Blog unlikeBlog(Long id, Long userId) {
        Optional<Blog> blogOpt = blogRepository.findById(id);
        if (blogOpt.isPresent()) {
            Blog blog = blogOpt.get();

            // 检查用户是否已经点赞过这篇博客
            Optional<UserLike> userLikeOpt = userLikeRepository.findByUserIdAndTargetTypeAndTargetId(userId, TargetType.ARTICLE, id);
            if (userLikeOpt.isPresent()) {
                // 减少博客点赞数
                blog.setLikeCount(Math.max(0, blog.getLikeCount() - 1));

                // 删除用户点赞记录
                userLikeRepository.delete(userLikeOpt.get());

                return blogRepository.save(blog);
            } else if (blog.getLikeCount() > 0) {
                // 如果用户没有点赞记录但博客点赞数大于0（兼容之前的数据）
                // 减少博客点赞数
                blog.setLikeCount(blog.getLikeCount() - 1);

                return blogRepository.save(blog);
            }
        }
        return null;
    }

    // 根据用户ID获取博客
    public List<Blog> findBlogsByUserId(Long userId) {
        // 根据userId获取用户名
        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isPresent()) {
            String username = userOpt.get().getUsername();
            return blogRepository.findByUserUsernameOrderByPublishedAtDesc(username);
        }
        return new ArrayList<>();
    }

    // 获取博客总数
    public long getTotalPublishedBlogs() {
        return blogRepository.countByStatus(ArticleStatus.PUBLISHED);
    }

    // 检查用户是否已点赞博客
    public boolean hasUserLikedBlog(Long blogId, Long userId) {
        return userLikeRepository.existsByUserIdAndBlogId(userId, blogId);
    }
}
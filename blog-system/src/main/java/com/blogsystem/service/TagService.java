package com.blogsystem.service;

import com.blogsystem.entity.Tag;
import com.blogsystem.repository.TagRepository;
import com.blogsystem.enums.ArticleStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class TagService {

    private final TagRepository tagRepository;

    // 创建标签
    public Tag createTag(Tag tag) {
        // 检查标签名称是否已存在
        if (tagRepository.findByName(tag.getName()).isPresent()) {
            throw new RuntimeException("标签名称已存在: " + tag.getName());
        }
        return tagRepository.save(tag);
    }

    // 更新标签
    public Tag updateTag(Long id, Tag tagDetails) {
        Optional<Tag> tagOpt = tagRepository.findById(id);
        if (tagOpt.isPresent()) {
            Tag tag = tagOpt.get();

            // 检查新名称是否与其他标签冲突
            Optional<Tag> existingTag = tagRepository.findByName(tagDetails.getName());
            if (existingTag.isPresent() && !existingTag.get().getId().equals(id)) {
                throw new RuntimeException("标签名称已存在: " + tagDetails.getName());
            }

            tag.setName(tagDetails.getName());
            tag.setColorCode(tagDetails.getColorCode());
            if (tagDetails.getUsageCount() != null) {
                tag.setUsageCount(tagDetails.getUsageCount());
            }

            return tagRepository.save(tag);
        }
        throw new RuntimeException("标签不存在，ID: " + id);
    }

    // 根据ID查找标签
    public Optional<Tag> findById(Long id) {
        return tagRepository.findById(id);
    }

    // 根据名称查找标签
    public Optional<Tag> findByName(String name) {
        return tagRepository.findByName(name);
    }

    // 获取所有激活的标签
    public List<Tag> getAllActiveTags() {
        return tagRepository.findAll();
    }

    // 分页获取所有标签
    public Page<Tag> getAllTags(int page, int size, String sort) {
        if ("usage_desc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            List<Object[]> results = tagRepository.findTagsWithBlogCountOrderByCountDesc(ArticleStatus.PUBLISHED, pageable);
            return new PageImpl<>(results.stream().map(result -> {
                Tag tag = (Tag) result[0];
                Long blogCount = (Long) result[1];
                tag.setBlogCount(blogCount);
                return tag;
            }).collect(Collectors.toList()), pageable, results.size());
        } else if ("usage_asc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            List<Object[]> results = tagRepository.findTagsWithBlogCountOrderByCountAsc(ArticleStatus.PUBLISHED, pageable);
            return new PageImpl<>(results.stream().map(result -> {
                Tag tag = (Tag) result[0];
                Long blogCount = (Long) result[1];
                tag.setBlogCount(blogCount);
                return tag;
            }).collect(Collectors.toList()), pageable, results.size());
        } else {
            Pageable pageable = createPageableWithSort(page, size, sort);
            return tagRepository.findAllByOrderByCreatedAtDesc(pageable);
        }
    }

    // 根据激活状态分页获取标签
    public Page<Tag> getTagsByStatus(Boolean isActive, int page, int size, String sort) {
        if ("usage_desc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            List<Object[]> results = tagRepository.findTagsWithBlogCountOrderByCountDesc(ArticleStatus.PUBLISHED, pageable);
            return new PageImpl<>(results.stream().map(result -> {
                Tag tag = (Tag) result[0];
                Long blogCount = (Long) result[1];
                tag.setBlogCount(blogCount);
                return tag;
            }).collect(Collectors.toList()), pageable, results.size());
        } else if ("usage_asc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            List<Object[]> results = tagRepository.findTagsWithBlogCountOrderByCountAsc(ArticleStatus.PUBLISHED, pageable);
            return new PageImpl<>(results.stream().map(result -> {
                Tag tag = (Tag) result[0];
                Long blogCount = (Long) result[1];
                tag.setBlogCount(blogCount);
                return tag;
            }).collect(Collectors.toList()), pageable, results.size());
        } else {
            Pageable pageable = createPageableWithSort(page, size, sort);
            return tagRepository.findAllByOrderByCreatedAtDesc(pageable);
        }
    }

    // 搜索标签
    public Page<Tag> searchTags(String keyword, Boolean isActive, int page, int size, String sort) {
        Pageable pageable = createPageableWithSort(page, size, sort);
        // 只按关键词搜索
        return tagRepository.findByNameContainingIgnoreCaseOrderByNameAsc(keyword, pageable);
    }

    // 删除标签
    public void deleteTag(Long id) {
        Optional<Tag> tagOpt = tagRepository.findById(id);
        if (tagOpt.isPresent()) {
            Tag tag = tagOpt.get();
            // 检查是否有关联的博客
            if (tag.getBlogs() != null && !tag.getBlogs().isEmpty()) {
                throw new RuntimeException("无法删除标签，存在关联的博客");
            }
            tagRepository.deleteById(id);
        } else {
            throw new RuntimeException("标签不存在，ID: " + id);
        }
    }

    // 启用/禁用标签
    public Tag toggleTagStatus(Long id) {
        Optional<Tag> tagOpt = tagRepository.findById(id);
        if (tagOpt.isPresent()) {
            Tag tag = tagOpt.get();
            // 由于移除了isActive字段，这个方法现在只返回标签本身
            return tag;
        }
        throw new RuntimeException("标签不存在，ID: " + id);
    }

    // 批量创建或获取标签
    public List<Tag> createOrGetTags(List<String> tagNames) {
        List<Tag> tags = new ArrayList<>();
        for (String tagName : tagNames) {
            if (tagName != null && !tagName.trim().isEmpty()) {
                String trimmedName = tagName.trim();
                Optional<Tag> existingTag = tagRepository.findByName(trimmedName);
                if (existingTag.isPresent()) {
                    tags.add(existingTag.get());
                } else {
                    Tag newTag = new Tag();
                    newTag.setName(trimmedName);
                    newTag.setColorCode("#007bff"); // 默认颜色
                    newTag.setUsageCount(0); // 初始使用次数为0
                    tags.add(tagRepository.save(newTag));
                }
            }
        }
        return tags;
    }

    // 从字符串解析标签（支持JSON数组格式和逗号分隔格式）
    public List<Tag> parseAndCreateTags(String tagsString) {
        if (tagsString == null || tagsString.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<String> tagNames = new ArrayList<>();
        
        try {
            // 检查是否是JSON数组格式
            if (tagsString.trim().startsWith("[") && tagsString.trim().endsWith("]")) {
                // 使用简单的JSON解析（避免引入额外依赖）
                String jsonContent = tagsString.trim().substring(1, tagsString.trim().length() - 1);
                if (!jsonContent.trim().isEmpty()) {
                    String[] jsonTags = jsonContent.split(",");
                    for (String jsonTag : jsonTags) {
                        String cleanTag = jsonTag.trim().replaceAll("^\"|\"$", "").trim();
                        if (!cleanTag.isEmpty()) {
                            tagNames.add(cleanTag);
                        }
                    }
                }
            } else {
                // 按逗号分割的传统格式
                tagNames = Arrays.stream(tagsString.split(","))
                        .map(String::trim)
                        .filter(name -> !name.isEmpty())
                        .collect(Collectors.toList());
            }
        } catch (Exception e) {
            // 如果JSON解析失败，回退到逗号分割格式
            tagNames = Arrays.stream(tagsString.split(","))
                    .map(String::trim)
                    .filter(name -> !name.isEmpty())
                    .collect(Collectors.toList());
        }

        return createOrGetTags(tagNames);
    }

    // 获取标签统计信息
    public List<Tag> getTagsWithBlogCount() {
        List<Object[]> results = tagRepository.findTagsWithBlogCount(ArticleStatus.PUBLISHED);
        return results.stream().map(result -> {
            Tag tag = (Tag) result[0];
            Long blogCount = (Long) result[1];
            tag.setBlogCount(blogCount);
            return tag;
        }).collect(Collectors.toList());
    }

    // 获取有博客的标签
    public List<Tag> getTagsWithPublishedBlogs() {
        return tagRepository.findTagsWithPublishedBlogs(ArticleStatus.PUBLISHED);
    }

    // 获取热门标签
    public List<Tag> getPopularTags(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        List<Object[]> results = tagRepository.findPopularTags(ArticleStatus.PUBLISHED, pageable);
        return results.stream().map(result -> {
            Tag tag = (Tag) result[0];
            Long blogCount = (Long) result[1];
            tag.setBlogCount(blogCount);
            return tag;
        }).collect(Collectors.toList());
    }

    // 统计激活的标签数量
    public long countActiveTags() {
        return tagRepository.count();
    }

    // 创建带排序的Pageable对象
    private Pageable createPageableWithSort(int page, int size, String sort) {
        if (sort == null || sort.trim().isEmpty()) {
            // 默认按创建时间降序排序
            return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        }

        switch (sort) {
            case "usage_desc":
                // 按使用频率降序排序（需要通过自定义查询实现）
                return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "blogCount"));
            case "usage_asc":
                // 按使用频率升序排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "blogCount"));
            case "created_desc":
                // 按创建时间降序排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
            case "created_asc":
                // 按创建时间升序排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "createdAt"));
            case "name_asc":
                // 按名称升序排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.ASC, "name"));
            case "name_desc":
                // 按名称降序排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "name"));
            default:
                // 默认排序
                return PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        }
    }

    // 将Object[]数组页面转换为Tag页面
    private Page<Tag> convertObjectArrayPageToTagPage(Page<Object[]> objectArrayPage) {
        List<Tag> tags = objectArrayPage.getContent().stream().map(result -> {
            Tag tag = (Tag) result[0];
            Long blogCount = (Long) result[1];
            tag.setBlogCount(blogCount);
            return tag;
        }).collect(Collectors.toList());

        return new PageImpl<>(tags, objectArrayPage.getPageable(), objectArrayPage.getTotalElements());
    }
}
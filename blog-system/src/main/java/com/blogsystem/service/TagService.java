package com.blogsystem.service;

import com.blogsystem.entity.Tag;
import com.blogsystem.repository.TagRepository;
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
            tag.setDescription(tagDetails.getDescription());
            tag.setColorCode(tagDetails.getColorCode());
            tag.setIsActive(tagDetails.getIsActive());

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
        return tagRepository.findByIsActiveTrueOrderByNameAsc();
    }

    // 分页获取所有标签
    public Page<Tag> getAllTags(int page, int size, String sort) {
        if ("usage_desc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Object[]> results = tagRepository.findAllTagsWithBlogCountOrderByUsageDesc(pageable);
            return convertObjectArrayPageToTagPage(results);
        } else if ("usage_asc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Object[]> results = tagRepository.findAllTagsWithBlogCountOrderByUsageAsc(pageable);
            return convertObjectArrayPageToTagPage(results);
        } else {
            Pageable pageable = createPageableWithSort(page, size, sort);
            return tagRepository.findAllByOrderByCreatedAtDesc(pageable);
        }
    }

    // 根据激活状态分页获取标签
    public Page<Tag> getTagsByStatus(Boolean isActive, int page, int size, String sort) {
        if ("usage_desc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Object[]> results = tagRepository.findTagsByStatusWithBlogCountOrderByUsageDesc(isActive, pageable);
            return convertObjectArrayPageToTagPage(results);
        } else if ("usage_asc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            Page<Object[]> results = tagRepository.findTagsByStatusWithBlogCountOrderByUsageAsc(isActive, pageable);
            return convertObjectArrayPageToTagPage(results);
        } else {
            Pageable pageable = createPageableWithSort(page, size, sort);
            return tagRepository.findByIsActiveOrderByCreatedAtDesc(isActive, pageable);
        }
    }

    // 搜索标签
    public Page<Tag> searchTags(String keyword, Boolean isActive, int page, int size, String sort) {
        if ("usage_desc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            if (isActive != null) {
                Page<Object[]> results = tagRepository.findTagsByKeywordAndStatusWithBlogCountOrderByUsageDesc(keyword,
                        isActive, pageable);
                return convertObjectArrayPageToTagPage(results);
            } else {
                Page<Object[]> results = tagRepository.findTagsByKeywordWithBlogCountOrderByUsageDesc(keyword,
                        pageable);
                return convertObjectArrayPageToTagPage(results);
            }
        } else if ("usage_asc".equals(sort)) {
            Pageable pageable = PageRequest.of(page, size);
            if (isActive != null) {
                Page<Object[]> results = tagRepository.findTagsByKeywordAndStatusWithBlogCountOrderByUsageAsc(keyword,
                        isActive, pageable);
                return convertObjectArrayPageToTagPage(results);
            } else {
                Page<Object[]> results = tagRepository.findTagsByKeywordWithBlogCountOrderByUsageAsc(keyword, pageable);
                return convertObjectArrayPageToTagPage(results);
            }
        } else {
            Pageable pageable = createPageableWithSort(page, size, sort);
            if (isActive != null) {
                // 如果指定了状态，按关键词和状态搜索
                return tagRepository.findByNameContainingIgnoreCaseAndIsActiveOrderByNameAsc(keyword, isActive,
                        pageable);
            } else {
                // 如果没有指定状态，只按关键词搜索
                return tagRepository.findByNameContainingIgnoreCaseOrderByNameAsc(keyword, pageable);
            }
        }
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
            tag.setIsActive(!tag.getIsActive());
            return tagRepository.save(tag);
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
                    Tag newTag = new Tag(trimmedName);
                    tags.add(tagRepository.save(newTag));
                }
            }
        }
        return tags;
    }

    // 从字符串解析标签（逗号分隔）
    public List<Tag> parseAndCreateTags(String tagsString) {
        if (tagsString == null || tagsString.trim().isEmpty()) {
            return new ArrayList<>();
        }

        List<String> tagNames = Arrays.stream(tagsString.split(","))
                .map(String::trim)
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());

        return createOrGetTags(tagNames);
    }

    // 获取标签统计信息
    public List<Tag> getTagsWithBlogCount() {
        List<Object[]> results = tagRepository.findTagsWithBlogCount();
        return results.stream().map(result -> {
            Tag tag = (Tag) result[0];
            Long blogCount = (Long) result[1];
            tag.setBlogCount(blogCount);
            return tag;
        }).collect(Collectors.toList());
    }

    // 获取有博客的标签
    public List<Tag> getTagsWithPublishedBlogs() {
        return tagRepository.findTagsWithPublishedBlogs();
    }

    // 获取热门标签
    public List<Tag> getPopularTags(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return tagRepository.findPopularTags(pageable);
    }

    // 统计激活的标签数量
    public long countActiveTags() {
        return tagRepository.countByIsActiveTrue();
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
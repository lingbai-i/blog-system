package com.blogsystem.service;

import com.blogsystem.entity.Tag;
import com.blogsystem.repository.TagRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
    public Page<Tag> getAllTags(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return tagRepository.findAllByOrderByCreatedAtDesc(pageable);
    }

    // 根据激活状态分页获取标签
    public Page<Tag> getTagsByStatus(Boolean isActive, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return tagRepository.findByIsActiveOrderByCreatedAtDesc(isActive, pageable);
    }

    // 搜索标签
    public Page<Tag> searchTags(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
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
}
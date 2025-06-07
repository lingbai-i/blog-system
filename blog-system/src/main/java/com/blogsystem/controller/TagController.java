package com.blogsystem.controller;

import com.blogsystem.entity.Tag;
import com.blogsystem.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/tags")
@RequiredArgsConstructor
@CrossOrigin(origins = { "http://localhost:3000", "http://127.0.0.1:3000" }, allowCredentials = "true")
public class TagController {

    private final TagService tagService;

    // 创建标签
    @PostMapping
    public ResponseEntity<?> createTag(@Valid @RequestBody Tag tag) {
        try {
            Tag createdTag = tagService.createTag(tag);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdTag);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 更新标签
    @PutMapping("/{id}")
    public ResponseEntity<?> updateTag(@PathVariable Long id, @Valid @RequestBody Tag tagDetails) {
        try {
            Tag updatedTag = tagService.updateTag(id, tagDetails);
            return ResponseEntity.ok(updatedTag);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 根据ID获取标签
    @GetMapping("/{id}")
    public ResponseEntity<?> getTagById(@PathVariable Long id) {
        Optional<Tag> tag = tagService.findById(id);
        if (tag.isPresent()) {
            return ResponseEntity.ok(tag.get());
        } else {
            Map<String, String> error = new HashMap<>();
            error.put("error", "标签不存在，ID: " + id);
            return ResponseEntity.notFound().build();
        }
    }

    // 获取所有激活的标签
    @GetMapping("/active")
    public ResponseEntity<List<Tag>> getAllActiveTags() {
        List<Tag> tags = tagService.getAllActiveTags();
        return ResponseEntity.ok(tags);
    }

    // 分页获取所有标签
    @GetMapping
    public ResponseEntity<Page<Tag>> getAllTags(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "30") int size,
            @RequestParam(required = false) String sort) {
        Page<Tag> tags = tagService.getAllTags(page, size, sort);
        return ResponseEntity.ok(tags);
    }

    // 根据激活状态分页获取标签
    @GetMapping("/status/{isActive}")
    public ResponseEntity<Page<Tag>> getTagsByStatus(
            @PathVariable Boolean isActive,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "30") int size,
            @RequestParam(required = false) String sort) {
        Page<Tag> tags = tagService.getTagsByStatus(isActive, page, size, sort);
        return ResponseEntity.ok(tags);
    }

    // 搜索标签
    @GetMapping("/search")
    public ResponseEntity<Page<Tag>> searchTags(
            @RequestParam String keyword,
            @RequestParam(required = false) Boolean isActive,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "30") int size,
            @RequestParam(required = false) String sort) {
        Page<Tag> tags = tagService.searchTags(keyword, isActive, page, size, sort);
        return ResponseEntity.ok(tags);
    }

    // 删除标签
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTag(@PathVariable Long id) {
        try {
            tagService.deleteTag(id);
            Map<String, String> response = new HashMap<>();
            response.put("message", "标签删除成功");
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 启用/禁用标签
    @PatchMapping("/{id}/toggle-status")
    public ResponseEntity<?> toggleTagStatus(@PathVariable Long id) {
        try {
            Tag tag = tagService.toggleTagStatus(id);
            return ResponseEntity.ok(tag);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    // 批量创建或获取标签
    @PostMapping("/batch")
    public ResponseEntity<List<Tag>> createOrGetTags(@RequestBody List<String> tagNames) {
        List<Tag> tags = tagService.createOrGetTags(tagNames);
        return ResponseEntity.ok(tags);
    }

    // 从字符串解析标签
    @PostMapping("/parse")
    public ResponseEntity<List<Tag>> parseAndCreateTags(@RequestBody Map<String, String> request) {
        String tagsString = request.get("tags");
        List<Tag> tags = tagService.parseAndCreateTags(tagsString);
        return ResponseEntity.ok(tags);
    }

    // 获取标签统计信息
    @GetMapping("/stats")
    public ResponseEntity<List<Tag>> getTagsWithBlogCount() {
        List<Tag> tags = tagService.getTagsWithBlogCount();
        return ResponseEntity.ok(tags);
    }

    // 获取有博客的标签
    @GetMapping("/with-blogs")
    public ResponseEntity<List<Tag>> getTagsWithPublishedBlogs() {
        List<Tag> tags = tagService.getTagsWithPublishedBlogs();
        return ResponseEntity.ok(tags);
    }

    // 获取热门标签
    @GetMapping("/popular")
    public ResponseEntity<List<Tag>> getPopularTags(
            @RequestParam(defaultValue = "10") int limit) {
        List<Tag> tags = tagService.getPopularTags(limit);
        return ResponseEntity.ok(tags);
    }

    // 获取标签统计数据
    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getTagDashboard() {
        Map<String, Object> dashboard = new HashMap<>();
        dashboard.put("totalTags", tagService.getAllActiveTags().size());
        dashboard.put("activeTags", tagService.countActiveTags());
        dashboard.put("tagsWithBlogs", tagService.getTagsWithPublishedBlogs().size());
        dashboard.put("popularTags", tagService.getPopularTags(5));
        dashboard.put("tagsStats", tagService.getTagsWithBlogCount());
        return ResponseEntity.ok(dashboard);
    }
}
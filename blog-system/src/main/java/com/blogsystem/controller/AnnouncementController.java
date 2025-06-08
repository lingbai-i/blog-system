package com.blogsystem.controller;

import com.blogsystem.entity.Announcement;
import com.blogsystem.service.AnnouncementService;
import com.blogsystem.utils.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/announcements")
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class AnnouncementController {

    @Autowired
    private AnnouncementService announcementService;

    // 获取所有已发布的公告（用户端）
    @GetMapping("/published")
    public ResponseEntity<ApiResponse<List<Announcement>>> getPublishedAnnouncements() {
        List<Announcement> announcements = announcementService.getPublishedAnnouncements();
        return ResponseEntity.ok(ApiResponse.success(announcements));
    }

    // 获取置顶公告（用户端）
    @GetMapping("/pinned")
    public ResponseEntity<ApiResponse<List<Announcement>>> getPinnedAnnouncements() {
        List<Announcement> announcements = announcementService.getPinnedAnnouncements();
        return ResponseEntity.ok(ApiResponse.success(announcements));
    }

    // 根据ID获取公告详情
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Announcement>> getAnnouncementById(@PathVariable Long id) {
        Optional<Announcement> announcement = announcementService.getAnnouncementById(id);
        if (announcement.isPresent()) {
            return ResponseEntity.ok(ApiResponse.success(announcement.get()));
        }
        return ResponseEntity.status(404).body(ApiResponse.error("公告不存在"));
    }
}
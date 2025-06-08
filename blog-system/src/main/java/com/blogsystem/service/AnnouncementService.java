package com.blogsystem.service;

import com.blogsystem.entity.Announcement;
import com.blogsystem.repository.AnnouncementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AnnouncementService {

    @Autowired
    private AnnouncementRepository announcementRepository;

    // 获取所有公告（管理员用）
    public List<Announcement> getAllAnnouncements() {
        return announcementRepository.findAllByOrderByCreatedAtDesc();
    }

    // 获取所有已发布的公告（用户用）
    public List<Announcement> getPublishedAnnouncements() {
        return announcementRepository.findByIsPublishedTrueOrderByPublishedAtDesc();
    }

    // 获取置顶公告
    public List<Announcement> getPinnedAnnouncements() {
        return announcementRepository.findByIsPublishedTrueAndIsPinnedTrueOrderByPublishedAtDesc();
    }

    // 根据ID获取公告
    public Optional<Announcement> getAnnouncementById(Long id) {
        return announcementRepository.findById(id);
    }

    // 创建公告
    public Announcement createAnnouncement(Announcement announcement) {
        announcement.setCreatedAt(LocalDateTime.now());
        announcement.setUpdatedAt(LocalDateTime.now());
        return announcementRepository.save(announcement);
    }

    // 更新公告
    public Announcement updateAnnouncement(Long id, Announcement updatedAnnouncement) {
        Optional<Announcement> existingAnnouncement = announcementRepository.findById(id);
        if (existingAnnouncement.isPresent()) {
            Announcement announcement = existingAnnouncement.get();
            announcement.setTitle(updatedAnnouncement.getTitle());
            announcement.setContent(updatedAnnouncement.getContent());
            announcement.setUpdatedAt(LocalDateTime.now());
            return announcementRepository.save(announcement);
        }
        return null;
    }

    // 发布公告
    public Announcement publishAnnouncement(Long id) {
        Optional<Announcement> announcementOpt = announcementRepository.findById(id);
        if (announcementOpt.isPresent()) {
            Announcement announcement = announcementOpt.get();
            announcement.setIsPublished(true);
            announcement.setPublishedAt(LocalDateTime.now());
            announcement.setUpdatedAt(LocalDateTime.now());
            return announcementRepository.save(announcement);
        }
        return null;
    }

    // 取消发布公告
    public Announcement unpublishAnnouncement(Long id) {
        Optional<Announcement> announcementOpt = announcementRepository.findById(id);
        if (announcementOpt.isPresent()) {
            Announcement announcement = announcementOpt.get();
            announcement.setIsPublished(false);
            announcement.setUpdatedAt(LocalDateTime.now());
            return announcementRepository.save(announcement);
        }
        return null;
    }

    // 置顶/取消置顶公告
    public Announcement togglePinAnnouncement(Long id) {
        Optional<Announcement> announcementOpt = announcementRepository.findById(id);
        if (announcementOpt.isPresent()) {
            Announcement announcement = announcementOpt.get();
            announcement.setIsPinned(!announcement.getIsPinned());
            announcement.setUpdatedAt(LocalDateTime.now());
            return announcementRepository.save(announcement);
        }
        return null;
    }

    // 删除公告
    public boolean deleteAnnouncement(Long id) {
        if (announcementRepository.existsById(id)) {
            announcementRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // 获取公告统计信息
    public long getPublishedAnnouncementCount() {
        return announcementRepository.countPublishedAnnouncements();
    }

    public long getPinnedAnnouncementCount() {
        return announcementRepository.countPinnedAnnouncements();
    }

    public long getTotalAnnouncementCount() {
        return announcementRepository.count();
    }

    // 分页获取所有公告（管理员用）
    public Page<Announcement> findAllAnnouncements(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return announcementRepository.findAll(pageable);
    }

    // 搜索公告（管理员用）
    public Page<Announcement> searchAnnouncements(String keyword, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        return announcementRepository.findByTitleContainingIgnoreCase(keyword, pageable);
    }
}
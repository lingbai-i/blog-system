package com.blogsystem.repository;

import com.blogsystem.entity.Announcement;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnnouncementRepository extends JpaRepository<Announcement, Long> {

    // 查找所有已发布的公告，按发布时间倒序
    List<Announcement> findByIsPublishedTrueOrderByPublishedAtDesc();

    // 查找所有已发布的公告，置顶公告在前，然后按发布时间倒序
    @Query("SELECT a FROM Announcement a WHERE a.isPublished = true ORDER BY a.isPinned DESC, a.publishedAt DESC")
    List<Announcement> findPublishedAnnouncementsOrderByPinnedAndPublishedAt();

    // 查找所有置顶的已发布公告
    List<Announcement> findByIsPublishedTrueAndIsPinnedTrueOrderByPublishedAtDesc();

    // 查找所有公告，按创建时间倒序（管理员用）
    List<Announcement> findAllByOrderByCreatedAtDesc();

    // 根据发布状态查找公告
    List<Announcement> findByIsPublishedOrderByCreatedAtDesc(Boolean isPublished);

    // 统计已发布的公告数量
    @Query("SELECT COUNT(a) FROM Announcement a WHERE a.isPublished = true")
    long countPublishedAnnouncements();

    // 统计置顶公告数量
    @Query("SELECT COUNT(a) FROM Announcement a WHERE a.isPublished = true AND a.isPinned = true")
    long countPinnedAnnouncements();

    // 分页搜索公告（按标题）
    Page<Announcement> findByTitleContainingIgnoreCase(String title, Pageable pageable);
}
package com.blogsystem.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/upload")
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class FileUploadController {

    @Value("${file.upload.path:uploads}")
    private String uploadPath;

    @Value("${file.upload.max-size:10485760}") // 10MB
    private long maxFileSize;

    private static final Set<String> ALLOWED_IMAGE_TYPES = Set.of(
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
        ".jpg", ".jpeg", ".png", ".gif", ".webp"
    );

    /**
     * 上传用户头像
     */
    @PostMapping("/avatar")
    public ResponseEntity<Map<String, Object>> uploadAvatar(@RequestParam("file") MultipartFile file) {
        return uploadSingleImage(file, "avatars");
    }

    /**
     * 上传文章图片（单张）
     */
    @PostMapping("/article-image")
    public ResponseEntity<Map<String, Object>> uploadArticleImage(@RequestParam("file") MultipartFile file) {
        return uploadSingleImage(file, "articles");
    }

    /**
     * 通用图片上传接口（用于评论等场景）
     */
    @PostMapping("/image")
    public ResponseEntity<Map<String, Object>> uploadImage(@RequestParam("file") MultipartFile file) {
        return uploadSingleImage(file, "comments");
    }

    /**
     * 批量上传文章图片（最多9张）
     */
    @PostMapping("/article-images")
    public ResponseEntity<Map<String, Object>> uploadArticleImages(@RequestParam("files") MultipartFile[] files) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 检查文件数量限制
            if (files.length > 9) {
                response.put("success", false);
                response.put("message", "最多只能上传9张图片");
                return ResponseEntity.badRequest().body(response);
            }

            List<String> uploadedUrls = new ArrayList<>();
            List<String> failedFiles = new ArrayList<>();

            for (MultipartFile file : files) {
                try {
                    ResponseEntity<Map<String, Object>> result = uploadSingleImage(file, "articles");
                    if (result.getStatusCode().is2xxSuccessful()) {
                        Map<String, Object> resultBody = result.getBody();
                        if (resultBody != null && (Boolean) resultBody.get("success")) {
                            uploadedUrls.add((String) resultBody.get("url"));
                        } else {
                            failedFiles.add(file.getOriginalFilename());
                        }
                    } else {
                        failedFiles.add(file.getOriginalFilename());
                    }
                } catch (Exception e) {
                    failedFiles.add(file.getOriginalFilename());
                }
            }

            response.put("success", true);
            response.put("uploadedCount", uploadedUrls.size());
            response.put("totalCount", files.length);
            response.put("urls", uploadedUrls);
            
            if (!failedFiles.isEmpty()) {
                response.put("failedFiles", failedFiles);
                response.put("message", "部分文件上传失败: " + String.join(", ", failedFiles));
            } else {
                response.put("message", "所有图片上传成功");
            }

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "批量上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 通用的单文件上传方法
     */
    private ResponseEntity<Map<String, Object>> uploadSingleImage(MultipartFile file, String subDir) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 验证文件
            String validationError = validateFile(file);
            if (validationError != null) {
                response.put("success", false);
                response.put("message", validationError);
                return ResponseEntity.badRequest().body(response);
            }

            // 创建上传目录
            String dateDir = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            String fullUploadPath = uploadPath + File.separator + subDir + File.separator + dateDir;
            Path uploadDir = Paths.get(fullUploadPath);
            
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = getFileExtension(originalFilename);
            String newFilename = UUID.randomUUID().toString() + extension;
            
            // 保存文件
            Path filePath = uploadDir.resolve(newFilename);
            Files.copy(file.getInputStream(), filePath);

            // 生成访问URL
            String fileUrl = "/uploads/" + subDir + "/" + dateDir.replace("\\", "/") + "/" + newFilename;
            
            response.put("success", true);
            response.put("message", "文件上传成功");
            response.put("url", fileUrl);
            response.put("filename", newFilename);
            response.put("originalFilename", originalFilename);
            response.put("size", file.getSize());
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "文件保存失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "上传失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 验证上传的文件
     */
    private String validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            return "文件不能为空";
        }

        if (file.getSize() > maxFileSize) {
            return "文件大小不能超过 " + (maxFileSize / 1024 / 1024) + "MB";
        }

        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_IMAGE_TYPES.contains(contentType.toLowerCase())) {
            return "只支持 JPG、PNG、GIF、WebP 格式的图片";
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            return "文件名不能为空";
        }

        String extension = getFileExtension(originalFilename).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            return "不支持的文件扩展名";
        }

        return null; // 验证通过
    }

    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null || filename.lastIndexOf('.') == -1) {
            return "";
        }
        return filename.substring(filename.lastIndexOf('.'));
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/delete")
    public ResponseEntity<Map<String, Object>> deleteFile(@RequestParam("url") String fileUrl) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 从URL中提取文件路径
            if (fileUrl.startsWith("/uploads/")) {
                String relativePath = fileUrl.substring("/uploads/".length());
                Path filePath = Paths.get(uploadPath, relativePath);
                
                if (Files.exists(filePath)) {
                    Files.delete(filePath);
                    response.put("success", true);
                    response.put("message", "文件删除成功");
                } else {
                    response.put("success", false);
                    response.put("message", "文件不存在");
                }
            } else {
                response.put("success", false);
                response.put("message", "无效的文件URL");
            }
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "删除失败: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}
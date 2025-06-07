package com.blogsystem.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload.path:uploads}")
    private String uploadPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的静态资源访问
        String absoluteUploadPath = new File(uploadPath).getAbsolutePath() + File.separator;
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absoluteUploadPath)
                .setCachePeriod(3600); // 缓存1小时
        
        // 保持默认的静态资源配置
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600);
    }
}
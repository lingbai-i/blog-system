package com.blogsystem.enums;

/**
 * 文章状态枚举
 */
public enum ArticleStatus {
    DRAFT("草稿"),
    PUBLISHED("已发布"),
    ARCHIVED("已归档");

    private final String description;

    ArticleStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    @Override
    public String toString() {
        return description;
    }
}
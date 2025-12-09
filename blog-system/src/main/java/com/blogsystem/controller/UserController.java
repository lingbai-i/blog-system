package com.blogsystem.controller;

import com.blogsystem.entity.User;
import com.blogsystem.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = { "http://localhost:*", "http://127.0.0.1:*" }, allowCredentials = "true")
public class UserController {

    private final UserService userService;

    // 用户注册
    @PostMapping("/register")
    public ResponseEntity<Object> registerUser(@RequestBody Map<String, String> request) {
        try {
            String username = request.get("username");
            String email = request.get("email");
            String password = request.get("password");
            String nickname = request.get("nickname"); // 可选字段

            // email字段为可选，如果为空则设置为null
            if (email != null && email.trim().isEmpty()) {
                email = null;
            }

            if (nickname == null || nickname.trim().isEmpty()) {
                nickname = username; // 如果没有提供nickname，使用username作为默认值
            }

            User user = userService.registerUser(username, email, password, nickname);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "注册成功");
            response.put("user", user);

            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());

            return ResponseEntity.badRequest().body(response);
        }
    }

    // 用户登录
    @PostMapping("/login")
    public ResponseEntity<Object> loginUser(@RequestBody Map<String, String> request) {
        String account = request.get("account");
        String username = request.get("username");
        String password = request.get("password");

        // 如果没有account字段，使用username字段
        if (account == null && username != null) {
            account = username;
        }

        Optional<User> userOpt = userService.authenticate(account, password);

        Map<String, Object> response = new HashMap<>();
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // 生成简单的token（实际项目中应使用JWT）
            String token = "token_" + user.getId() + "_" + System.currentTimeMillis();

            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", user);

            response.put("success", true);
            response.put("message", "登录成功");
            response.put("data", data);
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "用户名/邮箱或密码错误");
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 获取用户信息
    @GetMapping("/user/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = userService.findById(id);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 更新用户信息
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        Optional<User> existingUser = userService.findById(id);
        if (existingUser.isPresent()) {
            user.setId(id);
            // 保持原有的密码和创建时间
            user.setPassword(existingUser.get().getPassword());
            user.setCreatedAt(existingUser.get().getCreatedAt());

            User updatedUser = userService.updateUser(user);
            return ResponseEntity.ok(updatedUser);
        }
        return ResponseEntity.notFound().build();
    }

    // 修改密码
    @PutMapping("/{id}/password")
    public ResponseEntity<Object> changePassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String oldPassword = request.get("oldPassword");
        String newPassword = request.get("newPassword");

        boolean success = userService.changePassword(id, oldPassword, newPassword);

        Map<String, Object> response = new HashMap<>();
        if (success) {
            response.put("success", true);
            response.put("message", "密码修改成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "原密码错误");
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 删除用户
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        Optional<User> user = userService.findById(id);
        if (user.isPresent()) {
            userService.deleteUser(id);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    // 获取所有用户（管理员功能）
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    // 检查用户名是否存在
    @GetMapping("/check-username/{username}")
    public ResponseEntity<Object> checkUsername(@PathVariable String username) {
        boolean exists = userService.existsByUsername(username);
        Map<String, Object> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 检查邮箱是否存在
    @GetMapping("/check-email/{email}")
    public ResponseEntity<Object> checkEmail(@PathVariable String email) {
        boolean exists = userService.existsByEmail(email);
        Map<String, Object> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    // 设置管理员权限
    @PutMapping("/{id}/admin")
    public ResponseEntity<User> setAdminRole(
            @PathVariable Long id,
            @RequestBody Map<String, Boolean> request) {
        Boolean isAdmin = request.get("isAdmin");
        User user = userService.setAdminRole(id, isAdmin);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.notFound().build();
    }

    // 根据用户名获取用户
    @GetMapping("/username/{username}")
    public ResponseEntity<User> getUserByUsername(@PathVariable String username) {
        Optional<User> user = userService.findByUsername(username);
        return user.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 获取当前用户资料
    @GetMapping("/profile")
    public ResponseEntity<Object> getCurrentUserProfile(HttpServletRequest request) {
        // 从Authorization头中获取token
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            // 解析token获取用户ID（token格式：token_userId_timestamp）
            try {
                String[] parts = token.split("_");
                if (parts.length >= 2) {
                    Long userId = Long.parseLong(parts[1]);
                    Optional<User> userOpt = userService.findById(userId);
                    if (userOpt.isPresent()) {
                        User user = userOpt.get();
                        Map<String, Object> profile = new HashMap<>();
                        profile.put("id", user.getId());
                        profile.put("username", user.getUsername());
                        profile.put("email", user.getEmail() != null ? user.getEmail() : "");
                        profile.put("bio", user.getBio() != null ? user.getBio() : "");
                        profile.put("avatar_url", user.getAvatar() != null ? user.getAvatar() : "");
                        profile.put("role", user.getIsAdmin() ? "admin" : "user");
                        profile.put("createdAt", user.getCreatedAt());
                        return ResponseEntity.ok(profile);
                    }
                }
            } catch (NumberFormatException e) {
                // token格式错误
            }
        }

        // 如果token无效或解析失败，返回默认信息
        Map<String, Object> profile = new HashMap<>();
        profile.put("id", 0L);
        profile.put("username", "testuser");
        profile.put("email", "");
        profile.put("bio", "");
        profile.put("avatar_url", "");
        profile.put("role", "user");
        profile.put("createdAt", "2024-01-01T00:00:00");
        return ResponseEntity.ok(profile);
    }

    // 更新当前用户资料
    @PutMapping("/profile")
    public ResponseEntity<Object> updateCurrentUserProfile(@RequestBody Map<String, String> request,
            HttpServletRequest httpRequest) {
        try {
            String username = request.get("username");
            String email = request.get("email");
            String bio = request.get("bio");
            String avatar = request.get("avatar");

            // 从Authorization头中获取token
            String authHeader = httpRequest.getHeader("Authorization");
            Long currentUserId = null;

            System.out.println("[DEBUG] Authorization Header: " + authHeader);

            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                System.out.println("[DEBUG] Token: " + token);
                // 解析token获取用户ID（token格式：token_userId_timestamp）
                try {
                    String[] parts = token.split("_");
                    System.out.println("[DEBUG] Token parts: " + java.util.Arrays.toString(parts));
                    if (parts.length >= 2) {
                        currentUserId = Long.parseLong(parts[1]);
                        System.out.println("[DEBUG] Parsed User ID: " + currentUserId);
                    }
                } catch (NumberFormatException e) {
                    System.out.println("[DEBUG] Token格式错误: " + e.getMessage());
                }
            }

            if (currentUserId == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "无效的认证信息");
                return ResponseEntity.status(401).body(response);
            }

            // 验证用户名
            if (username != null && !username.trim().isEmpty()) {
                if (username.trim().length() < 2 || username.trim().length() > 20) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("message", "用户名长度必须在2-20个字符之间");
                    return ResponseEntity.badRequest().body(response);
                }

                // 检查用户名是否已存在（排除当前用户）
                Optional<User> existingUser = userService.findByUsername(username.trim());
                if (existingUser.isPresent() && !existingUser.get().getId().equals(currentUserId)) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("message", "用户名已存在");
                    return ResponseEntity.badRequest().body(response);
                }
            }

            // 验证邮箱格式
            if (email != null && !email.trim().isEmpty()) {
                if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("message", "邮箱格式不正确");
                    return ResponseEntity.badRequest().body(response);
                }

                // 检查邮箱是否已存在（排除当前用户）
                Optional<User> existingEmailUser = userService.findByEmail(email.trim());
                if (existingEmailUser.isPresent() && !existingEmailUser.get().getId().equals(currentUserId)) {
                    Map<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("message", "邮箱已被使用");
                    return ResponseEntity.badRequest().body(response);
                }
            }

            // 更新用户信息
            Optional<User> userOpt = userService.findById(currentUserId);
            if (userOpt.isPresent()) {
                User user = userOpt.get();

                // 更新用户名
                if (username != null && !username.trim().isEmpty()) {
                    user.setUsername(username.trim());
                }

                // 更新邮箱（只有当邮箱真正改变时才更新）
                if (email != null && !email.trim().isEmpty()) {
                    String newEmail = email.trim();
                    if (!newEmail.equals(user.getEmail())) {
                        user.setEmail(newEmail);
                    }
                } else if (email != null && email.trim().isEmpty()) {
                    // 如果传入空字符串，则清空邮箱
                    user.setEmail(null);
                }

                // 更新简介
                if (bio != null) {
                    user.setBio(bio.trim().isEmpty() ? null : bio.trim());
                }

                // 更新头像
                if (avatar != null) {
                    user.setAvatar(avatar.trim().isEmpty() ? null : avatar.trim());
                }

                userService.updateUser(user);

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "个人资料更新成功");
                response.put("user", user);

                return ResponseEntity.ok(response);
            } else {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "用户不存在");
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "更新失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}